FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://ffrd_exercisor_sw/ \
	   "

FILES:${PN} += "/home/root/ffrd_exercisor_sw/ \
	       "

do_install:append() {
	cd ${S}
	if [[ "${MACHINE}" == *"agilex5"* ]]; then
		install -d ${D}/home/root/ffrd_exercisor_sw
		cp -rf ${WORKDIR}/sources-unpack/ffrd_exercisor_sw/ ${D}/home/root/
	fi
}