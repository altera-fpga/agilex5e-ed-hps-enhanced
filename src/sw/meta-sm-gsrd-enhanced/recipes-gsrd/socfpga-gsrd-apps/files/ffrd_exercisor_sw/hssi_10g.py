import os
from time import sleep
from argparse import ArgumentParser, ArgumentTypeError
from lib.common_reg import interface
from lib.core.exerciser.hssi.lib_hssi_10g import HSSI_10G, hssi_var_10g, status, CLK_FREQ, INVALID_CLOCK_FREQ

APP_NAME = "HSSI"
INTF_LIST = ["hps", "pcie"]
MAX_HSSI_PORT = 7

LINE_CLEAR = '\x1b[2K'

def get_pos_int(arg):
    try:
        value = int(arg)
        if value >= 0:
            return value
        else:
            raise ArgumentTypeError("\nInvalid argument, provide only positive integer value..!")
    except ValueError:
        raise ArgumentTypeError("\nInvalid argument, provide only integer value..!")

def get_hps_path(dev: str):
    """
    Extract and returns the latest or custom set Quartus Programmer path.

    Parameters
    ----------
    dev: str
        Device name or Device index for the interface.

    Raises
    ------
    None

    Returns
    -------
    final_path : str
        Absolute path of HPS uio device
    """
    if dev[:3] == "uio" and dev[3:].isnumeric():
        final_path = f"/dev/{dev}"
        if os.path.exists(final_path):
            return (True, final_path)
        return (False, f"\nHPS device not found --> {dev}")
    return (False, f"\nInvalid HPS device path --> {dev}, Provide in uioX format where X -> Positive integer")

def parser(argv):
    """
    Parser function to add command-line arugments to run HSSI.

    Parameters
    ----------
    argv : None
        Stores the list of strings containing command-line arguments that user gives.

    Raises
    ------
    none

    Returns
    -------
    parser: ArgumentParser
        parser object is returned
    """
    parser = ArgumentParser(prog='hssi_10g.py', description='hssi test')
    parser.add_argument(
        '-I', '--interface',
        help="find interfaces supported using --list\
                        or -l argument",
        default='hps')

    ### Removed as part of bug fix
    # parser.add_argument(
    #     '-l', '--list',
    #     help="list of interfaces available",
    #     action='store_true')
    parser.add_argument(
        '-D', '--device',
        help="Device name or Device index for the interface. eg; uioX for HPS",
        required=True)

    parser.add_argument("--port", nargs='*', type=get_pos_int, choices=range(0, MAX_HSSI_PORT), default=hssi_var_10g['port'], help="QSFP Tx/Rx ports")
    # parser.add_argument("--dst_port", nargs='*', type=int, choices=range(0, MAX_HSSI_PORT), default=hssi_var_10g['dst_port'], help="QSFP Rx port")
    # parser.add_argument("--src_port", nargs='*', type=int, choices=range(0, MAX_HSSI_PORT), default=hssi_var_10g['src_port'], help="QSFP Tx port")
    # parser.add_argument("--eth_loopback", choices=("on", "off"), type=str, default=hssi_var_10g['eth_loopback'], help="whether to enable loopback on the eth interface")
    # parser.add_argument("--he_loopback", choices=("on", "off"), type=str, default=hssi_var_10g['he_loopback'], help="whether to enable loopback Hardware Exerciser (HE)")
    parser.add_argument("--num_packets", type=get_pos_int, default=hssi_var_10g['num_packets'], help="Number of packets")
    parser.add_argument("--random_length", choices=("random", "fixed"), type=str, default=hssi_var_10g['random_length'], help="packet length randomization")
    parser.add_argument("--random_payload", choices=("random", "incremental"), type=str, default=hssi_var_10g['random_payload'], help="payload randomization")
    parser.add_argument("--packet_length", type=get_pos_int, default=hssi_var_10g['packet_length'], help="packet length")
    # parser.add_argument("--src_addr", type=str, default=hssi_var_10g['src_addr'], help="source MAC address")
    # parser.add_argument("--dest_addr", type=str, default=hssi_var_10g['dest_addr'], help="destination MAC address")
    # parser.add_argument("--eth_ifc", type=str, default=hssi_var_10g['eth_ifc'], help="ethernet interface name")
    # parser.add_argument("--rnd_seed0", type=int, default=hssi_var_10g['rnd_seed0'], help="prbs generator [31:0]")
    # parser.add_argument("--rnd_seed1", type=int, default=hssi_var_10g['rnd_seed1'], help="prbs generator [47:32]")
    # parser.add_argument("--rnd_seed2", type=int, default=hssi_var_10g['rnd_seed2'], help="prbs generator [91:64]")
    parser.add_argument("--continuous", choices=("on", "off"), type=str, default=hssi_var_10g['continuous'], help="continuous mode")
    parser.add_argument("--contmonitor", type=get_pos_int, default=hssi_var_10g['contmonitor'], help="time period(in seconds) for performance monitor")
    # parser.add_argument("-p", "--print_reg", action='store_true', default=0x0, help="Display the HSSI TG registers values")
    parser.add_argument("-a", "--check_id", action='store_true', default=0x0, help="Display the TG ID")

    return parser.parse_args(argv)

