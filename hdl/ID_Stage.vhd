----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:22:28 12/11/2019 
-- Design Name: 
-- Module Name:    ID_Stage - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- HIP instruction decode stage --

entity ID_Stage is
	Port (
		clk_i : in STD_LOGIC;
		rst_i : in STD_LOGIC;
		ce_i : in STD_LOGIC;
		PC1_i : in STD_LOGIC_VECTOR (31 downto 0);
		IR_i : in STD_LOGIC_VECTOR (31 downto 0);
		CtoReg_i : in STD_LOGIC_VECTOR (4 downto 0);
		C1_i : in STD_LOGIC_VECTOR (31 downto 0);
		PC2_o : out STD_LOGIC_VECTOR (31 downto 0);
		A_o : out STD_LOGIC_VECTOR (31 downto 0);
		B_o : out STD_LOGIC_VECTOR (31 downto 0);
		IR1_o : out STD_LOGIC_VECTOR (31 downto 0)
	);
end ID_Stage;

architecture Behavioral of ID_Stage is

	type reg_type is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
	signal REG_BLOCK : reg_type := (others => (others => '0'));
	
	signal PC2 : STD_LOGIC_VECTOR (31 downto 0);
	signal A : STD_LOGIC_VECTOR (31 downto 0);
	signal B : STD_LOGIC_VECTOR (31 downto 0);
	signal IR1 : STD_LOGIC_VECTOR (31 downto 0);

begin

	PC2_o <= PC2;
	A_o <= A;
	B_o <= B;
	IR1_o <= IR1;

	-- PC2
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (rst_i = '1') then
				PC2 <= (others => '0');
			elsif (ce_i = '1') then
				PC2 <= PC1_i;
			end if;
		end if;
	end process;
	
	-- A
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (rst_i = '1') then
				A <= (others => '0');
			elsif (ce_i = '1') then
				A <= REG_BLOCK(conv_integer(IR_i(25 downto 21)));
			end if;
		end if;
	end process;
	
	-- B
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (rst_i = '1') then
				B <= (others => '0');
			elsif (ce_i = '1') then
				B <= REG_BLOCK(conv_integer(IR_i(20 downto 16)));
			end if;
		end if;
	end process;
	
	-- C
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (ce_i = '1' and conv_integer(CtoReg_i) /= 0) then
				REG_BLOCK(conv_integer(CtoReg_i)) <= C1_i;
			end if;
		end if;
	end process;
	
	-- IR1
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (rst_i = '1') then
				IR1 <= (others => '0');
			elsif (ce_i = '1') then
				IR1 <= IR_i;
			end if;
		end if;
	end process;

end Behavioral;