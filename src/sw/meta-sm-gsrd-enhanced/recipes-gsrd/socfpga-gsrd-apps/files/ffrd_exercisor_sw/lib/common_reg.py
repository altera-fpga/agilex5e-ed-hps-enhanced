from .interfaces.hps.lib_hps import HPS

intf_types = {"hps": HPS}

class interface:
    """ A wrapper class to perform all functionalities of specified interface type """
    def __init__(self, intf, **kwargs):
        self.name = intf
        self.interface = intf_types[self.name]
        self.device = self.interface(**kwargs)

    def write_32(self, *args, **kwargs):
        """ A wrapper function to perform 32bit write method of specified interface type """
        return self.device.write_reg_32(*args, **kwargs)

    def read_32(self, *args, **kwargs):
        """ A wrapper function to perform 32bit read method of specified interface type """
        return self.device.read_reg_32(*args, **kwargs)

    def read_sdm(self, *args, **kwargs):
        """ A wrapper function to perform sdm read method of specified interface type """
        return self.device.read_reg_sdm(*args, **kwargs)

    def read_16(self, *args, **kwargs):
        """ A wrapper function to perform 16bit read method of specified interface type """
        return self.device.read_reg_16(*args, **kwargs)

    def read_8(self, *args, **kwargs):
        """ A wrapper function to perform 8bit read method of specified interface type """
        return self.device.read_reg_8(*args, **kwargs)

    def open_device(self, *args, **kwargs):
        """ A wrapper function to open the interface device """
        return self.device.open(*args, **kwargs)

    def close_device(self, *args, **kwargs):
        """ A wrapper function to close the interface device """
        return self.device.close(*args, **kwargs)
