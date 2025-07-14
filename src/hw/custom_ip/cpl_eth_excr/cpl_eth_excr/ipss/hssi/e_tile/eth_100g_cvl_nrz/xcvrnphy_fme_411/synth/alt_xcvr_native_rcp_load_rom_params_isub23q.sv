// Parameters for embedded adaptation streamer

package alt_xcvr_native_rcp_load_rom_params_isub23q;

  localparam rom_data_width = 32; // ROM data width
  localparam rom_depth = 22; // Depth of adaptation rom
  localparam max_depth = 21; // Max Depth of single profile rom
  localparam ical_depth_list = "21"; //Depth list for individual profile
  // Adaptation rom containing all profiles in order
  localparam reg [31:0] config_rom [0:21] = '{
    32'h91020003,
    32'h91060002,
    32'h91070002,
    32'h91210030,
    32'h91150006,
    32'h91190001,
    32'h911A0001,
    32'h911B000A,
    32'h91200082,
    32'h91220019,
    32'h92020003,
    32'h92060002,
    32'h92070002,
    32'h92210032,
    32'h92150006,
    32'h92190008,
    32'h921A0001,
    32'h921B000A,
    32'h92200082,
    32'h92220019,
    32'hFFFFFFFF,
    32'hFFFFFFFF
  };
endpackage