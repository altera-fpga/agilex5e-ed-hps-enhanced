# Agilex 5e HPS Enhanced System Example Design 

HPS Enhanced System Example Design is for Altera 5e System On Chip (SoC) FPGA. It works together with a complete solution to boot Uboot and Linux with Altera SoC Development board.

This example design demonstrates the following system integration between Hard Processor System (HPS) and FPGA IPs:
- Hard Processor System enablement and configuration
  - HPS Peripheral and I/O (eg, NAND, SD/MMC, EMAC, USB, SPI, I2C, UART, and GPIO)
  - HPS Clock and Reset
  - HPS FPGA Bridge and Interrupt
- HPS EMIF configuration
- System integration with FPGA IPs
  - SYSID
  - Programmable I/O (PIO) IP for controlling DIPSW, PushButton, and LEDs)
  - FPGA On-Chip Memory
  - Ethernet IP
  - Fabric EMIF

Build scripts are organized according to the Intel SoC FPGA Family:
Enhanced GSRD for Intel Quartus Prime Pro Edition

## Build Steps:
Refer to the README in repective folder for build steps.

## Repository Structure

- Directory Structure used in this example design
 ```bash
    |--- src
    |   |--- hw 
    |   |--- sw 
 ```

## Project Details 
- **Family**: Agilex 5 E-Series
- **Quartus Version**: 25.1.0 Pro Edition
- **Development Kit**: Agilex 5 FPGA E-Series 065B Premium Development Kit DK-A5E065BB32AES1
- **Device Part**: A5ED065BB32AE6SR0

## Getting Started
Follow the steps below to build the design
- [HW Build Readme](src/hw/README.md)
- [SW Build Readme](src/sw/README.md)
  
Enhanced GSRD Wiki
- [Wiki](https://github.com/altera-innersource/applications.fpga.soc.agilex5e-ed-gsrd-enhanced/wiki)
