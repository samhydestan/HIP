----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:28:22 01/13/2020 
-- Design Name: 
-- Module Name:    HIP - Behavioral 
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

-- HIP processor top module --

entity HIP is
	Port (
		clk_i : in STD_LOGIC;
		rst_i : in STD_LOGIC;
		IFwait_i : in STD_LOGIC;
		MEMwait_i : in STD_LOGIC;
		IFdata_i : in STD_LOGIC_VECTOR (31 downto 0);
		MEMdata_i : in STD_LOGIC_VECTOR (31 downto 0);
		IFaddr_o : out STD_LOGIC_VECTOR (31 downto 0);
		MEMaddr_o : out STD_LOGIC_VECTOR (31 downto 0);
		MEMdata_o : out STD_LOGIC_VECTOR (31 downto 0);
		MemEn_o : out STD_LOGIC;	-- memory enable
		MemDir_o : out STD_LOGIC	-- memory direction: 0 - read, 1 - write
	);
end HIP;

architecture Behavioral of HIP is

	component IF_Stage
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
	end component;
	
	component ID_Stage
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
	end component;
	
	component EXE_Stage
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
	end component;
	
	component MEM_Stage
		Port (
			clk_i	: in STD_LOGIC;
			rst_i	: in STD_LOGIC;
			ce_i : in STD_LOGIC;
			memen_o : out STD_LOGIC;
			writeen_o : out STD_LOGIC;
         C_i : in STD_LOGIC_VECTOR (31 downto 0);
			MAR_i	: in STD_LOGIC_VECTOR (31 downto 0);
			SDR_i	: in STD_LOGIC_VECTOR (31 downto 0);
			IR2_i	: in STD_LOGIC_VECTOR (31 downto 0);
			C1_o : out STD_LOGIC_VECTOR (31 downto 0);
			MAR_o	: out STD_LOGIC_VECTOR (31 downto 0);
			Data_o : out STD_LOGIC_VECTOR (31 downto 0);
			IR3_o	: out STD_LOGIC_VECTOR (31 downto 0);
			Data_i : in STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;
	
	component WB_Stage is
		 Port ( --clk_i		: in  STD_LOGIC;
				  --rst_i		: in  STD_LOGIC;
				  --ce_i		: in  STD_LOGIC;
				  C1_i		: in  STD_LOGIC_VECTOR (31 downto 0);
				  IR3_i		: in  STD_LOGIC_VECTOR (31 downto 0);
				  CtoReg_o	: out STD_LOGIC_VECTOR (4 downto 0);
				  C1_o		: out STD_LOGIC_VECTOR (31 downto 0);
				  SetC1_o	: out STD_LOGIC
				 );
	end component;
	
	signal ce : STD_LOGIC;
	signal PCselect : STD_LOGIC_VECTOR (1 downto 0);
	signal NewPC : STD_LOGIC_VECTOR (31 downto 0);
	signal C1 : STD_LOGIC_VECTOR (31 downto 0);
	signal Cout : STD_LOGIC_VECTOR (31 downto 0);
	signal PC1 : STD_LOGIC_VECTOR (31 downto 0);
	signal IR : STD_LOGIC_VECTOR (31 downto 0);
	signal CtoReg : STD_LOGIC_VECTOR (4 downto 0);
	signal PC2 : STD_LOGIC_VECTOR (31 downto 0);
	signal A : STD_LOGIC_VECTOR (31 downto 0);
	signal B : STD_LOGIC_VECTOR (31 downto 0);
	signal IR1 : STD_LOGIC_VECTOR (31 downto 0);
	signal SetNewPC : STD_LOGIC;
	signal C : STD_LOGIC_VECTOR (31 downto 0);
	signal MAR : STD_LOGIC_VECTOR (31 downto 0);
	signal SDR : STD_LOGIC_VECTOR (31 downto 0);
	signal IR2 : STD_LOGIC_VECTOR (31 downto 0);
	signal IR3 : STD_LOGIC_VECTOR (31 downto 0);
	signal SetC1 : STD_LOGIC;
	
	signal IFaddr : STD_LOGIC_VECTOR (31 downto 0);
	signal MEMaddr : STD_LOGIC_VECTOR (31 downto 0);
	signal MEMdata : STD_LOGIC_VECTOR (31 downto 0);
	signal MemEn : STD_LOGIC;
	signal MemDir : STD_LOGIC;

begin

	IFaddr_o <= IFaddr;
	MEMaddr_o <= MEMaddr;
	MEMdata_o <= MEMdata;
	MemEn_o <= MemEn;
	MemDir_o <= MemDir;
	
	-- clock enable
	ce <= IFwait_i or MEMwait_i;
	
	-- PCselect
	process (SetC1, SetNewPC)
	begin
		if (SetC1 = '1') then -- TRAP
			PCselect <= "10";
		elsif (SetNewPC = '1') then -- BNE, BEQ, J, CALL, RFE
			PCselect <= "00";
		else
			PCselect <= "01";
		end if;
	end process;

	-- IF Stage
	IF_St: IF_Stage
	port map (
		clk_i => clk_i,
		rst_i => rst_i,
		ce_i => ce,
		PCselect_i => PCselect,
		NewPC_i => NewPC,
		C1_i => C1,
		Data_i => IFdata_i,
		Addr_o => IFaddr,
		PC1_o => PC1,
		IR_o => IR
	);

	-- ID Stage
	ID_St: ID_Stage
	port map (
		clk_i => clk_i,
		rst_i => rst_i,
		ce_i => ce,
		PC1_i => PC1,
		IR_i => IR,
		CtoReg_i => CtoReg,
		C1_i => Cout,
		PC2_o => PC2,
		A_o => A,
		B_o => B,
		IR1_o => IR1
	);
	
	-- EXE Stage
	EXE_St: EXE_Stage
	port map (
		clk_i => clk_i,
		rst_i => rst_i,
		ce_i => ce,
		PC2_i => PC2,
		A_i => A,
		B_i => B,
		IR1_i => IR1,
		SetNewPC_o => SetNewPC,
		NewPC_o => NewPC,
		C_o => C,
		MAR_o => MAR,
		SDR_o => SDR,
		IR2_o => IR2
	);
	
	-- MEM Stage
	MEM_St: MEM_Stage
	port map (
		clk_i => clk_i,
		rst_i => rst_i,
		ce_i => ce,
		memen_o => MemEn,
		writeen_o => MemDir,
		C_i => C,
		MAR_i => MAR,
		SDR_i => SDR,
		IR2_i => IR2,
		C1_o => C1,
		MAR_o => MEMaddr,
		Data_o => MEMdata,
		IR3_o => IR3,
		Data_i => MEMdata_i
	);
	
	-- WB Stage
	WB_St: WB_Stage
	port map (
		--clk_i => clk_i,
		--rst_i => rst_i,
		--ce_i => ce,
		C1_i => C1,
		IR3_i => IR3,
		CtoReg_o => CtoReg,
		C1_o => Cout,
		SetC1_o => SetC1
	);

end Behavioral;