def run_performance(timer, hssi, hssi_var, cont_mode):
    """
    Reads the HSSI performance data, calculate bandwidth and display the data.

    Parameters
    ----------
    timer : int
        Variable to store time elapsed from start of the test.
    hssi : class
        Object used to handle HSSI test run functionalities
    hssi_var: dict
        Variable to access and store HSSI test parameters

    Returns
    -------
    none
    """
    timestamp_data = hssi.read_tstamp_data(hssi_var)
    tstamp_ns, perf_data = hssi.get_latency(timestamp_data)
    final_perf = hssi.calc_throuput(hssi_var, tstamp_ns, perf_data)
    hssi.display_performance(timer, hssi_var, perf_data, timestamp_data, final_perf, cont_mode)

def main(argv=None):
    """
    Main function taking care of initialisation and configuration to run HSSI.

    Parameters
    ----------
    argv : None
        Stores the list of strings containing command-line arguments that user gives.

    Raises
    ------
    none

    Returns
    -------
    status : status
        Object holding success or error statuses
    """
    args = parser(argv)

    device = args.device.strip()
    dev_index = None

    ### Removed as part of bug fix
    # list_files = args.list
    # if list_files:
    #     print("Interfaces supported are", INTF_LIST)
    #     return

    INTF = args.interface
    if INTF == "hps":
        qprog = get_hps_path(device)
    else:
        print("Invalid interface name!, choose from", INTF_LIST)
        return

    if qprog[0]:
        qprog = qprog[1]
    else:
        print(qprog[1])
        return

    try:
        intf_obj = interface(INTF, dev_path = qprog)
        intf_obj.open_device(size = 16, dev_index=dev_index, path=APP_NAME)

        hssi = HSSI_10G(intf_obj)

        tg_id = hssi.check_id()
        if not tg_id:
            print(f"\n{tg_id}: Invalid TG ID detected..! Provide correct device index")
            return

        if args.check_id:
            print(f"\nTG ID: 0x{tg_id}")
            return

        if tg_id:
            if len(args.port) > 1:
                print("\nSupport for Multi-channel run is not available...!")
                return
            elif args.port[0] != 0:
                print(f"\nport {args.port[0]} is not supported..!, Please use '--port 0'")
                return
        else:
            for port in args.port:
                if port not in [0, 1]:
                    print("\nOnly ports --> [0, 1] are supported for multi-channel run")
                    return

        print("\033[H\033[J", end="")
        print("Testing HSSI 10G")
        print("Press CTRL+C to exit...!")

        hssi_var = hssi.initialize(args)
        if hssi_var:
            hssi.configure(hssi_var)
            if CLK_FREQ == INVALID_CLOCK_FREQ:
                print("Couldn't determine user clock freq.")
                print("Skipping performance display.")
            else:
                """ Monitor Implementation """
                if hssi_var["continuous"] != "off" and hssi_var["contmonitor"] >= 0:
                    try:
                        timer = 1
                        max_timer = hssi_var["contmonitor"]
                        print("\nHSSI performance:")
                        while timer < max_timer:
                            run_performance(timer, hssi, hssi_var, cont_mode=True)
                            if hssi_var['random_length'] == 'random':
                                print(f"\x1b[10A")
                            else:
                                print(f"\x1b[12A")
                            timer+=1
                            sleep(1)
                        hssi.stop_cont_mode()
                        sleep(1)
                        run_performance(timer, hssi, hssi_var, cont_mode=True) ### Match the Rx and Tx packets at the end

                    except KeyboardInterrupt:
                        hssi.stop_cont_mode()
                        sleep(1)
                        run_performance(timer, hssi, hssi_var, cont_mode=True) ### Match the Rx and Tx packets at the end
                        print(f"\x1b[1B")

                elif hssi_var["contmonitor"] > 0:
                    print("Please use --continuous and --contmonitor together")
                    return status.error

                else:
                    try:
                        timer = 0
                        rx_pkt = 0
                        print("\nHSSI performance:")
                        while rx_pkt != hssi_var["num_packets"]:
                            timestamp_data = hssi.read_tstamp_data(hssi_var)
                            rx_pkt = timestamp_data['rx_gd_cnt']
                            run_performance(timer, hssi, hssi_var, cont_mode=False)
                            if hssi_var['random_length'] == 'random':
                                print(f"\x1b[9A")
                            else:
                                print(f"\x1b[11A")
                            sleep(1)
                        if hssi_var['random_length'] == 'random':
                            print(f"\x1b[7B")
                        else:
                            print(f"\x1b[9B")

                    except KeyboardInterrupt:
                        hssi.stop_cont_mode()
                        sleep(1)
                        run_performance(timer, hssi, hssi_var, cont_mode=False) ### Match the Rx and Tx packets at the end
                        print(f"\x1b[1B")

                ### Removed as part of bug fix
                # if args.print_reg:
                    # hssi.print_registers(hssi_var)

    except KeyboardInterrupt:
        intf_obj.close_device()
    finally:
        intf_obj.close_device()

if __name__ == "__main__":
    main()
