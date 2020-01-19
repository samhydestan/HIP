----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:17:56 01/02/2020 
-- Design Name: 
-- Module Name:    wb - Behavioral 
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

entity WB_Stage is
    Port ( --clk_i		: in  STD_LOGIC;
           --rst_i		: in  STD_LOGIC;
           --ce_i		: in  STD_LOGIC;
           C1_i		: in  STD_LOGIC_VECTOR (31 downto 0);
           IR3_i		: in  STD_LOGIC_VECTOR (31 downto 0);
			  CtoReg_o	: out STD_LOGIC_VECTOR (4 downto 0);
			  C1_o		: out STD_LOGIC_VECTOR (31 downto 0);
			  SetC1_o	: out STD_LOGIC
			 );
end WB_Stage;

architecture Behavioral of WB_Stage is
	signal instruction : STD_LOGIC_VECTOR (5 downto 0);
begin
	instruction<=IR3_i(31 downto 26);
	--process(clk_i)
	--begin
	--	if(clk_i'event and clk_i='1') then
	--		if(rst_i='1') then
	--			CtoReg_o<=(others=>'0');
	--			C1_o<=(others=>'0');
	--		else
	--			if(ce_i='1') then
	--				--ALU instr., load, call, mover
	--				if((instruction(5 downto 3)="100" and instruction(1 downto 0)/="11") or instruction(5 downto 3)="000" or instruction(5 downto 3)="001" or instruction(5 downto 3)="010" or instruction(5 downto 3)="000" or (instruction(5 downto 3)="110" and instruction(5 downto 3)/="110") or instruction(5 downto 3)="111" or instruction="101101") then
	--					C1_o<=C1_i;
	--					SetC1_o<='0';
	--					--format 2
	--					if(instruction(5 downto 4)="11") then
	--						CtoReg_o<=IR3_i(15 downto 11);
	--					--format 1
	--					else
	--						CtoReg_o<=IR3_i(20 downto 16);
	--					end if;
	--				--trap
	--				elsif(instruction="101110") then
	--					C1_o<=C1_i;
	--					SetC1_o<='1';
	--					CtoReg_o<=(others=>'0');
	--				else
	--					CtoReg_o<=(others=>'0');
	--					SetC1_o<='0';
	--				end if;
	--			end if;
	--		end if;
	--	end if;
	--end process;
	
	process (instruction, C1_i, IR3_i(20 downto 11))
	begin
		--ALU instr., load, call, mover
		if((instruction(5 downto 3)="100" and instruction(1 downto 0)/="11") or instruction(5 downto 3)="000" or instruction(5 downto 3)="001" or instruction(5 downto 3)="010" or instruction(5 downto 3)="000" or (instruction(5 downto 3)="110" and instruction(5 downto 3)/="110") or instruction(5 downto 3)="111" or instruction="101101") then
			C1_o<=C1_i;
			SetC1_o<='0';
			--format 2
			if(instruction(5 downto 4)="11") then
				CtoReg_o<=IR3_i(15 downto 11);
				--format 1
			else
				CtoReg_o<=IR3_i(20 downto 16);
			end if;
		--trap
		elsif(instruction="101110") then
			C1_o<=C1_i;
			SetC1_o<='1';
			CtoReg_o<=(others=>'0');
		else
			CtoReg_o<=(others=>'0');
			SetC1_o<='0';
		end if;
	end process;
end Behavioral;

