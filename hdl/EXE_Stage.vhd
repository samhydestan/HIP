----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:29:27 12/11/2019 
-- Design Name: 
-- Module Name:    EXE_Stage - Behavioral 
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

-- HIP execute stage --

entity EXE_Stage is
	Port (
		clk_i : in STD_LOGIC;
		rst_i : in STD_LOGIC;
		ce_i : in STD_LOGIC;
		PC2_i : in STD_LOGIC_VECTOR (31 downto 0);
		A_i : in STD_LOGIC_VECTOR (31 downto 0);
		B_i : in STD_LOGIC_VECTOR (31 downto 0);
		IR1_i : in STD_LOGIC_VECTOR (31 downto 0);
		SetNewPC_o : out STD_LOGIC;
		NewPC_o : out STD_LOGIC_VECTOR (31 downto 0);
		C_o : out STD_LOGIC_VECTOR (31 downto 0);
		MAR_o : out STD_LOGIC_VECTOR (31 downto 0);
		SDR_o : out STD_LOGIC_VECTOR (31 downto 0);
		IR2_o : out STD_LOGIC_VECTOR (31 downto 0)
	);
end EXE_Stage;

architecture Behavioral of EXE_Stage is

	component ALU
		Port (
			ALUop_i : in STD_LOGIC_VECTOR (4 downto 0);
			x_i : in STD_LOGIC_VECTOR (31 downto 0);
			y_i : in STD_LOGIC_VECTOR (31 downto 0);
			z_o : out STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;
	
	signal format : STD_LOGIC;
	signal opcode : STD_LOGIC_VECTOR (5 downto 0);
	signal ALUop : STD_LOGIC_VECTOR (4 downto 0);
	signal sign_extension : STD_LOGIC_VECTOR (31 downto 0);
	signal EPC : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal x : STD_LOGIC_VECTOR (31 downto 0);
	signal y : STD_LOGIC_VECTOR (31 downto 0);
	signal z : STD_LOGIC_VECTOR (31 downto 0);
	
	signal SetNewPC : STD_LOGIC;
	signal NewPC : STD_LOGIC_VECTOR (31 downto 0);
	signal C : STD_LOGIC_VECTOR (31 downto 0);
	signal MAR : STD_LOGIC_VECTOR (31 downto 0);
	signal SDR : STD_LOGIC_VECTOR (31 downto 0);
	signal IR2 : STD_LOGIC_VECTOR (31 downto 0);

begin

	SetNewPC_o <= SetNewPC;
	NewPC_o <= NewPC;
	C_o <= C;
	MAR_o <= MAR;
	SDR_o <= SDR;
	IR2_o <= IR2;
	
	-- FORMAT
	format <= IR1_i(31) and IR1_i(30);
	
	-- OPCODE
	opcode <= IR1_i(31 downto 26);
	
	-- SET NEW PC
	process (opcode, B_i)
	begin
		if ((opcode = "100011" and B_i = 0) or (opcode = "100111" and B_i = 1) or (opcode = "101100") or (opcode = "101101") or (opcode = "101111")) then -- BNE, BEQ, J, CALL, RFE
			SetNewPC <= '1';
		else
			SetNewPC <= '0';
		end if;
	end process;
	
	-- ALUop
	process (IR1_i(31 downto 26), IR1_i(0), opcode)
	begin
		case opcode is
			when "100000"|"100001"|"100011"|"100100"|"100101"|"100110"|"100111"|"101000"|"101001"|"101010"|"101100"|"101101"|"101110" => -- LOAD, STORE, BNE, BEQ, J, CALL, TRAP
				ALUop <= "00010"; -- ADDU;
			when others =>
				ALUop(4) <= ((not IR1_i(31)) and IR1_i(30)) or (IR1_i(31) and IR1_i(30) and IR1_i(0));
				ALUop(3 downto 0) <= IR1_i(29 downto 26);
			end case;
	end process;
	
	-- SIGN EXTENSION
	process (format, opcode, IR1_i(15 downto 0))
	begin
		if (format = '0') then
			case opcode is
				when "000010"|"000011"|"001100"|"001101" => -- ADDUI, SUBUI, SLTUI, SGTUI
					sign_extension <= X"0000" & IR1_i(15 downto 0);
				when others =>
					sign_extension(31 downto 16) <= (others => IR1_i(15));
					sign_extension(15 downto 0) <= IR1_i(15 downto 0);
			end case;
		else
			sign_extension <= X"0000" & IR1_i(15 downto 0);
		end if;
	end process;
	
	-- EPC
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (rst_i = '1') then
				EPC <= (others => '0');
			elsif (ce_i = '1') then
				if (opcode = "110110") then -- MOVRE
					EPC <= A_i;
				elsif (opcode = "101110") then -- TRAP
					EPC <= PC2_i + 4;
				end if;
			end if;
		end if;
	end process;
	
	-- X
	process (opcode, PC2_i, sign_extension, A_i)
	begin
		case opcode is
			when "100011"|"100111" => -- BEQ, BNE
				x <= PC2_i + 4;
			when "101110" => -- TRAP
				x <= sign_extension(29 downto 0) & "00";
			when others =>
				x <= A_i;
		end case;
	end process;
	
	-- Y
	process (opcode, format, sign_extension, B_i)
	begin
		case opcode is
			when "101110" => -- TRAP
				y <= X"FFFFFF00"; -- INTERRUPT VECTOR BASE ADDRESS
			when others =>
				case format is
					when '0' =>
						y <= sign_extension;
					when '1' =>
						y <= B_i;
					when others =>
						y <= B_i;
				end case;
		end case;
	end process;
	
	-- ALU
	HIP_alu : ALU
	port map (
		ALUop_i => ALUop,
		x_i => x,
		y_i => y,
		z_o => z
	);
	
	-- NewPC
	process (opcode, EPC, z)
	begin
		case opcode is
			when "101111" => -- RFE
				NewPC <= EPC;
			when others =>
				NewPC <= z;
		end case;
	end process;
	
	-- C
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (rst_i = '1') then
				C <= (others => '0');
			elsif (ce_i = '1') then
				case opcode is
					when "101100"|"101101" => -- CALL, J
						C <= PC2_i + 4;
					when "110101" => -- MOVER
						C <= EPC;
					when others =>
						C <= z;
				end case;
			end if;
		end if;
	end process;
	
	-- MAR
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (rst_i = '1') then
				MAR <= (others => '0');
			elsif (ce_i = '1') then
				MAR <= z;
			end if;
		end if;
	end process;

	-- SDR
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (rst_i = '1') then
				SDR <= (others => '0');
			elsif (ce_i = '1') then
				SDR <= B_i;
			end if;
		end if;
	end process;
	
	-- IR2
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (rst_i = '1') then
				IR2 <= (others => '0');
			elsif (ce_i = '1') then
				IR2 <= IR1_i;
			end if;
		end if;
	end process;

end Behavioral;