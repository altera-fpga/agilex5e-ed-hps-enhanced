import os
import mmap
import struct
from threading import Lock

global temp
temp = 1
DEBUG = False

class HPS():
    """ A HPS interface driver class to perform open, close, read and write operations """
    def __init__(self, dev_path):
        self.hps_device = ""
        self.mem_path = dev_path
        self.base_addr = 0x0000000
        self.lock = Lock()

    def open(self, size = 1, *args, **kwargs):
        """ To open an user-specified HPS device """
        if DEBUG:
            print("\nOpening HPS device...")
        self.lock.acquire()

        self.size = (mmap.PAGESIZE * size)
        self.MAP_MASK = self.size - 1

        self.file = os.open(self.mem_path, os.O_RDWR | os.O_SYNC)

        self.map_base = mmap.mmap(self.file, self.size, mmap.MAP_SHARED, mmap.PROT_WRITE |
                                  mmap.PROT_READ, offset=self.base_addr & ~self.MAP_MASK)
        self.memview = memoryview(self.map_base)
        self.memview32 = self.memview.cast('I')
        self.lock.release()

    def close(self, *args, **kwargs):
        """ To close an user-specified HPS device """
        if DEBUG:
            print("\nClosing HPS device...")
        global temp
        self.lock.acquire()
        self.memview.release()
        # self.map_base.close()
        if temp == 1:
            os.close(self.file)
            temp = 0
        self.lock.release()

    def read_reg_32(self, base_csr, offset, bytesize=1, endian="big"):
        """
        Read and returns the data from the 32-bit register offset provided.

        Parameters
        ----------
        base_csr : int (hex format)
            Value of base address of the register space.
        offset : int (hex format)
            Value of offset address of the register space.
        bytesize : int
            Value of byte size to be read.
        endian : str
            Value of endianness of the register address.

        Raises
        ------
        none

        Returns
        -------
        read_result : bytearray
            Value of data read of specific bytes in bytearray format.
        """
        if DEBUG:
            print("\nHPS read reg 32")
        self.lock.acquire()
        addr = base_csr + offset
        # addr = base_csr
        length = ((bytesize + 3) & -4)
        read_result = bytearray([0] * length)
        for i in range(0, bytesize):
            j = i*4
            value = self.memview32[(addr+j) // 4].to_bytes(length, endian) # .to_bytes(length, endian)
            read_result[j: j + 4] = value

        if DEBUG:
            print("addr:",hex(addr),"base_csr:",hex(base_csr),"offset:",hex(offset),"read:", read_result.hex(), "memview: ", (addr+j) // 4)
        self.lock.release()
        return read_result

    def write_reg_32(self, base_csr , offset , value ):
        """
        Writes the data to the 32-bit register offset provided.

        Parameters
        ----------
        base_csr : int (hex format)
            Value of base address of the register space.
        offset : int (hex format)
            Value of offset address of the register space.
        value : int
            Value to be written to the register space.

        Raises
        ------
        none

        Returns
        -------
        none
        """
        if DEBUG:
            print("\nHPS write reg 32")

        self.lock.acquire()
        addr = base_csr + offset
        self.memview32[addr // 4] = value
        if DEBUG:
            print("addr:",hex(addr ),"base_csr:",hex(base_csr),"offset:",hex(offset),",write:",hex(value))

        self.lock.release()
