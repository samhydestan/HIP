--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:14:51 12/27/2019
-- Design Name:   
-- Module Name:   C:/Users/gbert/Documents/Faks/3-letnik/1-semester/dn/seminar/HIP/ID_Stage_tb.vhd
-- Project Name:  HIP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ID_Stage
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
 
ENTITY ID_Stage_tb IS
END ID_Stage_tb;
 
ARCHITECTURE behavior OF ID_Stage_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ID_Stage
    PORT(
         clk_i : IN  std_logic;
         rst_i : IN  std_logic;
         ce_i : IN  std_logic;
         PC1_i : IN  std_logic_vector(31 downto 0);
         IR_i : IN  std_logic_vector(31 downto 0);
         CtoReg_i : IN  std_logic_vector(4 downto 0);
         C1_i : IN  std_logic_vector(31 downto 0);
         PC2_o : OUT  std_logic_vector(31 downto 0);
         A_o : OUT  std_logic_vector(31 downto 0);
         B_o : OUT  std_logic_vector(31 downto 0);
         IR1_o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal rst_i : std_logic := '0';
   signal ce_i : std_logic := '0';
   signal PC1_i : std_logic_vector(31 downto 0) := (others => '0');
   signal IR_i : std_logic_vector(31 downto 0) := (others => '0');
   signal CtoReg_i : std_logic_vector(4 downto 0) := (others => '0');
   signal C1_i : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal PC2_o : std_logic_vector(31 downto 0);
   signal A_o : std_logic_vector(31 downto 0);
   signal B_o : std_logic_vector(31 downto 0);
   signal IR1_o : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ID_Stage PORT MAP (
          clk_i => clk_i,
          rst_i => rst_i,
          ce_i => ce_i,
          PC1_i => PC1_i,
          IR_i => IR_i,
          CtoReg_i => CtoReg_i,
          C1_i => C1_i,
          PC2_o => PC2_o,
          A_o => A_o,
          B_o => B_o,
          IR1_o => IR1_o
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
		PC1_i <= (others => '0');
		CtoReg_i <= (others => '1');
		C1_i <= (others => '1');
		IR_i <= "00000000000111110000000000000000";
		
		wait for 10 ns;
		C1_i <= (others => '0');
		
		wait for 10 ns;
		C1_i <= (others => '1');
		
		wait for 10 ns;
		C1_i <= (others => '0');
		
		wait for 10 ns;
		C1_i <= (others => '1');

      wait;
   end process;

END;
