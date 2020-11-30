library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY mux IS
   PORT (
      a                       : IN std_logic;   
      b                       : IN std_logic_vector(1 DOWNTO 0);   
      c                       : IN std_logic_vector(1 DOWNTO 0);   
      d                       : OUT std_logic_vector(7 DOWNTO 0);   
      en                      : OUT std_logic_vector(7 DOWNTO 0));   
END mux;

ARCHITECTURE arch OF mux IS

   SIGNAL d_tmp                    :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL temp_xhd               :  std_logic_vector(1 DOWNTO 0);   
BEGIN
   en <= "00000000" ;
   temp_xhd <= b WHEN a = '1' ELSE c;
   d_tmp <= "0" & temp_xhd ;

   PROCESS(d_tmp)
   BEGIN
      CASE d_tmp IS
         WHEN "000" =>
                  d <= "00000011";    
         WHEN "001" =>
                  d <= "10011111";    
         WHEN "010" =>
                  d <= "00100101";    
         WHEN "011" =>
                  d <= "00001101";    
         WHEN "100" =>
                  d <= "10011001";    
         WHEN "101" =>
                  d <= "01001001";    
         WHEN "110" =>
                  d <= "01000001";    
         WHEN "111" =>
                  d <= "00011111";
         WHEN OTHERS =>
                  NULL;
         
      END CASE;
   END PROCESS;

END arch;
