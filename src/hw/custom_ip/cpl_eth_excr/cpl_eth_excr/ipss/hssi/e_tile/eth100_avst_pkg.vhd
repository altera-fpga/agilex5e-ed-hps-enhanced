-- Copyright (c) 2008-2019, Silicom Denmark A/S
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- 1. Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- 2. Redistributions in binary form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- 3. Neither the name of the Silicom nor the names of its
-- contributors may be used to endorse or promote products derived from
-- this software without specific prior written permission.
--
-- 4. This software may only be redistributed and used in connection with a
--  Silicom network adapter product.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------------------------------------
-- Title      :
-- Project    :
-------------------------------------------------------------------------------
-- File       :
-- Author     :
-- Company    : Silicom Denmark A/S
-- Platform   :
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package eth100_avst_pkg is

   type eth100_avst_t is record
      sop   : std_logic;
      eop   : std_logic;
      valid : std_logic;
      err   : std_logic_vector(5 downto 0);
      data  : std_logic_vector(511 downto 0);
      empty : std_logic_vector(5 downto 0);
   end record;

   constant eth100_avst_t_zero : eth100_avst_t := (
      sop   => '0',
      eop   => '0',
      valid => '0',
      err   => (others=>'0'),
      data  => (others => '0'),
      empty => (others => '0')
      );

   type eth100_avst_port_t is array (natural range <>) of eth100_avst_t;

   function prbs64_calc (prbs_in : std_logic_vector(63 downto 0)) return std_logic_vector;



end package eth100_avst_pkg;

package body eth100_avst_pkg is

   -- purpose: Calculate PRBS value

   function prbs64_calc (prbs_in : std_logic_vector(63 downto 0)) return std_logic_vector is
      variable new_prbs : std_logic_vector(63 downto 0);
   begin

      new_prbs(63 downto 1) := prbs_in(62 downto 0);                                         -- Shift
      new_prbs(0)           := prbs_in(63) xor prbs_in(62) xor prbs_in(60) xor prbs_in(59);  -- calc new value.
      return new_prbs;
   end function prbs64_calc;

end package body eth100_avst_pkg;
