from enum import Enum, IntEnum

TG_ID = "0e7dacac"

class ADDR_MODE(IntEnum):
    TG_ADDR_RAND     = 0
    TG_ADDR_SEQ      = 1
    TG_ADDR_RAND_SEQ = 2
    TG_ADDR_ONE_HOT  = 3

class STAT(IntEnum):
    TG_STATUS_ACTIVE = 0x1
    TG_STATUS_INACTIVE = 0x0
    TG_STATUS_TIMEOUT = 0x2
    TG_STATUS_ERROR = 0x4
    TG_STATUS_PASS  = 0x8

class REG(IntEnum):
    AFU_DFH         = 0x0000
    AFU_ID_L        = 0x0008
    AFU_ID_H        = 0x0010
    NEXT_AFU        = 0x0018
    AFU_DFH_RSVD    = 0x0020
    SCRATCHPAD      = 0x0028
    MEM_TG_CTRL     = 0x0030
    MEM_TG_STAT     = 0x0038
    MEM_TG_CLOCKS   = 0x0303

class TG_REGISTERS(IntEnum):
    TG_VERSION                 = 0x000
    TG_START                   = 0x001
    TG_LOOP_COUNT              = 0x002
    TG_WRITE_COUNT             = 0x003
    TG_READ_COUNT              = 0x004
    TG_WRITE_REPEAT_COUNT      = 0x005
    TG_READ_REPEAT_COUNT       = 0x006
    TG_BURST_LENGTH            = 0x007
    TG_CLEAR                   = 0x008
    TG_RW_GEN_IDLE_COUNT       = 0x00E
    TG_RW_GEN_LOOP_IDLE_COUNT  = 0x00F
    TG_SEQ_START_ADDR_WR_L     = 0x010
    TG_SEQ_START_ADDR_WR_H     = 0x011
    TG_ADDR_MODE_WR            = 0x012
    TG_RAND_SEQ_ADDRS_WR       = 0x013
    TG_RETURN_TO_START_ADDR    = 0x014
    TG_SEQ_ADDR_INCR           = 0x01D
    TG_SEQ_START_ADDR_RD_L     = 0x01E
    TG_SEQ_START_ADDR_RD_H     = 0x01F
    TG_ADDR_MODE_RD            = 0x020
    TG_RAND_SEQ_ADDRS_RD       = 0x021
    TG_PASS                    = 0x022
    TG_FAIL                    = 0x023
    TG_FAIL_COUNT_L            = 0x024
    TG_FAIL_COUNT_H            = 0x025
    TG_FIRST_FAIL_ADDR_L       = 0x026
    TG_FIRST_FAIL_ADDR_H       = 0x027
    TG_TOTAL_READ_COUNT_L      = 0x028
    TG_TOTAL_READ_COUNT_H      = 0x029
    TG_TEST_COMPLETE           = 0x02A
    TG_INVERT_BYTEEN           = 0x02B
    TG_RESTART_DEFAULT_TRAFFIC = 0x02C
    TG_USER_WORM_EN            = 0x02D
    TG_TEST_BYTEEN             = 0x02E
    TG_TIMEOUT                 = 0x02F
    TG_NUM_DATA_GEN            = 0x031
    TG_NUM_BYTEEN_GEN          = 0x032
    TG_RDATA_WIDTH             = 0x037
    TG_ERROR_REPORT            = 0x03B
    TG_DATA_RATE_WIDTH_RATIO   = 0x03C
    TG_PNF                     = 0x040
    TG_FAIL_EXPECTED_DATA      = 0x080
    TG_FAIL_READ_DATA          = 0x0C0
    TG_DATA_SEED               = 0x100
    TG_BYTEEN_SEED             = 0x200
    TG_PPPG_SEL                = 0x300
    TG_BYTEEN_SEL              = 0x3A0
    TG_AFU_ID                  = 0x3B0
    TG_CLOCK_COUNT_L           = 0x3B4
    TG_CLOCK_COUNT_H           = 0x3B8
    TG_WRITE_COUNTER_L         = 0x3B9
    TG_WRITE_COUNTER_H         = 0x3BA
    TG_READ_COUNTER_L          = 0x3BB
    TG_READ_COUNTER_H          = 0x3BC
    TG_ACTIVE                  = 0x3BD
    # TG_ADDR_FIELD_RELATIVE_FREQ
    # TG_ADDR_FIELD_MSB_INDEX
    # TG_BURSTLENGTH_OVERFLOW_OCCURRED
    # TG_BURSTLENGTH_FAIL_ADDR_L
    # TG_BURSTLENGTH_FAIL_ADDR_H
    # TG_WORM_MODE_TARGETTED_DATA