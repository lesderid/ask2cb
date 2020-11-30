--本实验。按下板上的八个key时。数码管显示得到的数据。
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity KEYLED1 is
PORT ( key_data  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
       LED7      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end KEYLED1 ;
 
 ARCHITECTURE behav OF KEYLED1 IS 
 signal led_temp: std_logic_vector(4 downto 0);
 BEGIN
  PROCESS( key_data ) 
  BEGIN 
  led_temp<= key_data ;
  CASE  led_temp  IS 
   WHEN "11110" =>  LED7 <= "11111110";    --  1
   WHEN "11101" =>  LED7 <= "11111101";    --  2
   WHEN "11011" =>  LED7 <= "11111011";    --  3
   WHEN "10111" =>  LED7 <= "11110111";    --  4
   WHEN "01111" =>  LED7 <= "11101111";    --  5
   WHEN OTHERS =>  LED7 <= "11111111";
   --WHEN OTHERS =>  NULL ; 
   END CASE ; 
  END PROCESS ; 
 END behav; 