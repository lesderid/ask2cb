--本实验。按下板上的八个拨码开关时，点亮相应的LED灯。
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity SWITCHLED1 is
PORT ( switch  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); 
       LED7      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end SWITCHLED1 ;
 
 ARCHITECTURE behav OF SWITCHLED1 IS 
 signal led_temp: std_logic_vector(7 downto 0);
 BEGIN
  PROCESS( switch ) 
  BEGIN 
  led_temp<= switch ;
  CASE  led_temp  IS 
   WHEN "11111110" =>  LED7 <= "11111110";    --  1
   WHEN "11111101" =>  LED7 <= "11111101";    --  2
   WHEN "11111011" =>  LED7 <= "11111011";    --  3
   WHEN "11110111" =>  LED7 <= "11110111";    --  4
   WHEN "11101111" =>  LED7 <= "11101111";    --  5
   WHEN "11011111" =>  LED7 <= "11011111";    --  6
   WHEN "10111111" =>  LED7 <= "10111111";    --  7
   WHEN "01111111" =>  LED7 <= "01111111";    --  8
   WHEN OTHERS =>  LED7 <= "11111111";
   --WHEN OTHERS =>  NULL ; 
   END CASE ; 
  END PROCESS ; 
 END behav; 
