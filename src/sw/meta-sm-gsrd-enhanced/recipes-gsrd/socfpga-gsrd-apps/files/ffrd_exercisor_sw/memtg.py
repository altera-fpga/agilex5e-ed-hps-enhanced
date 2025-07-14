import os
import time
from argparse import ArgumentParser, ArgumentTypeError, ArgumentError
from threading import Thread, Lock
from copy import deepcopy

from lib.common_reg import interface
from lib.core.exerciser.memtg.lib_memtg import MEMTG, tg_pattern, tg_var, status, tg_base_offset
from lib.core.exerciser.memtg.registers import STAT, TG_REGISTERS

INTF_LIST = ["hps", "pcie"]
APP_NAME = "MEMTG"

MAX_FREQ = 1200
MAX_MEM_CH = 4
MAX_VAL_32BIT = pow(2, 32)
MAX_VAL_12BIT = pow(2, 12)
MAX_VAL_8BIT = pow(2, 8)

LINE_CLEAR = '\x1b[2K'
LINE_PRINT = 4


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

def range_checker(minVal = 1, maxVal = 1):
    """ Checks the input value whether its within range of min to max value"""
    def checker(arg):
        try:
            val = int(arg)
        except ValueError:
            raise ArgumentTypeError("must be type of 'int'")
        if val > maxVal or val < minVal:
            raise ArgumentTypeError(f"must be in range of [{minVal}, {maxVal}]")
        return val
    return checker

def clear_line():
    print(end=LINE_CLEAR)

def get_timestamp():
    return f"[{time.strftime('%H:%M:%S', time.localtime(time.time()))}]"

def move_cursor(lines_len, ch_no, skip_lines):
    """ Moves the cursor UP or DOWN """
    cursor = lines_len + ch_no * skip_lines
    print(f"\033[{cursor};0H")

