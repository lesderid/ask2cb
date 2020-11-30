library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity char_ram is
port( address : in std_logic_vector(5 downto 0) ;
		data    : out std_logic_vector(7 downto 0)
		);
end char_ram;

architecture fun of char_ram is

function char_to_integer ( indata :character) return integer is
variable result : integer range 0 to 16#7F#;
begin
	case indata is
	when ' ' =>		result := 32;
	when '!' =>		result := 33;
	when '"' =>		result := 34;
	when '#' =>		result := 35;
	when '$' =>		result := 36;
	when '%' =>		result := 37;
	when '&' =>		result := 38;
	when ''' =>		result := 39;
	when '(' =>		result := 40;
	when ')' =>		result := 41;
	when '*' =>		result := 42;
	when '+' =>		result := 43;
	when ',' =>		result := 44;
	when '-' =>		result := 45;
	when '.' =>		result := 46;
	when '/' =>		result := 47;
	when '0' =>		result := 48;
	when '1' =>		result := 49;
	when '2' =>		result := 50;
	when '3' =>		result := 51;
	when '4' =>		result := 52;
	when '5' =>		result := 53;
	when '6' =>		result := 54;
	when '7' =>		result := 55;
	when '8' =>		result := 56;
	when '9' =>		result := 57;
	when ':' =>		result := 58;
	when ';' =>		result := 59;
	when '<' =>		result := 60;
	when '=' =>		result := 61;
	when '>' =>		result := 62;
	when '?' =>		result := 63;
	when '@' =>		result := 64;
	when 'A' =>		result := 65;
	when 'B' =>		result := 66;
	when 'C' =>		result := 67;
	when 'D' =>		result := 68;
	when 'E' =>		result := 69;
	when 'F' =>		result := 70;
	when 'G' =>		result := 71;
	when 'H' =>		result := 72;
	when 'I' =>		result := 73;
	when 'J' =>		result := 74;
	when 'K' =>		result := 75;
	when 'L' =>		result := 76;
	when 'M' =>		result := 77;
	when 'N' =>		result := 78;
	when 'O' =>		result := 79;
	when 'P' =>		result := 80;
	when 'Q' =>		result := 81;
	when 'R' =>		result := 82;
	when 'S' =>		result := 83;
	when 'T' =>		result := 84;
	when 'U' =>		result := 85;
	when 'V' =>		result := 86;
	when 'W' =>		result := 87;
	when 'X' =>		result := 88;
	when 'Y' =>		result := 89;
	when 'Z' =>		result := 90;
	when '[' =>		result := 91;
	when '\' =>		result := 92;
	when ']' =>		result := 93;
	when '^' =>		result := 94;
	when '_' =>		result := 95;
	when '`' =>		result := 96;
	when 'a' =>		result := 97;
	when 'b' =>		result := 98;
	when 'c' =>		result := 99;
	when 'd' =>		result := 100;
	when 'e' =>		result := 101;
	when 'f' =>		result := 102;
	when 'g' =>		result := 103;
	when 'h' =>		result := 104;
	when 'i' =>		result := 105;
	when 'j' =>		result := 106;
	when 'k' =>		result := 107;
	when 'l' =>		result := 108;
	when 'm' =>		result := 109;
	when 'n' =>		result := 110;
	when 'o' =>		result := 111;
	when 'p' =>		result := 112;
	when 'q' =>		result := 113;
	when 'r' =>		result := 114;
	when 's' =>		result := 115;
	when 't' =>		result := 116;
	when 'u' =>		result := 117;
	when 'v' =>		result := 118;
	when 'w' =>		result := 119;
	when 'x' =>		result := 120;
	when 'y' =>		result := 121;
	when 'z' =>		result := 122;
	when '{' =>		result := 123;
	when '|' =>		result := 124;
	when '}' =>		result := 125;
	when '~' =>		result := 126;
	when	others => result :=32;
	end case;
	return result;
end function;

begin 
process (address)
begin
	case address is
	when "000000" =>data<=conv_std_logic_vector(char_to_integer ('W') ,8);
	when "000001" =>data<=conv_std_logic_vector(char_to_integer ('e') ,8);
	when "000010" =>data<=conv_std_logic_vector(char_to_integer ('l') ,8);
	when "000011" =>data<=conv_std_logic_vector(char_to_integer ('e') ,8);
	when "000100" =>data<=conv_std_logic_vector(char_to_integer ('c') ,8);
	when "000101" =>data<=conv_std_logic_vector(char_to_integer ('o') ,8);
	when "000110" =>data<=conv_std_logic_vector(char_to_integer ('m') ,8);
	when "000111" =>data<=conv_std_logic_vector(char_to_integer ('e') ,8);
	when "001000" =>data<=conv_std_logic_vector(char_to_integer (' ') ,8);
	when "001001" =>data<=conv_std_logic_vector(char_to_integer (' ') ,8);
	when "001010" =>data<=conv_std_logic_vector(char_to_integer ('B') ,8);
	when "001011" =>data<=conv_std_logic_vector(char_to_integer ('A') ,8);
	when "001100" =>data<=conv_std_logic_vector(char_to_integer ('I') ,8);
	when "001101" =>data<=conv_std_logic_vector(char_to_integer ('X') ,8);
	when "001110" =>data<=conv_std_logic_vector(char_to_integer ('U') ,8);
	when "001111" =>data<=conv_std_logic_vector(char_to_integer ('N') ,8);
	when "010000" =>data<=conv_std_logic_vector(char_to_integer (' ') ,8);
	when "010001" =>data<=conv_std_logic_vector(char_to_integer (' ') ,8);
	when "010010" =>data<=conv_std_logic_vector(char_to_integer ('B') ,8);
	when "010011" =>data<=conv_std_logic_vector(char_to_integer ('o') ,8);
	when "010100" =>data<=conv_std_logic_vector(char_to_integer ('a') ,8);
	when "010101" =>data<=conv_std_logic_vector(char_to_integer ('r') ,8);
	when "010110" =>data<=conv_std_logic_vector(char_to_integer ('d') ,8);
	when "010111" =>data<=conv_std_logic_vector(char_to_integer ('!') ,8);
	when others   =>data<=conv_std_logic_vector(char_to_integer (' ') ,8);
	end case;
end process;
end fun;

