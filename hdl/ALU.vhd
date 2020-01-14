----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:43:29 12/11/2019 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- HIP arithmetic logic unit --

entity ALU is
	Port (
		ALUop_i : in STD_LOGIC_VECTOR (4 downto 0);
		x_i : in STD_LOGIC_VECTOR (31 downto 0);
		y_i : in STD_LOGIC_VECTOR (31 downto 0);
		z_o : out STD_LOGIC_VECTOR (31 downto 0)
	);
end ALU;

architecture Behavioral of ALU is

	component Barrel_Shifter
		Port (
			ALUop_i : in STD_LOGIC_VECTOR (4 downto 0);
			x_i : in STD_LOGIC_VECTOR (31 downto 0);
			y_i : in STD_LOGIC_VECTOR (31 downto 0);
			shift_o : out STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;

	signal add_sub_op : STD_LOGIC_VECTOR (31 downto 0);
	signal is_zero : STD_LOGIC;
	signal and_op : STD_LOGIC_VECTOR (31 downto 0);
	signal or_op : STD_LOGIC_VECTOR (31 downto 0);
	signal xor_op : STD_LOGIC_VECTOR (31 downto 0);
	signal lhi_op : STD_LOGIC_VECTOR (31 downto 0);
	signal set_op : STD_LOGIC_VECTOR (31 downto 0);
	signal not_op : STD_LOGIC_VECTOR (31 downto 0);
	signal shift_op : STD_LOGIC_VECTOR (31 downto 0);
	signal y_times_2_op : STD_LOGIC_VECTOR (31 downto 0);

	signal z : STD_LOGIC_VECTOR (31 downto 0);

begin

	z_o <= z;
	
	-- ADD/SUB
	process (ALUop_i, x_i, y_i)
	begin
		case ALUop_i is
			when "00000"|"00010" =>
				add_sub_op <= x_i + y_i;
			when others =>
				add_sub_op <= x_i - y_i;
		end case;
	end process;
	
	-- IS ZERO
	is_zero <= '1' when add_sub_op = 0 else '0';
	
	-- AND
	and_op <= x_i and y_i;
	
	-- OR
	or_op <= x_i or y_i;
	
	-- XOR
	xor_op <= x_i xor y_i;
	
	-- LHI
	lhi_op(31 downto 16) <= y_i(15 downto 0);
	lhi_op(15 downto 0) <= (others => '0');
	
	-- SET
	process (ALUop_i, x_i(31), y_i(31), add_sub_op(31), is_zero)
	begin
		set_op(31 downto 1) <= (others => '0');
	
		case ALUop_i is
			when "01000" =>
				set_op(0) <= is_zero;
			when "01001" =>
				set_op(0) <= not is_zero;
			when "01010" =>
				set_op(0) <= (x_i(31) and (not y_i(31))) or ((((not x_i(31)) and (not y_i(31))) or (x_i(31) and y_i(31))) and (add_sub_op(31) and (not is_zero)));
			when "01011" =>
				set_op(0) <= ((not x_i(31)) and y_i(31)) or ((((not x_i(31)) and (not y_i(31))) or (x_i(31) and y_i(31))) and ((not add_sub_op(31)) and (not is_zero)));
			when "01100" =>
				set_op(0) <= add_sub_op(31) and (not is_zero);
			when "01101" =>
				set_op(0) <= (not add_sub_op(31)) and (not is_zero);
			when others =>
				set_op(0) <= '0';
		end case;
	end process;
	
	-- NOT
	not_op <= not x_i;
	
	-- SHIFT
	bs: Barrel_Shifter
	port map (
		ALUop_i => ALUop_i,
		x_i => x_i,
		y_i => y_i,
		shift_o => shift_op
	);
	
	-- 2Y
	y_times_2_op(31 downto 1) <= y_i(30 downto 0);
	y_times_2_op(0) <= '0';
	
	-- MUX
	process (ALUop_i, add_sub_op, and_op, or_op, xor_op, lhi_op, set_op, not_op, x_i, shift_op, y_i, y_times_2_op)
	begin
		case ALUop_i is
			when "00000"|"00001"|"00010"|"00011" =>
				z <= add_sub_op;
			when "00100" =>
				z <= and_op;
			when "00101" =>
				z <= or_op;
			when "00110" =>
				z <= xor_op;
			when "00111" =>
				z <= lhi_op;
			when "01000"|"01001"|"01010"|"01011"|"01100"|"01101" =>
				z <= set_op;
			when "01110" =>
				z <= not_op;
			when "01111" =>
				z <= x_i;
			when "10000"|"10001"|"10010" =>
				z <= shift_op;
			when "10011" =>
				z <= y_i;
			when "10100" =>
				z <= y_times_2_op;
			when others =>
				z <= (others => '0');
		end case;
	end process;

end Behavioral;