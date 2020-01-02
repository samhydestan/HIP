--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:36:06 12/27/2019
-- Design Name:   
-- Module Name:   C:/Users/gbert/Documents/Faks/3-letnik/1-semester/dn/seminar/HIP/IF_Stage_tb.vhd
-- Project Name:  HIP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IF_Stage
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
 
ENTITY IF_Stage_tb IS
END IF_Stage_tb;
 
ARCHITECTURE behavior OF IF_Stage_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IF_Stage
    PORT(
         clk_i : IN  std_logic;
         rst_i : IN  std_logic;
         ce_i : IN  std_logic;
         PCselect_i : IN  std_logic_vector(1 downto 0);
         newPC_i : IN  std_logic_vector(31 downto 0);
         C1_i : IN  std_logic_vector(31 downto 0);
         mem_i : IN  std_logic_vector(31 downto 0);
         mem_o : OUT  std_logic_vector(31 downto 0);
         PC1_o : OUT  std_logic_vector(31 downto 0);
         IR_o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal rst_i : std_logic := '0';
   signal ce_i : std_logic := '0';
   signal PCselect_i : std_logic_vector(1 downto 0) := (others => '0');
   signal newPC_i : std_logic_vector(31 downto 0) := (others => '0');
   signal C1_i : std_logic_vector(31 downto 0) := (others => '0');
   signal mem_i : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal mem_o : std_logic_vector(31 downto 0);
   signal PC1_o : std_logic_vector(31 downto 0);
   signal IR_o : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IF_Stage PORT MAP (
          clk_i => clk_i,
          rst_i => rst_i,
          ce_i => ce_i,
          PCselect_i => PCselect_i,
          newPC_i => newPC_i,
          C1_i => C1_i,
          mem_i => mem_i,
          mem_o => mem_o,
          PC1_o => PC1_o,
          IR_o => IR_o
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
		PCselect_i <= "01";

      wait;
   end process;

END;
