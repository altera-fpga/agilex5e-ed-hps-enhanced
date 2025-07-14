import time
import subprocess
from enum import IntEnum
from .registers import TRAFFIC_REGISTERS_10G as TRAFF_REG
from .registers import CTRL_REGISTERS_10G as CTRL_REG
from .registers import DATA_CNF, TG_ID

class status(IntEnum):
    success = 1
    fail   = 0
    error   = -1

class VALUE_BITS(IntEnum):
    STOP_BITS  = 0x0
    ZERO       = 0x0
    ONE        = 0x1

CONV_SEC = 402832031
microsleep = lambda x: time.sleep(x/1000000.0)
millisleep = lambda x: time.sleep(x/1000.0)
timestamp_in_seconds = lambda x: round(x/CONV_SEC)

NOARG = 99
MAX_PORT = 7

LINE_CLEAR = '\x1b[2K'

CLK_FREQ = 156.25
INVALID_CLOCK_FREQ = 0.0
USER_CLKFREQ_S10 = 156.25
USER_CLKFREQ_N6000 = 402.83203125

global running_
running_ = True

def running():
    global running_
    return running_

def stop():
    global running_
    running_ = False

hssi_var_10g = {"port"              : [0],
                # "dst_port"          : 0,
                # "src_port"          : 0,
                # "eth_loopback"      : "on",
                # "he_loopback"       : "none",
                "num_packets"       : 1,
                "random_length"     : "fixed",
                "random_payload"    : "random",
                "packet_length"     : NOARG,
                # "src_addr"          :  "11:22:33:44:55:66",
                # "dest_addr"         : "77:88:99:aa:bb:cc",
                # "eth_ifc"           : "none",
                # "rnd_seed0"         : 0x5eed0000,
                # "rnd_seed1"         : 0x5eed0001,
                # "rnd_seed2"         : 0x00025eed,
                "continuous"        : "off",
                "contmonitor"       : 0}

