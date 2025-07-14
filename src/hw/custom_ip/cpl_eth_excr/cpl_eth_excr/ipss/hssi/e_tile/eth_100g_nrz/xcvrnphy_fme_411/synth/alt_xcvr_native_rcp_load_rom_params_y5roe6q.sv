// Parameters for embedded adaptation streamer

package alt_xcvr_native_rcp_load_rom_params_y5roe6q;

  localparam rom_data_width = 32; // ROM data width
  localparam rom_depth = 48; // Depth of adaptation rom
  localparam max_depth = 25; // Max Depth of single profile rom
  localparam ical_depth_list = "25,21,1"; //Depth list for individual profile
  // Adaptation rom containing all profiles in order
  localparam reg [31:0] config_rom [0:47] = '{
    32'h91000009,
    32'h9102000B,
    32'h91030003,
    32'h91060000,
    32'h91070000,
    32'h91210030,
    32'h9110FFFC,
    32'h91130004,
    32'h91150006,
    32'h91170004,
    32'h91190000,
    32'h911A0000,
    32'h911B000A,
    32'h91200082,
    32'h91220019,
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
    32'hFFFFFFFF,
    32'hFFFFFFFF
  };
endpackage