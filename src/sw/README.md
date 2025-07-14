# Altera SoCFPGA Golden Software Reference Design

GSRD is an Embedded Linux Reference Distribution optimized for SoCFPGA.  
It is based on Yocto Project Poky reference distribution.

## Meta Layers

* meta-sm-gsrd-enhanced - SoCFPGA Enhanced GSRD Customization Layer
* meta-intel-fpga - SoCFPGA BSP Core Layer
* meta-intel-fpga-refdes - SoCFPGA GSRD Customization Layer

Dependencies
* poky - Core Layer from Yocto Project
* meta-openembedded - Additional features (python, networking tools, etc) for GSRD

## Using The Script

## Supported Image Variant:  

|    Target                  |              Image                           |
| -------------------------- | -------------------------------------------- |
| Agilex5 DK-A5E065BB32AES1  |   gsrd                 |
| Agilex5 MK-A5E065BB32AES1  |   gsrd                                       |


## Enhanced GSRD Setup

1. Clone the repository  
`$ https://github.com/altera-innersource/applications.fpga.soc.agilex5e-ed-gsrd-enhanced.git`
2. Sync the submodules  
`$ cd applications.fpga.soc.agilex5e-ed-gsrd-enhanced/src/sw`  
`$ git submodule update --init -r`
3. Source the script to export component version (Linux,U-Boot,ATF,Machine,Image)  

|  Target                    |            Command                             |
| -------------------------- | ---------------------------------------------- |
| Agilex5 DK-A5E065BB32AES1  | `$ . agilex5_dk_a5e065bb32aes1-gsrd-build.sh`    |
| Agilex5 MK-A5E065BB32AES1  | `$ . agilex5_mk_a5e065bb32aes1-gsrd-build.sh`    |

4. Setup Build environment for GSRD   
`$ build_setup`  

<pre>
5. OPTIONAL:  GHRD:  
              1. Add custom GHRD design in:  
                 $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/ghrd/files  
                 NOTE: Update/Replace the file with the same naming convention  
                       For Agilex5 DK-A5E065BB32AES1:-  
                                  agilex5_dk_a5e065bb32aes1_gsrd_ghrd.core.rbf 
                       For Agilex5 MK-A5E065BB32AES1:-
                                  agilex5_mk_a5e065bb32aes1_gsrd_ghrd.core.rbf
              2. Update SRC_URL in the recipe:  
                 $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/ghrd/hw-ref-design.bb  
                 Note: Update the SRC_URL using the example below  
                       Include the required file with sha256sum  
                 Eg:-  
                       SRC_URI:agilex5_dk_a5e065bb32aes1 ?= "\  
                                           file://agilex5_dk_a5e065bb32aes1_gsrd_ghrd.core.rbf;sha256sum=xxxx \  
                                           "  
              U-BOOT:  
                 For Agilex and Stratix10:-  
                     Edit uboot.txt, uboot_script.its in:  
                     $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/u-boot/files  
                     Edit fit_kernel_(agilex*/stratix10).its in:  
                     $WORKSPACE/meta-intel-fpga-refdes/recipes-kernel/linux/linux-socfpga-lts  
</pre>
6. Perform Yocto bitbake to generate binaries  
`$ bitbake_image`
7. Package binaries into build folder  
`$ package`  
