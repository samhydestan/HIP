--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:22:03 01/05/2020
-- Design Name:   
-- Module Name:   C:/Users/gbert/Documents/Faks/3-letnik/1-semester/dn/seminar/HIP_Project/HIP/EXE_Stage_tb.vhd
-- Project Name:  HIP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EXE_Stage
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY EXE_Stage_tb IS
END EXE_Stage_tb;
 
ARCHITECTURE behavior OF EXE_Stage_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EXE_Stage
    PORT(
         clk_i : IN  std_logic;
         rst_i : IN  std_logic;
         ce_i : IN  std_logic;
         PC2_i : IN  std_logic_vector(31 downto 0);
         A_i : IN  std_logic_vector(31 downto 0);
         B_i : IN  std_logic_vector(31 downto 0);
         IR1_i : IN  std_logic_vector(31 downto 0);
         BZero_o : OUT  std_logic;
         NewPC_o : OUT  std_logic_vector(31 downto 0);
         C_o : OUT  std_logic_vector(31 downto 0);
         MAR_o : OUT  std_logic_vector(31 downto 0);
         SDR_o : OUT  std_logic_vector(31 downto 0);
         IR2_o : OUT  std_logic_vector(31 downto 0);
         ALUop_o : OUT  std_logic_vector(4 downto 0);
			sign_extension_o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal rst_i : std_logic := '0';
   signal ce_i : std_logic := '0';
   signal PC2_i : std_logic_vector(31 downto 0) := (others => '0');
   signal A_i : std_logic_vector(31 downto 0) := (others => '0');
   signal B_i : std_logic_vector(31 downto 0) := (others => '0');
   signal IR1_i : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal BZero_o : std_logic;
   signal NewPC_o : std_logic_vector(31 downto 0);
   signal C_o : std_logic_vector(31 downto 0);
   signal MAR_o : std_logic_vector(31 downto 0);
   signal SDR_o : std_logic_vector(31 downto 0);
   signal IR2_o : std_logic_vector(31 downto 0);
   signal ALUop_o : std_logic_vector(4 downto 0);
	signal sign_extension_o : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EXE_Stage PORT MAP (
          clk_i => clk_i,
          rst_i => rst_i,
          ce_i => ce_i,
          PC2_i => PC2_i,
          A_i => A_i,
          B_i => B_i,
          IR1_i => IR1_i,
          BZero_o => BZero_o,
          NewPC_o => NewPC_o,
          C_o => C_o,
          MAR_o => MAR_o,
          SDR_o => SDR_o,
          IR2_o => IR2_o,
          ALUop_o => ALUop_o,
			 sign_extension_o => sign_extension_o
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst_i <= '1';
      wait for 100 ns;	
		rst_i <= '0';

      ce_i <= '1';
		
		A_i <= "10000000000000000000000000001110";
		-- A_i <= "11111111111111111111111111111111";
		B_i <= "00000000000000000000000000001110";
		-- B_i <= "11111111111111111111111111111111";
		IR1_i <= "11111000000000000000000000000000";

      wait;
   end process;

END;
