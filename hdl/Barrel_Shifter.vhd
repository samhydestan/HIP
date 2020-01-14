----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:06:11 01/04/2020 
-- Design Name: 
-- Module Name:    Barrel_Shifter - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Barrel_Shifter is
	Port (
		ALUop_i : in STD_LOGIC_VECTOR (4 downto 0);
		x_i : in STD_LOGIC_VECTOR (31 downto 0);
		y_i : in STD_LOGIC_VECTOR (31 downto 0);
		shift_o : out STD_LOGIC_VECTOR (31 downto 0)
	);
end Barrel_Shifter;

architecture Behavioral of Barrel_Shifter is

begin

	process (ALUop_i, x_i, y_i)
	begin
		case ALUop_i is
			when "10000" =>
				shift_o <= std_logic_vector(unsigned(x_i) sll to_integer(unsigned(y_i)));
			when "10001" =>
				shift_o <= std_logic_vector(unsigned(x_i) srl to_integer(unsigned(y_i)));
			when "10010" =>
				shift_o <= to_stdlogicvector(to_bitvector(x_i) sra to_integer(unsigned(y_i)));
			when others =>
				shift_o <= (others => '0');
		end case;
	end process;

end Behavioral;