def parser(argv):
    """
    Parser function to add command-line arugments to run MEMTG.

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
    parser = ArgumentParser(prog='memtg.py', description='Run TG tests')
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

    subparsers = parser.add_subparsers(help="test_name", dest="test")
    parser_test = subparsers.add_parser("tg_test",  help="execute TG memory test")
    parser_test.add_argument("-c", "--continuous",  type=str, choices=["on", "off"], default=tg_var["cont"], help="Run TG test to run continuously. Press ctrl+c to exit")
    parser_test.add_argument("-m", "--mem_channel", nargs='+', type=int, choices=list(tg_base_offset.keys()), default=tg_var['mem_ch'], help="Multiple target memory banks for test to run on (0 indexed)")
    parser_test.add_argument("-l", "--loops",       nargs='+', type=range_checker(maxVal = MAX_VAL_32BIT), default=tg_var['loop'], help="Number of read/write loops to be run")
    parser_test.add_argument("-w", "--writes",      nargs='+', type=range_checker(maxVal = MAX_VAL_32BIT), default=tg_var['wcnt'], help="Number of unique write transactions per loop")
    parser_test.add_argument("-r", "--reads",       nargs='+', type=range_checker(maxVal = MAX_VAL_32BIT), default=tg_var['rcnt'], help="Number of unique read transactions per loop")
    parser_test.add_argument("-b", "--bls",         nargs='+', type=int, choices=(1, 2, 4, 8, 16), default=tg_var['bcnt'], help="Burst length of each request")
    parser_test.add_argument("-s", "--stride",      nargs='+', type=range_checker(maxVal = MAX_VAL_8BIT), default=tg_var["stride"], help="Address stride for each sequential transaction")
    parser_test.add_argument("-p", "--data",        nargs='+', type=str, choices=list(tg_pattern.keys()), default=tg_var["pattern"], help="Memory traffic data pattern")
    parser_test.add_argument("-f", "--mem_frequency",  nargs='+', type=range_checker(maxVal = MAX_FREQ), default=tg_var["mem_speed"], help="Memory traffic clock frequency in MHz")
    parser_test.add_argument("-a", "--check_id",    action='store_true', default=0x0, help="Display the TG ID")

    return parser.parse_args(argv)

def thread_run_memtg(lock, mem_tg, input_tg_var, ch_pos):
    """
    Thread function to run MEMTG for each channel.

    Parameters
    ----------
    lock : Lock
        A thread lock object used to acquire and release resources.
    mem_tg : MEMTG
        Object containing the library APIs to run memtg.
    input_tg_var : dict
        Variable holding key-value pair of arguments and its assigned data.
    ch_pos : int
        Channel position in order of index 0 for which each channel needs to run.

    Raises
    ------
    KeyboardInterrupt
        Just pass and skips to next step.

    Returns
    -------
    status: status
        Object holding pass or fail statuses
    """
    tg_status = 0x1
    num_ticks = 0x1000
    timeout = mem_tg.MEM_TG_TEST_TIMEOUT/1000
    timeout = (timeout/0.155)*1000

    ch_num = input_tg_var["mem_ch"]
    ch_freq = input_tg_var["mem_speed"]
    mem_tg.tg_var_list.append(input_tg_var)

    if mem_tg.configure(input_tg_var, ch_num):
        mem_tg.start_tg(ch_num)

        while tg_status == STAT.TG_STATUS_ACTIVE:
            lock.acquire()
            move_cursor(LINE_PRINT, ch_pos, 7)
            print("=================================")
            num_ticks = mem_tg.get_mem_cycle(ch_num)

            print("Mem Channel:", ch_num)
            print("Mem Clock Cycles:", num_ticks)

            out_tg_var = mem_tg.performance(ch_freq, ch_num)
            clear_line()
            print("Write BW :", f"{out_tg_var['w_bw']:.2f}", "Gb/s")
            print("Read BW  :", f"{out_tg_var['r_bw']:.2f}", "Gb/s")

            tg_status = mem_tg.get_tg_status(ch_num)
            timeout-=1
            lock.release()
            time.sleep(1)

        if timeout == 0:
            print("TG TEST TIME OUT")

        # move_cursor(LINE_PRINT - 1, ch_pos+1, 7)
        # print(f"Channel: {ch_num} TG PASS")
        return status.PASS

    return status.FAIL

def main(argv=None):
    """
    Main function taking care of initialisation and configuration to run MEMTG.

    Parameters
    ----------
    argv : None
        Stores the list of strings containing command-line arguments that user gives.

    Raises
    ------
    none

    Returns
    -------
    None is returned
    """
    args = parser(argv)

    ### Removed as part of bug fix
    # list_files = args.list
    # if list_files:
    #     print("Interfaces supported are", INTF_LIST)
    #     return

    device = args.device.strip()
    dev_index = None

    INTF = args.interface
    if INTF == "hps":
        qprog = get_hps_path(device)
    else:
        print("\nInvalid interface name!, choose from", INTF_LIST)
        return

    if qprog[0]:
        qprog = qprog[1]
    else:
        print(qprog[1])
        return

    intf_obj = interface(INTF, dev_path = qprog)
    ch_size = len(args.mem_channel)
    try:
        intf_obj.open_device(size = 16, dev_index=dev_index, path=APP_NAME)
        mem_tg = MEMTG(intf_obj)
        input_tg_var = []

        tg_id = mem_tg.check_id(args.mem_channel[0])
        if not tg_id:
            print(f"\n{tg_id}: Invalid TG ID detected..! Provide correct device index")
            return

        chk_id = args.check_id
        if chk_id:
            print(f"\nTG ID: 0x{tg_id}")
            return

        if "prbs" in args.data[0] and args.continuous == "on":
            print("\nprbsX is not supported in continuous mode")
            return

        print("\033[H\033[J", end="")
        print(get_timestamp(), "Starting test run...!")

        if args.mem_frequency == [0]:
            args.mem_frequency = [220]
            print(f"Memory channel clock frequency unknown. Assuming {args.mem_frequency[0]} MHz.",
                  "\nPress CTRL+C to exit.\n")
        else:
            print(f"Memory clock from command line: {args.mem_frequency} MHz.",
                    "\nPress CTRL+C to exit.\n")

        lock = Lock()
        threads_list = []

        for ch_pos, ch_num in enumerate(args.mem_channel):
            mem_tg.set_cfg_offset(int(ch_num))

            input_tg_var = mem_tg.initialize(args, ch_pos)
            threads = Thread(target = thread_run_memtg,
                            args = (lock, mem_tg,
                                    input_tg_var, ch_pos))
            threads.daemon = True # die when the main thread dies
            threads.start()
            threads_list.append(threads)

        for threads in threads_list:
            threads.join() # join seperartely only after each thread started

        for ch_pos, ch_num in enumerate(args.mem_channel):
            ch_freq = args.mem_frequency[ch_pos]
            tg_var = mem_tg.tg_var_list[ch_pos]
            out_tg_var = mem_tg.performance(ch_freq, ch_num)
            move_cursor(LINE_PRINT+3, ch_pos, 7)
            clear_line()
            print("Write BW :", f"{out_tg_var['w_bw']:.2f}", "Gb/s")
            print("Read BW  :", f"{out_tg_var['r_bw']:.2f}", "Gb/s")

    except KeyboardInterrupt:
        clear_line()
        for ch_pos, ch_num in enumerate(args.mem_channel):
            mem_tg.stop_tg(ch_num)
    finally:
        if input_tg_var:
            for ch_pos, ch_num in enumerate(args.mem_channel):
                move_cursor(LINE_PRINT - 1, ch_pos+1, 7)
                print(f"Channel: {ch_num} TG PASS")

            line = LINE_PRINT
            if chk_id:
                line = LINE_PRINT + 1
            move_cursor(LINE_PRINT, ch_size, 7)
            print(get_timestamp(), "Completed test run...!")

        intf_obj.close_device()

if __name__ == "__main__":
    main()
