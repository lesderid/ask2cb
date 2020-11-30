library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY mlt1 IS
   PORT (
      a     : IN std_logic_vector(1 DOWNTO 0);   
      b     : IN std_logic_vector(1 DOWNTO 0);   
      c     : OUT std_logic_vector(7 DOWNTO 0));   
--      en    : OUT std_logic_vector(7 DOWNTO 0));   
END mlt1;

ARCHITECTURE arch OF mlt1 IS


   SIGNAL c_tmp    :  std_logic_vector(3 DOWNTO 0);   

BEGIN
--   en <= "00000000";
   c_tmp <=  a * b ;

   PROCESS(c_tmp)
   BEGIN
      CASE c_tmp IS
         WHEN "0000" =>
                  c <= "00000011";    
         WHEN "0001" =>
                  c <= "10011111";    
         WHEN "0010" =>
                  c <= "00100101";    
         WHEN "0011" =>
                  c <= "00001101";    
         WHEN "0100" =>
                  c <= "10011001";    
         WHEN "0101" =>
                  c <= "01001001";    
         WHEN "0110" =>
                  c <= "01000001";    
         WHEN "0111" =>
                  c <= "00011111";    
         WHEN "1000" =>
                  c <= "00000001";    
         WHEN "1001" =>
                  c <= "00011001";    
         WHEN "1010" =>
                  c <= "00010001";    
         WHEN "1011" =>
                  c <= "11000001";    
         WHEN "1100" =>
                  c <= "01100011";    
         WHEN "1101" =>
                  c <= "10000101";    
         WHEN "1110" =>
                  c <= "01100001";    
         WHEN "1111" =>
                  c <= "01110001";    
         WHEN OTHERS =>
                  NULL;
         
      END CASE;
   END PROCESS;

END arch;
