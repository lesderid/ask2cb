--本实验为LED流水灯实验。
LIBRARY IEEE;                                                  
USE IEEE.STD_LOGIC_1164.ALL;                     
USE IEEE.std_logic_unsigned.ALL;                   
ENTITY LampsSequencer is                                        
     PORT(
          clk:in STD_LOGIC;                                   
          led1:out STD_LOGIC_VECTOR(7 DOWNTO 0));     
END LampsSequencer; 
                                             
ARCHITECTURE light OF LampsSequencer IS            
SIGNAL clk1,CLK2:std_logic;                                       
BEGIN                                                                  
P1:PROCESS (clk)                                              
VARIABLE count:INTEGER RANGE  0 TO 999999;
BEGIN                                                                
    IF clk'EVENT AND clk='1' THEN                            --当时钟脉冲上升沿到来时执行下面语句
       IF count<=499999 THEN                           
          clk1<='0';                                          --当count<=499999时divls=0并且count加1
          count:=count+1;                          
        ELSIF count>=499999 AND count<=999999 THEN            --当ount>=499999 并且 count<=999998时
               clk1<='1';                                            --                             
               count:=count+1;                                --clk1=1并且count加1
        ELSE count:=0;                                        --当count>=499999时清零count1
        END IF;                                                      
     END IF;                                          
END PROCESS ;        
P3:PROCESS(CLK1)   
begin
   IF clk1'event AND clk1='1'THEN  
 clk2<=not clk2;
 END IF; 
END PROCESS P3;     
---------------------------------------------------------
P2:PROCESS(clk2)                                              
variable count1:INTEGER RANGE 0 TO 16;                         --定义的整型变量用做计数器
BEGIN                                                                --                                                 
IF clk2'event AND clk2='1'THEN                                 --当时钟脉冲上升沿到来时执行下面语句
   if count1<=16 then                                          --当COUNT1<=9时执行下面语句
      if count1=15 then                                        --当COUNT1=8时，COUNT1清零
         count1:=0;                                                 --
      end if;                                                            --
      CASE count1 IS                                             --CASE语句给输出LED1赋值
      WHEN 0=>led1<="11111110";                        --依次点亮发光二极管
      WHEN 1=>led1<="11111100";                        -- 
      WHEN 2=>led1<="11111000";                        --
      WHEN 3=>led1<="11110000";                        --
      WHEN 4=>led1<="11100000";                        --
      WHEN 5=>led1<="11000000";                        --
      WHEN 6=>led1<="10000000";                        --
      WHEN 7=>led1<="00000000"; 
      WHEN 8=>led1<= "01111111";                        --依次点亮发光二极管
      WHEN 9=>led1<= "00111111";                        -- 
      WHEN 10=>led1<="00011111";                        --
      WHEN 11=>led1<="00001111";                        --
      WHEN 12=>led1<="00000111";                        --
      WHEN 13=>led1<="00000011";                        --
      WHEN 14=>led1<="00000001";                        --
      WHEN 15=>led1<="00000000";                        --                       --
      WHEN OTHERS=>led1<="11111111";              
      END CASE;                                                     
      count1:=count1+1;                                   
    end if;                                                                     
end if;                                                                        
end process;                              
END light;