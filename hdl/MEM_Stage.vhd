----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:29:08 01/01/2020 
-- Design Name: 
-- Module Name:    mem - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem is
    Port ( clk_i	: in STD_LOGIC;
			  rst_i	: in STD_LOGIC;
			  ce_i	: in STD_LOGIC;
			  memen_o: out STD_LOGIC;
			  writeen_o: out STD_LOGIC;
           C_i		: in STD_LOGIC_VECTOR (31 downto 0);
			  MAR_i	: in STD_LOGIC_VECTOR (31 downto 0);
			  SDR_i	: in STD_LOGIC_VECTOR (31 downto 0);
			  IR2_i	: in STD_LOGIC_VECTOR (31 downto 0);
			  C1_o	: out STD_LOGIC_VECTOR (31 downto 0);
			  MAR_o	: out STD_LOGIC_VECTOR (31 downto 0);
			  Data_o	: out STD_LOGIC_VECTOR (31 downto 0);
			  IR3_o	: out STD_LOGIC_VECTOR (31 downto 0);
			  Data_i	: in STD_LOGIC_VECTOR (31 downto 0)
			 );
end mem;

architecture Behavioral of mem is
	signal instruction : STD_LOGIC_VECTOR (5 downto 0);
	signal IR : STD_LOGIC_VECTOR (31 downto 0);
begin
	instruction<=IR2_i(31 downto 26);
	IR3_o<=IR;
	process(clk_i)
	begin
		if(clk_i'event and clk_i='1') then
			if(rst_i='1') then
				IR<=(others=>'0');
			else
				if(ce_i='1') then
					IR<=IR2_i;
					--load
					if(instruction="100110") then
						MAR_o<=MAR_i;
						C1_o<=Data_i;
						memen_o<='1';
						writeen_o<='0';
					--store
					elsif(instruction="101010")
						MAR_o<=MAR_i;
						Data_o<=SDR_i;
						memen_o<='1';
						writeen_o<='1';
					--other
					else
						memen_o<='0';
						C1_o<=C_i;
					end if;
				end if;
			end if;
		end if;
	end process
end Behavioral;

