from enum import Enum, IntEnum

TG_ID = "ac130002"

class status(IntEnum):
    success = 1
    error   = 0

class VALUE_BITS(IntEnum):
    STOP_BITS  = 0xa
    ZERO       = 0x0
    ONE        = 0x1

class DATA_CNF(IntEnum):
    PKT_NUM          = 0x80000000
    CONTINUOUS_MODE  = 0x00000000
    FIXED_MODE       = 0x80000000

class CTRL_REGISTERS(IntEnum):
    TRAFFIC_CTRL_CMD_L	    = 0x0090
    TRAFFIC_CTRL_CMD_H	    = 0x0098
    TRAFFIC_CTRL_CH_SEL_L	= 0x0100
    TRAFFIC_CTRL_CH_SEL_H	= 0x0108
    TRAFFIC_CTRL_DATA_L	    = 0x0110
    TRAFFIC_CTRL_DATA_H	    = 0x0118

class TRAFFIC_REGISTERS(IntEnum):
    CSR_PKT_SIZE	            = 0x1008
    PKT_CL_PKT_NUM              = 0x1009
    PKT_CL_PKT_GEN_CTRL         = 0x1010
    CSR_TX_COUNT                = 0x1017
    CSR_STATS_CTRL              = 0x1018
    CSR_STATS_TX_CNT_LO         = 0x1019
    CSR_STATS_TX_CNT_HI         = 0x101A
    CSR_STATS_RX_CNT_LO         = 0x101B
    CSR_STATS_RX_CNT_HI         = 0x101C
    CSR_STATS_RX_GD_CNT_LO      = 0x101D
    CSR_STATS_RX_GD_CNT_HI      = 0x101E
    CSR_TX_START_TIMESTAMP_LO   = 0x101F
    CSR_TX_START_TIMESTAMP_HI   = 0x1020
    CSR_TX_END_TIMESTAMP_LO     = 0x1021
    CSR_TX_END_TIMESTAMP_HI     = 0x1022
    CSR_RX_START_TIMESTAMP_LO   = 0x1023
    CSR_RX_START_TIMESTAMP_HI   = 0x1024
    CSR_RX_END_TIMESTAMP_LO     = 0x1025
    CSR_RX_END_TIMESTAMP_HI     = 0x1026

class CTRL_REGISTERS_10G(IntEnum):
    AFU_ID_Ll               = 0x0070
    AFU_ID_Lh               = 0x0078
    TRAFFIC_CTRL_CMD_L	    = 0x0090
    TRAFFIC_CTRL_CMD_H	    = 0x0098
    TRAFFIC_CTRL_CH_SEL_L	= 0x0100
    TRAFFIC_CTRL_CH_SEL_H	= 0x0108
    TRAFFIC_CTRL_DATA_L	    = 0x0110
    TRAFFIC_CTRL_DATA_H	    = 0x0118

class TRAFFIC_REGISTERS_10G(IntEnum):
    CSR_NUM_PACKETS         = 0x3c00
    CSR_RANDOM_LENGTH       = 0x3c01
    CSR_RANDOM_PAYLOAD      = 0x3c02
    CSR_START               = 0x3c03
    CSR_STOP                = 0x3c04
    CSR_SRC_ADDR_LO         = 0x3c05
    CSR_SRC_ADDR_HI         = 0x3c06
    CSR_DEST_ADDR_LO        = 0x3c07
    CSR_DEST_ADDR_HI        = 0x3c08
    CSR_PACKET_TX_COUNT     = 0x3c09
    CSR_RND_SEED0           = 0x3c0a
    CSR_RND_SEED1           = 0x3c0b
    CSR_RND_SEED2           = 0x3c0c
    CSR_PACKET_LENGTH       = 0x3c0d
    CSR_PAUSE               = 0x3c0e
    CSR_PFC_PAUSE           = 0x3c0e
    CSR_CONT_MODE           = 0x3c10
    CSR_TX_STA_TSTAMP_L     = 0x3c12
    CSR_TX_STA_TSTAMP_H     = 0x3c13
    CSR_TX_END_TSTAMP_L     = 0x3c14
    CSR_TX_END_TSTAMP_H     = 0x3c15
    CSR_TX_STA_TSTAMP       = 0x3cf4
    CSR_TX_END_TSTAMP       = 0x3cf5

    CSR_NUM_PKT             = 0x3d00
    CSR_PKT_GOOD            = 0x3d01
    CSR_PKT_BAD             = 0x3d02
    CSR_BYTE_CNT0           = 0x3d03
    CSR_BYTE_CNT1           = 0x3d04
    CSR_AVST_RX_ERR         = 0x3d07
    CSR_RX_STA_TSTAMP       = 0x3d0b
    CSR_RX_END_TSTAMP       = 0x3d0c
    CSR_PKT_GOOD_64_L       = 0x3d0d
    CSR_PKT_GOOD_64_H       = 0x3d0e
    CSR_PKT_BAD_64_L        = 0x3d0f
    CSR_PKT_BAD_64_H        = 0x3d10
    CSR_PERF_CAP_TRIG       = 0x3d11
    CSR_RX_STA_TSTAMP_L     = 0x3d12
    CSR_RX_STA_TSTAMP_H     = 0x3d13
    CSR_RX_END_TSTAMP_L     = 0x3d14
    CSR_RX_END_TSTAMP_H     = 0x3d15
    CSR_TM_GOOD_64_L        = 0x3d16
    CSR_TM_GOOD_64_H        = 0x3d17
    CSR_TM_BAD_64_L         = 0x3d18
    CSR_TM_BAD_64_H         = 0x3d19

    CSR_LOOPBACK_EN         = 0x3e00
    CSR_LOOPBACK_FIFO       = 0x3e01
