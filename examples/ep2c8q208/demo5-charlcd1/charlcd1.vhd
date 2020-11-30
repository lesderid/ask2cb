library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity charlcd1 is
    Port ( clk : in std_logic;				 --24MHZ
           Reset : in std_logic;
           lcd_rs : out std_logic;
           lcd_rw : out std_logic;
		   lcd_e  : buffer std_logic;
		   data : out std_logic_vector(7 downto 0);
		 --  stateout: out std_logic_vector(10 downto 0);
		   clk_out: out std_logic);
end charlcd1;


architecture Behavioral of charlcd1 is

constant IDLE :         std_logic_vector(10 downto 0) :="00000000000";
constant CLEAR :        std_logic_vector(10 downto 0) :="00000000001";
constant RETURNCURSOR : std_logic_vector(10 downto 0) :="00000000010" ;
constant SETMODE      : std_logic_vector(10 downto 0) :="00000000100";
constant SWITCHMODE   : std_logic_vector(10 downto 0) :="00000001000";
constant SHIFT        : std_logic_vector(10 downto 0) :="00000010000";
constant SETFUNCTION  : std_logic_vector(10 downto 0) :="00000100000";
constant SETCGRAM     : std_logic_vector(10 downto 0) :="00001000000";
constant SETDDRAM     : std_logic_vector(10 downto 0) :="00010000000";
constant READFLAG     : std_logic_vector(10 downto 0) :="00100000000";
constant WRITERAM     : std_logic_vector(10 downto 0) :="01000000000";
constant READRAM      : std_logic_vector(10 downto 0) :="10000000000";




constant cur_inc      : std_logic :='1';
constant cur_dec      : std_logic :='0';
constant cur_shift    : std_logic :='1';
constant cur_noshift  : std_logic :='0';
constant open_display : std_logic :='1';
constant open_cur     : std_logic :='0';
constant blank_cur    : std_logic :='0';
constant shift_display : std_logic :='1';
constant shift_cur    : std_logic :='0';
constant right_shift  : std_logic :='1';
constant left_shift   : std_logic :='0';
constant datawidth8   : std_logic :='1';
constant datawidth4   : std_logic :='0';
constant twoline      : std_logic :='1';
constant oneline      : std_logic :='0';
constant font5x10     : std_logic :='1';
constant font5x7      : std_logic :='0';

signal state : std_logic_vector(10 downto 0);
signal counter : integer range 0 to 127;
signal div_counter : integer range 0 to 15;
signal flag        : std_logic;
constant DIVSS : integer :=15;

signal char_addr : std_logic_vector(5 downto 0);
signal data_in   : std_logic_vector(7 downto 0);
component char_ram
          port( address : in std_logic_vector(5 downto 0) ;
	             data    : out std_logic_vector(7 downto 0)
		         );
end component;


signal clk_int: std_logic;

signal clkcnt: std_logic_vector(18 downto 0);
constant divcnt: std_logic_vector(18 downto 0):="1111001110001000000";
signal clkdiv: std_logic;
signal tc_clkcnt: std_logic;
begin

process(clk,reset)
begin
  if(reset='0')then
  clkcnt<="0000000000000000000";
  elsif(clk'event and clk='1')then
     if(clkcnt=divcnt)then
     clkcnt<="0000000000000000000";
     else
     clkcnt<=clkcnt+1;
     end if;
  end if;
end process;
tc_clkcnt<='1' when clkcnt=divcnt else
           '0';

process(tc_clkcnt,reset)
begin
   if(reset='0')then
   clkdiv<='0';
   elsif(tc_clkcnt'event and tc_clkcnt='1')then
   clkdiv<=not clkdiv;
   end if;
end process;




clk_out<=clk_int;

process(clkdiv,reset)
begin
  if(reset='0')then
    clk_int<='0';
  elsif(clkdiv'event and clkdiv='1')then
    clk_int<= not clk_int;
  end if;
end process;

process(clkdiv,reset)
begin
   if(reset='0')then
     lcd_e<='0';
   elsif(clkdiv'event and clkdiv='0')then
     lcd_e<= not lcd_e;
   end if;
end process;

aa:char_ram
   port map( address=>char_addr,data=>data_in);

    lcd_rs <= '1' when state =WRITERAM or state = READRAM else '0';
	lcd_rw <= '0' when state =CLEAR or state = RETURNCURSOR or state=SETMODE or state=SWITCHMODE or state=SHIFT or state= SETFUNCTION or state=SETCGRAM or state =SETDDRAM or state =WRITERAM else
	          '1';
     data <="00000001" when state =CLEAR else
	         "00000010" when state =RETURNCURSOR else
			 "000001"& cur_inc & cur_noshift  when state = SETMODE else
			 "00001" & open_display &open_cur & blank_cur when state =SWITCHMODE else
			 "0001" & shift_display &left_shift &"00" when state = SHIFT else
			 "001" & datawidth8 & twoline &font5x10 & "00" when state=SETFUNCTION else
			 "01000000" when state =SETCGRAM else
			 "10000000" when state =SETDDRAM and counter =0 else
			 "11000000" when state =SETDDRAM and counter /=0 else
			  data_in when state = WRITERAM else
			 "ZZZZZZZZ";

   char_addr  <=conv_std_logic_vector( counter,6) when state =WRITERAM and counter<40 else
	            conv_std_logic_vector( counter-41+8,6) when state= WRITERAM and counter>40 and counter<81-8 else
			    conv_std_logic_vector( counter-81+8,6) when state= WRITERAM and counter>81-8 and counter<81 else
				"000000";
						
						
  
  process(clk_int,Reset)
  begin
      if(Reset='0')then 
		   state<=IDLE;
		   counter<=0;
		   flag<='0';
           div_counter<=0;
      elsif(clk_int'event and clk_int='1')then 
		   case state is
			when IDLE =>
			        if(flag='0')then 
						     state<=SETFUNCTION;
							 flag<='1';
							 counter<=0;
							 div_counter<=0;
                    else
						 if(div_counter<DIVSS )then
							 div_counter<=div_counter +1;
                             state<=IDLE;
                         else
							 div_counter<=0;
							 state <=SHIFT;
                         end if;
                    end if;
         when CLEAR    =>
			           state<=SETMODE;
         when SETMODE  =>
			           state<=WRITERAM;
         when RETURNCURSOR =>
			           state<=WRITERAM;
         when SWITCHMODE =>
			           state<=CLEAR;
         when SHIFT      =>
			           state<=IDLE;
         when SETFUNCTION =>
			           state<=SWITCHMODE;
         when SETCGRAM   =>
			           state<=IDLE;
         when SETDDRAM   =>
			           state<=WRITERAM;
         when READFLAG   =>
			           state<=IDLE;
         when WRITERAM   =>
			           if(counter =40)then 
						     state<=SETDDRAM;
							 counter<=counter+1;
                        elsif(counter/=40 and counter<81)then
						     state<=WRITERAM;
							 counter<=counter+1;
                        else
						    state<=SHIFT;
                    end if;
         when READRAM =>
			           state<=IDLE;
         when others  =>
			           state<=IDLE;
         end case;
    end if;
  end process;

  
end Behavioral;
