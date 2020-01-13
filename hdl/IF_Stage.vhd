----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:18:22 12/11/2019 
-- Design Name: 
-- Module Name:    IF_Stage - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- HIP instruction fetch stage --

entity IF_Stage is
	Port (
		clk_i : in STD_LOGIC;
		rst_i : in STD_LOGIC;
		ce_i : in STD_LOGIC;
		PCselect_i : in STD_LOGIC_VECTOR (1 downto 0);
		NewPC_i : in STD_LOGIC_VECTOR (31 downto 0);
		C1_i : in STD_LOGIC_VECTOR (31 downto 0);
		Data_i : in STD_LOGIC_VECTOR (31 downto 0);
		Addr_o : out STD_LOGIC_VECTOR (31 downto 0);
		PC1_o : out STD_LOGIC_VECTOR (31 downto 0);
		IR_o : out STD_LOGIC_VECTOR (31 downto 0)
	);
end IF_Stage;

architecture Behavioral of IF_Stage is

	signal PC : STD_LOGIC_VECTOR (31 downto 0);
	signal PC1 : STD_LOGIC_VECTOR (31 downto 0);
	signal IR : STD_LOGIC_VECTOR (31 downto 0);

begin

	Addr_o <= PC;
	PC1_o <= PC1;
	IR_o <= IR;

	-- PC
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (rst_i = '1') then
				PC <= (others => '0');
			elsif (ce_i = '1') then
				case (PCselect_i) is
					when "00" => PC <= NewPC_i;
					when "01" => PC <= PC + 4;
					when "10" => PC <= C1_i;
					when others => PC <= (others => '0');
				end case;
			end if;
		end if;
	end process;
	
	-- PC1
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (rst_i = '1') then
				PC1 <= (others => '0');
			elsif (ce_i = '1') then
				PC1 <= PC;
			end if;
		end if;
	end process;
	
	-- IR
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (rst_i = '1') then
				IR <= (others => '0');
			elsif (ce_i = '1') then
				IR <= Data_i;
			end if;
		end if;
	end process;

end Behavioral;