class HSSI_10G():
    """ Contains functionalities to run HSSI 10G exercisor """
    def __init__(self, intf):
        self.intf = intf
        self.base_reg = 0x0000
        self.ports = list(range(0, MAX_PORT))

    def assign_args(self, args):
        """ Assigning the user arguments to hssi variable """
        if isinstance(args, dict):
            self.args = args
            self.ports = self.args["port"]
            # hssi_var_10g['dst_port'] = self.args["dst_port"]
            # hssi_var_10g['src_port'] = self.args["src_port"]
            # hssi_var_10g['eth_loopback'] = self.args["eth_loopback"]
            # hssi_var_10g['he_loopback'] = self.args["he_loopback"]
            hssi_var_10g['num_packets'] = self.args["num_packets"]
            hssi_var_10g['random_length'] = self.args["random_length"]
            hssi_var_10g['random_payload'] = self.args["random_payload"]
            hssi_var_10g['packet_length'] = self.args["packet_length"]
            # hssi_var_10g['src_addr'] = self.args["src_addr"]
            # hssi_var_10g['dest_addr'] = self.args["dest_addr"]
            # hssi_var_10g['eth_ifc'] = self.args["eth_ifc"]
            # hssi_var_10g['rnd_seed0'] = self.args["rnd_seed0"]
            # hssi_var_10g['rnd_seed1'] = self.args["rnd_seed1"]
            # hssi_var_10g['rnd_seed2'] = self.args["rnd_seed2"]
            hssi_var_10g['continuous'] = self.args["continuous"]
            hssi_var_10g['contmonitor'] = self.args["contmonitor"]

        else:
            self.args = args
            self.ports = self.args.port
            # hssi_var_10g['dst_port'] = self.args.dst_port
            # hssi_var_10g['src_port'] = self.args.src_port
            # hssi_var_10g['eth_loopback'] = self.args.eth_loopback
            # hssi_var_10g['he_loopback'] = self.args.he_loopback
            hssi_var_10g['num_packets'] = self.args.num_packets
            hssi_var_10g['random_length'] = self.args.random_length
            hssi_var_10g['random_payload'] = self.args.random_payload
            hssi_var_10g['packet_length'] = self.args.packet_length
            # hssi_var_10g['src_addr'] = self.args.src_addr
            # hssi_var_10g['dest_addr'] = self.args.dest_addr
            # hssi_var_10g['eth_ifc'] = self.args.eth_ifc
            # hssi_var_10g['rnd_seed0'] = self.args.rnd_seed0
            # hssi_var_10g['rnd_seed1'] = self.args.rnd_seed1
            # hssi_var_10g['rnd_seed2'] = self.args.rnd_seed2
            hssi_var_10g['continuous'] = self.args.continuous
            hssi_var_10g['contmonitor'] = self.args.contmonitor

        return hssi_var_10g

    def check_id(self):
        read_id = self.intf.read_32(base_csr = self.base_reg,
                          offset = CTRL_REG.AFU_ID_Ll,
                          bytesize = 1).hex()
        if read_id == TG_ID:
            return read_id
        else:
            return 0

    def mbox_write(self, address, value):
        """ State machine way of writing data to address """
        self.intf.write_32(base_csr = self.base_reg,
                           offset = CTRL_REG.TRAFFIC_CTRL_CMD_L,
                           value  = 0x0)
        self.intf.write_32(base_csr = self.base_reg,
                           offset = CTRL_REG.TRAFFIC_CTRL_DATA_H,
                           value  = value)
        self.intf.write_32(base_csr = self.base_reg,
                           offset = CTRL_REG.TRAFFIC_CTRL_CMD_H,
                           value  = address)
        self.intf.write_32(base_csr = self.base_reg,
                           offset = CTRL_REG.TRAFFIC_CTRL_CMD_L,
                           value  = 0x2)
        # print(f"Writing the value {value} to", hex(address))

    def mbox_read(self, address):
        """ State machine way of reading data from address """
        # self.intf.write_32(base_csr = self.base_reg,
        #                    offset = CTRL_REG.TRAFFIC_CTRL_CH_SEL_L,
        #                    value  = port)
        self.intf.write_32(base_csr = self.base_reg,
                           offset = CTRL_REG.TRAFFIC_CTRL_CMD_L,
                           value  = 0x0)
        self.intf.write_32(base_csr = self.base_reg,
                           offset = CTRL_REG.TRAFFIC_CTRL_CMD_H,
                           value  = address)
        self.intf.write_32(base_csr = self.base_reg,
                           offset = CTRL_REG.TRAFFIC_CTRL_CMD_L,
                           value  = 0x1)
        reg = self.intf.read_32(base_csr = self.base_reg,
                          offset = CTRL_REG.TRAFFIC_CTRL_DATA_L,
                          bytesize = 1).hex()
        return reg

    def read_counters(self, upper_reg, lower_reg):
        upper = self.mbox_read(upper_reg)
        lower = self.mbox_read(lower_reg)
        return (int(upper, 16) << 32) | int(lower, 16)

    def enable_eth_loopback(self, eth, enable):
        """ Enables the ethernet loopback """
        cmd = "ethtool --features " + eth
        if enable:
            cmd += " loopback on"
        else:
            cmd += " loopback off"
            # run_process(cmd)
            microsleep(1000000)

    def print_registers(self, hssi_var):
        """ Display all the necessary registers contained in FPL exercisor """
        print("\n===================================")
        print("0x3c00", "number_packets     :", self.mbox_read(TRAFF_REG.CSR_NUM_PACKETS))
        print("0x3c01", "random_length      :", self.mbox_read(TRAFF_REG.CSR_RANDOM_LENGTH))
        print("0x3c02", "random_payload     :", self.mbox_read(TRAFF_REG.CSR_RANDOM_PAYLOAD))
        print("0x3c03", "start              :", self.mbox_read(TRAFF_REG.CSR_START))
        print("0x3c04", "stop               :", self.mbox_read(TRAFF_REG.CSR_STOP))

        print("0x3c05", "src_addr_lo        :", self.mbox_read(TRAFF_REG.CSR_SRC_ADDR_LO))
        print("0x3c06", "src_addr_hi        :", self.mbox_read(TRAFF_REG.CSR_SRC_ADDR_HI))
        print("0x3c07", "dst_addr_lo        :", self.mbox_read(TRAFF_REG.CSR_DEST_ADDR_LO))
        print("0x3c08", "dst_addr_hi        :", self.mbox_read(TRAFF_REG.CSR_DEST_ADDR_HI))

        print("0x3c09", "packet_tx_count    :", self.mbox_read(TRAFF_REG.CSR_PACKET_TX_COUNT))
        print("0x3c0a", "rnd_seed0          :", self.mbox_read(TRAFF_REG.CSR_RND_SEED0))
        print("0x3c0b", "rnd_seed1          :", self.mbox_read(TRAFF_REG.CSR_RND_SEED1))
        print("0x3c0c", "rnd_seed2          :", self.mbox_read(TRAFF_REG.CSR_RND_SEED2))
        print("0x3c0d", "packet_length      :", self.mbox_read(TRAFF_REG.CSR_PACKET_LENGTH))
        print("0x3cf4", "tx_sta_tstamp      :", self.mbox_read(TRAFF_REG.CSR_TX_STA_TSTAMP))
        print("0x3cf5", "tx_end_tstamp      :", self.mbox_read(TRAFF_REG.CSR_TX_END_TSTAMP))

        print("0x3d00", "num_pkt            :", self.mbox_read(TRAFF_REG.CSR_NUM_PKT))
        print("0x3d07", "avst_rx_err        :", self.mbox_read(TRAFF_REG.CSR_AVST_RX_ERR))
        # print("0x3d01", "pkt_good           :", self.mbox_read(TRAFF_REG.CSR_PKT_GOOD))
        # print("0x3d02", "pkt_bad            :", self.mbox_read(TRAFF_REG.CSR_PKT_BAD))
        # print("0x3d0b", "rx_sta_tstamp      :", self.mbox_read(TRAFF_REG.CSR_RX_STA_TSTAMP))
        # print("0x3d0c", "rx_end_tstamp      :", self.mbox_read(TRAFF_REG.CSR_RX_END_TSTAMP))
        print("0x3d12", "rx_start_tstamp_L  :", self.mbox_read(TRAFF_REG.CSR_RX_STA_TSTAMP_L))
        print("0x3d13", "rx_start_tstamp_H  :", self.mbox_read(TRAFF_REG.CSR_RX_STA_TSTAMP_H))
        print("0x3d14", "rx_end_tstamp_L    :", self.mbox_read(TRAFF_REG.CSR_RX_END_TSTAMP_L))
        print("0x3d15", "rx_end_tstamp_H    :", self.mbox_read(TRAFF_REG.CSR_RX_END_TSTAMP_H))
        print("0x3d16", "pkt_good_L         :", self.mbox_read(TRAFF_REG.CSR_TM_GOOD_64_L))
        print("0x3d17", "pkt_good_H         :", self.mbox_read(TRAFF_REG.CSR_TM_GOOD_64_H))
        print("0x3d18", "pkt_bad_L          :", self.mbox_read(TRAFF_REG.CSR_TM_BAD_64_L))
        print("0x3d19", "pkt_bad_H          :", self.mbox_read(TRAFF_REG.CSR_TM_BAD_64_H))
        print("===================================\n")

    def initialize(self, args):
        """ Initialise the HSSI 10G by validating and assigning input data arguments """
        hssi_var = self.assign_args(args)
        if len(self.ports) > MAX_PORT:
            print(f"\nmore than {MAX_PORT} ports are not supported")
            return 0

        # if self.ports[0] != INVALID_PORT:
        #     print("\n--port is overriding --src_port and --dst_port")
        #     hssi_var["src_port"] = self.ports[0]
        #     hssi_var["dst_port"] = self.ports[0]

        if hssi_var["random_length"] == 'random':
            if hssi_var["packet_length"] == NOARG:
                hssi_var["packet_length"] = 'random'
            else:
                print("\nUsage of 'packet_length' argument is not allowed when 'random_length' is random!\n")
                return 0

        elif hssi_var["packet_length"] == NOARG:
            hssi_var["packet_length"] = 64

        print("\n10G loopback test")
        print("  port:", self.ports[0])
        # print("  dst_port:", hssi_var["dst_port"])
        # print("  src_port:", hssi_var["src_port"])
        # print("  eth_loopback:", hssi_var["eth_loopback"])
        # print("  he_loopback:", hssi_var["he_loopback"])
        print("  num_packets:", hssi_var["num_packets"])
        print("  random_length:", hssi_var["random_length"])
        print("  random_payload:", hssi_var["random_payload"])
        print("  packet_length:", hssi_var["packet_length"])
        # print("  src_address:", hssi_var["src_addr"])
        # print("  dest_address:", hssi_var["dest_addr"])
        # print("  eth:", hssi_var["eth_ifc"])
        # print("  rnd_seed0:", hssi_var["rnd_seed0"])
        # print("  rnd_seed1:", hssi_var["rnd_seed1"])
        # print("  rnd_seed2:", hssi_var["rnd_seed2"])
        print("  continuous mode:", hssi_var["continuous"])
        print("  monitor duration:", hssi_var["contmonitor"], "sec")
        print("")

        # if (hssi_var["eth_ifc"] == "none"):
        #     print("No eth interface, so not honoring --eth-loopback.")
        # elif hssi_var["eth_loopback"] == "on":
        #     self.enable_eth_loopback(hssi_var["eth_ifc"], True)
        # else:
        #     self.enable_eth_loopback(hssi_var["eth_ifc"], False)

        return hssi_var

    def read_good_cnt(self, hssi_var):
        return int(self.mbox_read(TRAFF_REG.CSR_PKT_GOOD), 16)

    def stop_cont_mode(self):
        self.mbox_write(TRAFF_REG.CSR_STOP, VALUE_BITS.ONE)
        self.mbox_write(TRAFF_REG.CSR_CONT_MODE, VALUE_BITS.ZERO)

    def configure(self, hssi_var):
        """ Configures the HSSI 10G by writing data to config registers and perform continuous reading of packet transfer """
        ### port selection
        self.mbox_write(TRAFF_REG.CSR_STOP, VALUE_BITS.STOP_BITS)

        # if hssi_var["he_loopback"] != "none":
        #     if hssi_var["he_loopback"] == "on":
        #         self.mbox_write(TRAFF_REG.CSR_LOOPBACK_EN, VALUE_BITS.ONE)
        #     else:
        #         self.mbox_write(TRAFF_REG.CSR_LOOPBACK_EN, VALUE_BITS.ZERO)
        #         return status.success

        #     print("HE loopback enabled. Use Ctrl+C to exit.")

            # while running():
            #     millisleep(1000)
            # return status.success

        self.mbox_write(TRAFF_REG.CSR_NUM_PACKETS, hssi_var["num_packets"])
        if hssi_var["random_length"] != "random":
            self.mbox_write(TRAFF_REG.CSR_PACKET_LENGTH, hssi_var["packet_length"])

        self.mbox_write(TRAFF_REG.CSR_RANDOM_LENGTH, VALUE_BITS.ZERO if hssi_var["random_length"] == "fixed" else VALUE_BITS.ONE)
        self.mbox_write(TRAFF_REG.CSR_RANDOM_PAYLOAD, VALUE_BITS.ZERO if hssi_var["random_payload"] == "incremental" else VALUE_BITS.ONE)
        # self.mbox_write(TRAFF_REG.CSR_RND_SEED0, hssi_var["rnd_seed0"])
        # self.mbox_write(TRAFF_REG.CSR_RND_SEED1, hssi_var["rnd_seed1"])
        # self.mbox_write(TRAFF_REG.CSR_RND_SEED2, hssi_var["rnd_seed2"])
        if hssi_var["continuous"] == "on":
            self.mbox_write(TRAFF_REG.CSR_CONT_MODE, VALUE_BITS.ONE)

        # self.intf.write_32(base_csr = self.base_reg,
        #                    offset = CTRL_REG.TRAFFIC_CTRL_CH_SEL_L,
        #                    value  = hssi_var["src_port"])

        self.mbox_write(TRAFF_REG.CSR_START, VALUE_BITS.ONE)

        # count = 0
        # interval = 100
        # while count < hssi_var["num_packets"]:
        #     count = int(self.mbox_read(TRAFF_REG.CSR_PACKET_TX_COUNT), 16)
        #     # Added to eliminate infinite loop occured when CSR_PACKET_TX_COUNT is 0
        #     if count == 0:
        #         break

        #     if not running():
        #         self.mbox_write(TRAFF_REG.CSR_STOP,
        #                         VALUE_BITS.ONE)
        #         return status.error

        #     microsleep(interval)

        return status.success

    @property
    def timestamp_data(self):
        timestamp_data = {"tx_sta_tstamp": 0,
                          "tx_end_tstamp": 0,
                          "rx_sta_tstamp": 0,
                          "rx_end_tstamp": 0,
                          "rx_gd_cnt": 0,
                          "rx_bd_cnt": 0,
                          "tx_pkt_cnt": 0}
        return timestamp_data

    @property
    def perf_data(self):
        perf_data = {"tx_good_count": 0,
                    "rx_good_count": 0,
                     "rx_bad_count": 0,
                    "latency_min_ns": 0,
                    "latency_max_ns": 0,
                    "tx_throughput": 0,
                    "rx_throughput": 0}
        return perf_data

    def read_tstamp_data(self, hssi_var):
        """ Read and returns traffic control Tx/Rx timestamp registers """
        self.mbox_write(TRAFF_REG.CSR_PERF_CAP_TRIG, VALUE_BITS.ONE)

        timestamp_data = self.timestamp_data
        timestamp_data["tx_sta_tstamp"] = self.read_counters(TRAFF_REG.CSR_TX_STA_TSTAMP_H,
                                                             TRAFF_REG.CSR_TX_STA_TSTAMP_L)
        timestamp_data["tx_end_tstamp"] = self.read_counters(TRAFF_REG.CSR_TX_END_TSTAMP_H,
                                                             TRAFF_REG.CSR_TX_END_TSTAMP_L)

        timestamp_data["rx_sta_tstamp"] = self.read_counters(TRAFF_REG.CSR_RX_STA_TSTAMP_H,
                                                             TRAFF_REG.CSR_RX_STA_TSTAMP_L)
        timestamp_data["rx_end_tstamp"] = self.read_counters(TRAFF_REG.CSR_RX_END_TSTAMP_H,
                                                             TRAFF_REG.CSR_RX_END_TSTAMP_L)

        timestamp_data["rx_gd_cnt"] = self.read_counters(TRAFF_REG.CSR_TM_GOOD_64_H,
                                                         TRAFF_REG.CSR_TM_GOOD_64_L)
        timestamp_data["rx_bd_cnt"] = self.read_counters(TRAFF_REG.CSR_TM_BAD_64_H,
                                                        TRAFF_REG.CSR_TM_BAD_64_L)

        timestamp_data["tx_pkt_cnt"] = int(self.mbox_read(TRAFF_REG.CSR_PACKET_TX_COUNT), 16)
        return timestamp_data

    def get_latency(self, ts_data):
        """ Convert timestamp register from clock cycles to nanoseconds """
        tstamp_ns = self.timestamp_data
        perf_data = self.perf_data

        sample_period_ns = 1000 / CLK_FREQ
        tstamp_ns["tx_sta_tstamp"] = ts_data["tx_sta_tstamp"] * sample_period_ns
        tstamp_ns["tx_end_tstamp"] = ts_data["tx_end_tstamp"] * sample_period_ns
        tstamp_ns["rx_sta_tstamp"] = ts_data["rx_sta_tstamp"] * sample_period_ns
        tstamp_ns["rx_end_tstamp"] = ts_data["rx_end_tstamp"] * sample_period_ns

        # Calculate latencies
        perf_data["latency_min_ns"] = round(tstamp_ns["rx_sta_tstamp"] - tstamp_ns["tx_sta_tstamp"], 2)
        perf_data["latency_max_ns"] = round(tstamp_ns["rx_end_tstamp"] - tstamp_ns["tx_end_tstamp"], 2)
        perf_data["rx_good_count"] = ts_data["rx_gd_cnt"]
        perf_data["rx_bad_count"] = ts_data["rx_bd_cnt"]
        perf_data["tx_good_count"] = ts_data["tx_pkt_cnt"]

        return tstamp_ns, perf_data

    def calc_throuput(self, hssi_var, tstamp_ns, perf_data):
        """ Calculate Tx/Rx throughput achieved """
        data_pkt_size = hssi_var["packet_length"]

        #### randomized length --> if hssi_var["random_length"] == "random", use byte_count

        # if CLK_FREQ == USER_CLKFREQ_S10:
        #     data_pkt_size = hssi_var["packet_length"] - 4
        # else:
        #     data_pkt_size = hssi_var["packet_length"] - 8

        total_tx_duration_ns = tstamp_ns["tx_end_tstamp"] - tstamp_ns["tx_sta_tstamp"]
        total_rx_duration_ns = tstamp_ns["rx_end_tstamp"] - tstamp_ns["rx_sta_tstamp"]

        if hssi_var["random_length"] != "random":
            tx_data_size_bits = perf_data["tx_good_count"]  * data_pkt_size * 8
            rx_data_size_bits = perf_data["rx_good_count"]  * data_pkt_size * 8
            if total_tx_duration_ns:
                perf_data["tx_throughput"] = round(tx_data_size_bits / total_tx_duration_ns, 2)
                # perf_data["tx_throughput"] = (tx_data_size_bits / total_tx_duration_ns)
            if total_rx_duration_ns:
                perf_data["rx_throughput"] = round(rx_data_size_bits / total_rx_duration_ns, 2)
                # perf_data["rx_throughput"] = (rx_data_size_bits / total_rx_duration_ns)

        return perf_data

    def display_performance(self, timer, hssi_var, perf_data, timestamp_data, final_perf, cont_mode):
        if cont_mode:
            print("\tTime Elapsed               :", timer, "s")
        print("\tSelected clock frequency   :", CLK_FREQ, "MHz")
        print("\tTX Packet Count            :", perf_data["tx_good_count"])
        print("\tRX Good Packet             :", perf_data["rx_good_count"])
        print("\tRX Bad Packet              :", perf_data["rx_bad_count"])
        # print(end=LINE_CLEAR)
        # print("\tLatency minimum            :", final_perf["latency_min_ns"], "ns")
        # print(end=LINE_CLEAR)
        # print("\tLatency maximum            :", final_perf["latency_max_ns"], "ns")

        print("\tTx_end_tstamp              :", timestamp_data['tx_end_tstamp'])
        print("\tTx_sta_tstamp              :", timestamp_data['tx_sta_tstamp'])
        print("\tRx_end_tstamp              :", timestamp_data['rx_end_tstamp'])
        print("\tRx_sta_tstamp              :", timestamp_data['rx_sta_tstamp'])

        # if cont_mode:
        if hssi_var['random_length'] != 'random':
            if perf_data["tx_good_count"] >= 20:
                print(end=LINE_CLEAR)
                print("\tAchieved Tx throughput     :", final_perf["tx_throughput"], "Gb/s")
                print(end=LINE_CLEAR)
                print("\tAchieved Rx throughput     :", final_perf["rx_throughput"], "Gb/s")
