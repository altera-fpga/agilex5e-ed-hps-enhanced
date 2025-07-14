import sys
import time
from enum import IntEnum
from .registers import ADDR_MODE, STAT, REG, TG_REGISTERS, TG_ID
from time import sleep

class status(IntEnum):
    PASS = 0x1
    FAIL = 0x0

tg_var = {'loop'     : [1],
          'rcnt'     : [1],
          'wcnt'     : [1],
          'bcnt'     : [1],
          'stride'   : [1],
          'pattern'  : ["fixed"],
          'mem_speed': [0],
          'r_bw'     : 0,
          'w_bw'     : 0,
          'num_ticks': 0,
          'mem_ch'   : [1],
          'cont'     : "off"}

tg_pattern = {
            "fixed" : 0,
            "prbs7" : 1,
            "prbs15": 2,
            "prbs31": 3,
            "rot1"  : 4
}

tg_base_offset = {0 : 0x0001000,
                  1 : 0x0009000
}

class MEMTG():
    """ Contains functionalities to run MEMTG exercisor """
    def __init__(self, intf):
        self.intf = intf
        self.endian = "big"
        self.timeout = 0
        self.tg_var_list = []
        self.MEM_TG_TEST_TIMEOUT = 10800000 # 10800 sec - 180 mins - 3 hours
        self.TEST_SLEEP_INVL = 1000000
        self.MEM_TG_CFG_OFFSET = 0x0001000
        self.tg_base = REG.AFU_DFH + self.MEM_TG_CFG_OFFSET

    def set_cfg_offset(self, mem_ch):
        self.MEM_TG_CFG_OFFSET = tg_base_offset[mem_ch]
        self.tg_base = REG.AFU_DFH + (self.MEM_TG_CFG_OFFSET)
        # print("=======================================================", hex(self.MEM_TG_CFG_OFFSET))

    def stop_tg(self, ch_num):
        """ Stops the TG test after writing to loops register """
        self.set_cfg_offset(ch_num)
        self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_LOOP_COUNT << 0x2, value = 1)
        self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_CLEAR << 0x2, value = 0xffffffff)
        return status.PASS

    def start_tg(self, ch_num):
        """ Starts the TG test after writing to configuration register """
        self.set_cfg_offset(ch_num)
        self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_START << 0x2, value = 1)
        return status.PASS

    def check_id(self, ch_num):
        self.set_cfg_offset(ch_num)
        read_id = self.intf.read_32(base_csr = self.tg_base,
                                      offset = (TG_REGISTERS.TG_AFU_ID) << 0x2,
                                      bytesize=1, endian = self.endian).hex()
        if read_id == TG_ID:
            return read_id
        else:
            return 0

    def get_read_cnt(self, ch_num):
        """ Fetch the read count for the selected TG channel """
        self.set_cfg_offset(ch_num)
        rcnt_upper = self.intf.read_32(base_csr = self.tg_base,
                                      offset = (TG_REGISTERS.TG_READ_COUNTER_H) << 0x2,
                                      bytesize=1, endian = self.endian).hex()
        rcnt_lower = self.intf.read_32(base_csr = self.tg_base,
                                      offset = (TG_REGISTERS.TG_READ_COUNTER_L) << 0x2,
                                      bytesize=1, endian = self.endian).hex()
        rcnt = (int(rcnt_upper, 16) << 32) | int(rcnt_lower, 16)
        return rcnt
        # return int(rcnt_lower, 16)

    def get_write_cnt(self, ch_num):
        """ Fetch the write count for the selected TG channel """
        self.set_cfg_offset(ch_num)
        wcnt_upper = self.intf.read_32(base_csr = self.tg_base,
                                      offset = (TG_REGISTERS.TG_WRITE_COUNTER_H) << 0x2,
                                      bytesize=1, endian = self.endian).hex()
        wcnt_lower = self.intf.read_32(base_csr = self.tg_base,
                                      offset = (TG_REGISTERS.TG_WRITE_COUNTER_L) << 0x2,
                                      bytesize=1, endian = self.endian).hex()
        wcnt = (int(wcnt_upper, 16) << 32) | int(wcnt_lower, 16)
        return wcnt
        # return int(wcnt_lower, 16)

    def get_mem_cycle(self, ch_num):
        """ Fetch the memory clock cycles for the selected TG channel """
        self.set_cfg_offset(ch_num)
        # print("=======================================================", hex(self.MEM_TG_CFG_OFFSET))
        num_ticks_upper = self.intf.read_32(base_csr = self.tg_base,
                                      offset = (TG_REGISTERS.TG_CLOCK_COUNT_H) << 0x2,
                                      bytesize=1, endian = self.endian).hex()
        num_ticks_lower = self.intf.read_32(base_csr = self.tg_base,
                                      offset = TG_REGISTERS.TG_CLOCK_COUNT_L << 0x2,
                                      bytesize=1, endian = self.endian).hex()
        num_ticks = (int(num_ticks_upper, 16) << 32) | int(num_ticks_lower, 16)
        return num_ticks
        # return int(num_ticks_lower, 16)

    def get_tg_status(self, ch_num):
        """ Fetch the TG status for the selected TG channel """
        self.set_cfg_offset(ch_num)
        tg_status = self.intf.read_32(base_csr = self.tg_base,
                                      offset = TG_REGISTERS.TG_ACTIVE << 0x2,
                                      endian = self.endian).hex()
        return int(tg_status, 16)

    def bw_calc(self, tg_freq, xfer_bytes, num_ticks):
        """ Calculates Bandwidth for the selected TG channel """
        if (num_ticks > 0):
            return round((xfer_bytes/num_ticks)* (tg_freq/1000), 2)
        return 0

    def performance(self, tg_freq, ch_num):
        """ Calculates the performance data to display in TG monitor """
        out_tg_var = tg_var.copy()
        # print("======================================", tg_freq)

        num_ticks = self.get_mem_cycle(ch_num)

        write_bytes = 32 * self.get_write_cnt(ch_num)
        read_bytes  = 32 * self.get_read_cnt(ch_num)

        out_tg_var['r_bw'] = self.bw_calc(tg_freq, read_bytes, num_ticks) * 8
        out_tg_var['w_bw'] = self.bw_calc(tg_freq, write_bytes, num_ticks) * 8
        out_tg_var['num_ticks'] = num_ticks

        return out_tg_var

    def configure(self, tgVar, ch_num):
        """ Configures the TG config registers """
        # print("Base Address: ", hex(self.tg_base))
        self.set_cfg_offset(ch_num)
        if tgVar['cont'] == "on":
            self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_LOOP_COUNT << 0x2, value = 0)
        else:
            self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_LOOP_COUNT << 0x2, value = tgVar['loop'])

        self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_WRITE_COUNT << 0x2, value = tgVar['wcnt'])
        self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_READ_COUNT << 0x2, value = tgVar['rcnt'])
        self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_BURST_LENGTH << 0x2, value = tgVar['bcnt'])
        self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_SEQ_ADDR_INCR << 0x2, value = tgVar['stride'])
        self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_PPPG_SEL << 0x2, value = tgVar['pattern'])

        self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_ADDR_MODE_WR << 0x2, value = ADDR_MODE.TG_ADDR_SEQ)
        self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_ADDR_MODE_RD << 0x2, value = ADDR_MODE.TG_ADDR_SEQ)

        self.intf.write_32(base_csr = self.tg_base, offset = TG_REGISTERS.TG_CLEAR << 0x2, value = 0xffffffff)

        # print("tgVar: ", tgVar)
        # print("========================================", tg_var)
        return status.PASS

    def initialize(self, args, ch_num):
        """ Initialise the FPL by validating and assigning input data arguments """
        if isinstance(args, dict):
            self.args = args
            tg_var["cont"]      = self.args['cont']
            tg_var['mem_speed'] = self.args['mem_speed'][ch_num]
            tg_var['mem_ch']    = self.args['mem_ch'][ch_num]
            tg_var['loop']      = self.args['loop'][ch_num]
            tg_var['wcnt']      = self.args['wcnt'][ch_num]
            tg_var['rcnt']      = self.args['rcnt'][ch_num]
            tg_var['bcnt']      = self.args['bcnt'][ch_num]
            tg_var['stride']    = self.args['stride'][ch_num]
            tg_var['pattern']   = tg_pattern[self.args['pattern'][ch_num]]
            return tg_var

        else:
            self.args = vars(args)

        # if self.args['mem_frequency'] == 0:
        #     self.args['mem_frequency'] = 220

        ch_size = len(self.args['mem_channel'])

        if(len(self.args['mem_frequency']) < ch_size):
            for _ in range(len(self.args['mem_frequency']), ch_size):
                self.args['mem_frequency'].append(220)

        if(len(self.args['loops']) < ch_size):
            for _ in range(len(self.args['loops']), ch_size):
                self.args['loops'].append(1)

        if(len(self.args['writes']) < ch_size):
            for _ in range(len(self.args['writes']), ch_size):
                self.args['writes'].append(1)

        if(len(self.args['reads']) < ch_size):
            for _ in range(len(self.args['reads']), ch_size):
                self.args['reads'].append(1)

        if(len(self.args['bls']) < ch_size):
            for _ in range(len(self.args['bls']), ch_size):
                self.args['bls'].append(1)

        if(len(self.args['stride']) < ch_size):
            for _ in range(len(self.args['stride']), ch_size):
                self.args['stride'].append(1)

        if(len(self.args['data']) < ch_size):
            for _ in range(len(self.args['data']), ch_size):
                self.args['data'].append("fixed")

        tg_var["cont"]      = self.args['continuous']
        tg_var['mem_speed'] = self.args['mem_frequency'][ch_num]
        tg_var['mem_ch']    = self.args['mem_channel'][ch_num]
        tg_var['loop']      = self.args['loops'][ch_num]
        tg_var['wcnt']      = self.args['writes'][ch_num]
        tg_var['rcnt']      = self.args['reads'][ch_num]
        tg_var['bcnt']      = self.args['bls'][ch_num]
        tg_var['stride']    = self.args['stride'][ch_num]
        tg_var['pattern']   = tg_pattern[self.args['data'][ch_num]]

        # print("========================================", tg_var)
        return tg_var
