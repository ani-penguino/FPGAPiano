library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;

-- Note Generator
--      This is a lookup table of the different note values.

entity note_gen is 
    port (
          CLK       : in  std_logic;
          RST       : in  std_logic;
          NOTE_IN   : in  std_logic_vector(4 downto 0);
          DIV       : out std_logic_vector(15 downto 0)
         );
end note_gen;

architecture Behavioral of note_gen is
    signal next_div : std_logic_vector(15 downto 0);
begin
    
    -- Latch Output of DIV
    process (CLK,RST) begin
        if (RST = '1') then
            DIV <= x"0000";
        elsif (CLK'event and CLK='1') then
            DIV <= next_div;
        end if;  
    end process;

   -- Lookup Table
   process (NOTE_IN) begin
   case NOTE_IN is 
    when "00000" => next_div <= x"0000";
    when "00001" => next_div <= x"0EEE"; -- C3
    when "00010" => next_div <= x"0E18"; -- C3#
    when "00011" => next_div <= x"0D4E"; -- D3
    when "00100" => next_div <= x"0C8E"; -- D3#
    when "00101" => next_div <= x"0BDA"; -- E3
    when "00110" => next_div <= x"0B30"; -- F3
    when "00111" => next_div <= x"0A8E"; -- F3#
    when "01000" => next_div <= x"09F7"; -- G3
    when "01001" => next_div <= x"0968"; -- G3#
    when "01010" => next_div <= x"08E1"; -- A3
    when "01011" => next_div <= x"0861"; -- A3#
    when "01100" => next_div <= x"07E9"; -- B3
    when "01101" => next_div <= x"0777"; -- B3# = C4
    when "10000" => next_div <= x"07E9"; -- C4b = B3
    when "10001" => next_div <= x"0777"; -- C4
    when "10010" => next_div <= x"070C"; -- C4#
    when "10011" => next_div <= x"06A7"; -- D4
    when "10100" => next_div <= x"0647"; -- D4#
    when "10101" => next_div <= x"05ED"; -- E4
    when "10110" => next_div <= x"0598"; -- F4
    when "10111" => next_div <= x"0547"; -- F4#
    when "11000" => next_div <= x"04FB"; -- G4
    when "11001" => next_div <= x"04B4"; -- G4#
    when "11010" => next_div <= x"0470"; -- A4
    when "11011" => next_div <= x"0431"; -- A4#
    when "11100" => next_div <= x"03F4"; -- B4
    when others => next_div <= x"0000";
   end case;
   end process;
 
end Behavioral;
