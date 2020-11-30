library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY seg2 IS
   PORT (
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      dataout                 : OUT std_logic_vector(7 DOWNTO 0);   --各段数据输出  
      en                      : OUT std_logic_vector(7 DOWNTO 0));  --COM使能输出 
END seg2;

ARCHITECTURE arch OF seg2 IS

signal cnt_scan : std_logic_vector(15 downto 0 );
signal data4 :    std_logic_vector(3 downto 0);
signal dataout_xhdl1 : std_logic_vector(7 downto 0);
signal en_xhdl : std_logic_vector(7 downto 0);
begin
  dataout<=dataout_xhdl1;
  en<=en_xhdl;
 process(clk,rst)
 begin
   if(rst='0')then 
   cnt_scan<="0000000000000000";
   elsif(clk'event and clk='1')then
   cnt_scan<=cnt_scan+1;
   end if;
 end process;
 
 process(cnt_scan(15 downto 13))
 begin
 case cnt_scan(15 downto 13) is
     when"000"=> en_xhdl<="11111110";
     when"001"=> en_xhdl<="11111101";
     when"010"=> en_xhdl<="11111011";
     when"011"=> en_xhdl<="11110111";
     when"100"=> en_xhdl<="11101111";
     when"101"=> en_xhdl<="11011111";
     when"110"=> en_xhdl<="10111111";
     when"111"=> en_xhdl<="01111111";
     when others=> en_xhdl<="11111110";
  end case;

 end process;

process(en_xhdl)
begin
 case en_xhdl is
   when "11111110"=> data4<="0000";
   when "11111101"=> data4<="0001";
   when "11111011"=> data4<="0010";
   when "11110111"=> data4<="0011";
   when "11101111"=> data4<="0100";
   when "11011111"=> data4<="0101";
   when "10111111"=> data4<="0110";
   when "01111111"=> data4<="0111";
   when others => data4<="1000";
  end case;
end process;

process(data4)
begin
  case data4 is
         WHEN "0000" =>
                  dataout_xhdl1 <= "11000000";    
         WHEN "0001" =>
                  dataout_xhdl1 <= "11111001";    
         WHEN "0010" =>
                  dataout_xhdl1 <= "10100100";    
         WHEN "0011" =>
                  dataout_xhdl1 <= "10110000";    
         WHEN "0100" =>
                  dataout_xhdl1 <= "10011001";    
         WHEN "0101" =>
                  dataout_xhdl1 <= "10010010";    
         WHEN "0110" =>
                  dataout_xhdl1 <= "10000010";    
         WHEN "0111" =>
                  dataout_xhdl1 <= "11111000";    
         WHEN "1000" =>
                  dataout_xhdl1 <= "10000000";    
         WHEN "1001" =>
                  dataout_xhdl1 <= "00011001";    
         WHEN "1010" =>
                  dataout_xhdl1 <= "00010001";    
         WHEN "1011" =>
                  dataout_xhdl1 <= "11000001";    
         WHEN "1100" =>
                  dataout_xhdl1 <= "01100011";    
         WHEN "1101" =>
                  dataout_xhdl1 <= "10000101";    
         WHEN "1110" =>
                  dataout_xhdl1 <= "01100001";    
         WHEN "1111" =>
                  dataout_xhdl1 <= "01110001";    
         WHEN OTHERS =>
               dataout_xhdl1 <= "00000011"; 
         
      END CASE;
   END PROCESS;
   
end arch;