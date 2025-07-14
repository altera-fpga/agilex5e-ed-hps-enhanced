-------------------------------------------------------------------------------
-- Title      : Reset syncronizer
-- Project    :
-------------------------------------------------------------------------------
-- File       : reset_comb_sync.vhd
-- Author     : Palle Møller Nielsen
-- Company    : Fiberblaze A/S
-- Platform   :
-------------------------------------------------------------------------------
-- Copyright (c) 2021 Fiberblaze A/S
-------------------------------------------------------------------------------
-- Functional description:
-- This module takes in a set number of signals which does not have to be synchronised
-- to any clocks or can be synchronised to any clock.
-- These signals are combined to a single reset.
-- The single reset asserts output reset asynchronously to ensure that it can be
-- asserted even without a running clock.
-- It is de-asserted synchonously a set number of clock cycles after all incoming
-- resets are de-asserted.
-- The polarity of input and output reset signals can be selected.

-- TBD: skal dette slettes?:
-- This component can be inserted every where unsynchronized reset(s) shall be used in one or several clock domain(s).
-- By adding constraint below, input to every instance of the component will be set as false path.
-- This line does not work for Quartus 21.1 - it might work for Xilinx: set_false_path -setup -through  [get_pins -hierarchical -filter { REF_NAME =~  "*reset_comb_sync*" && NAME =~  "*resets_i*" }]
-- TBD what does work for Quartus 21.1?
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library UNISIM;
--use UNISIM.VCOMPONENTS.all;

entity reset_comb_sync is
   generic(
      G_RESET_I_QUANTITY    : natural := 1; -- Allowed range: 1 to ...
      G_RESETS_I_ACTIVE     : std_logic_vector(G_RESET_I_QUANTITY-1 downto 0) := (others => '0'); --
      G_RESET_O_QUANTITY    : natural := 1; -- Allowed range: 1 to ...
      G_CLOCK_SYNC_QUANTITY : natural := 7  -- Allowed range: 2 to ...
      --G_RESET_O_ACTIVE      : std_logic := '0' -- Allowed values: '0' or '1'
   );
   port(
      clocks_i       : in  std_logic_vector(G_RESET_O_QUANTITY-1 downto 0);
      resets_i       : in  std_logic_vector(G_RESET_I_QUANTITY-1 downto 0);
      resets_o       : out std_logic_vector(G_RESET_O_QUANTITY-1 downto 0);
      resets_n_o     : out std_logic_vector(G_RESET_O_QUANTITY-1 downto 0)
      );
end reset_comb_sync;

architecture synth of reset_comb_sync is

   signal resets_asserted : std_logic_vector(G_RESET_I_QUANTITY-1 downto 0) := (others => '1');

   signal reset_async_n     : std_logic := '0';

   type t_reset_shift_regs is array (0 to G_RESET_O_QUANTITY-1) of std_logic_vector(G_CLOCK_SYNC_QUANTITY-1 downto 0);
   signal reset_n_shift_regs : t_reset_shift_regs := (others => (others => '0'));
--attribute async_reg         : string;
--   signal meta                 : std_logic;
--   signal d3                   : std_logic;
--   signal d4                   : std_logic;
--   signal d5                   : std_logic;
--   attribute async_reg of meta : signal is "true";
--   attribute async_reg of d3   : signal is "true";
--   attribute async_reg of d4   : signal is "true";
--   attribute async_reg of d5   : signal is "true";

begin

   -- Determine which resets are asserted: when each bit
   input_lut : for n in 0 to G_RESET_I_QUANTITY-1 generate
      resets_asserted(n) <= '1' when resets_i(n) = G_RESETS_I_ACTIVE(n) else '0';
   end generate;

   -- if any input resets are asserted then assert asynchronous reset.
   -- It is an activ low signal to cater for an Asynchronous Clear Active Low input to the Flip flops
   reset_async_n <= '1' when 0 = to_integer(unsigned(resets_asserted)) else '0';

   output_register_chains : for n in 0 to G_RESET_O_QUANTITY-1 generate
      process(clocks_i(n), reset_async_n)
      begin
         if reset_async_n='0' then -- If in reset
            reset_n_shift_regs(n) <= (others => '0');
         elsif rising_edge(clocks_i(n)) then
            reset_n_shift_regs(n)(G_CLOCK_SYNC_QUANTITY-1 downto 1) <= reset_n_shift_regs(n)(G_CLOCK_SYNC_QUANTITY-2 downto 0);
            reset_n_shift_regs(n)(0) <= '1';
         end if;
      end process;

      resets_o(n)   <= not (reset_n_shift_regs(n)(G_CLOCK_SYNC_QUANTITY-1) );
      resets_n_o(n) <=     (reset_n_shift_regs(n)(G_CLOCK_SYNC_QUANTITY-1) );
   end generate;

end synth;
