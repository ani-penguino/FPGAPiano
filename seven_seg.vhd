library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity seven_seg is
    port ( CLK      : in std_logic;
           RST      : in std_logic;
           NOTE_IN  : in std_logic_vector(4 downto 0);
           SCAN_EN  : in std_logic; 
           DIGIT    : out std_logic_vector(3 downto 0);
           SEG      : out std_logic_vector(7 downto 0) 
         );
end seven_seg;

architecture Behavioral of seven_seg is
    signal  digit_now : std_logic_vector(3 downto 0);
    signal  point_now : std_logic;
    signal  seg_buf   : std_logic_vector(8 downto 0);  -- 4bits/ digit. 2 lower digits. + dot
    signal  cur_dig   : std_logic_vector(1 downto 0);
    signal  digit_en  : std_logic;
begin


   process (CLK,RST) begin
    if (RST = '1') then
        seg_buf <= "1010" & "1010" & '0';
    elsif (CLK'event and CLK = '1') then
       case NOTE_IN is 
        when "00000" => seg_buf <= "1010" & "1010" & '0'; -- AA
        when "00001" => seg_buf <= "1100" & "0011" & '0'; -- C3
        when "00010" => seg_buf <= "1100" & "0011" & '1'; -- C3#
        when "00011" => seg_buf <= "1101" & "0011" & '0'; -- D3
        when "00100" => seg_buf <= "1101" & "0011" & '1'; -- D3#
        when "00101" => seg_buf <= "1110" & "0011" & '0'; -- E3
        when "00110" => seg_buf <= "1111" & "0011" & '0'; -- F3
        when "00111" => seg_buf <= "1111" & "0011" & '1'; -- F3#
        when "01000" => seg_buf <= "0110" & "0011" & '0'; -- G3
        when "01001" => seg_buf <= "0110" & "0011" & '1'; -- G3#
        when "01010" => seg_buf <= "1010" & "0011" & '0'; -- A3
        when "01011" => seg_buf <= "1010" & "0011" & '1'; -- A3#
        when "01100" => seg_buf <= "1011" & "0011" & '0'; -- B3
        when "01101" => seg_buf <= "1100" & "0100" & '0'; -- B3# = C4
        when "10000" => seg_buf <= "1011" & "0011" & '0'; -- C4b = B3
        when "10001" => seg_buf <= "1100" & "0100" & '0'; -- C4
        when "10010" => seg_buf <= "1100" & "0100" & '1'; -- C4#
        when "10011" => seg_buf <= "1101" & "0100" & '0'; -- D4
        when "10100" => seg_buf <= "1101" & "0100" & '1'; -- D4#
        when "10101" => seg_buf <= "1110" & "0100" & '0'; -- E4
        when "10110" => seg_buf <= "1111" & "0100" & '0'; -- F4
        when "10111" => seg_buf <= "1111" & "0100" & '1'; -- F4#
        when "11000" => seg_buf <= "0110" & "0100" & '0'; -- G4
        when "11001" => seg_buf <= "0110" & "0100" & '1'; -- G4#
        when "11010" => seg_buf <= "1010" & "0100" & '0'; -- A4
        when "11011" => seg_buf <= "1010" & "0100" & '1'; -- A4#
        when "11100" => seg_buf <= "1011" & "0100" & '0'; -- B4
        when others  => seg_buf <= "1010" & "1010" & '1'; -- AA.
       end case;
    end if;
   end process;

    -- Current Digit being scanned out counter
    cnt_cur_dig : 
    process (CLK,RST) begin
        if (RST = '1') then
            cur_dig <= (others => '0');
        elsif (CLK'event and CLK = '1') then
           if (SCAN_EN = '1') then
                cur_dig <= cur_dig + 1;     
           end if;
        end if;
    end process;

    process (CLK,RST) begin
        if (RST = '1') then
            DIGIT <= "1111";
            digit_en <= '0';
            digit_now <= (others => '1');
            point_now <= '1';
        elsif (CLK'EVENT and CLK='1') then
            case cur_dig is
                when "00" => 
                    DIGIT <= "1110";
                    digit_en <= '1';
                    digit_now <= seg_buf(4 downto 1);
                    point_now <= not(seg_buf(0)); 
                when "01" => 
                    DIGIT <= "1101";
                    digit_en <= '1';
                    digit_now <= seg_buf(8 downto 5);
                    point_now <= '1';
                when "10" => 
                    DIGIT <= "1011";
                    digit_en <= '0';
                    digit_now <= (others => '1');
                    point_now <= '1';
                when others => 
                    DIGIT <= "0111";
                    digit_en <= '0';
                    digit_now <= (others => '1');
                    point_now <= '1';
            end case;
        end if;
    end process;

    -- Decoder of 7-segment
    process(digit_now,digit_en,point_now) begin
        if (digit_en = '1') then
            case digit_now is 
                when "0000" => seg <= "0000001" & point_now ; -- 0
                when "0001" => seg <= "1001111" & point_now ; -- 1
                when "0010" => seg <= "0010010" & point_now ; -- 2
                when "0011" => seg <= "0000110" & point_now ; -- 3
                when "0100" => seg <= "1001100" & point_now ; -- 4
                when "0101" => seg <= "0100100" & point_now ; -- 5
                when "0110" => seg <= "0100000" & point_now ; -- 6/G
                when "0111" => seg <= "0001111" & point_now ; -- 7
                when "1000" => seg <= "0000000" & point_now ; -- 8
                when "1001" => seg <= "0000100" & point_now ; -- 9
                when "1010" => seg <= "0001000" & point_now ; -- A
                when "1011" => seg <= "1100000" & point_now ; -- b
                when "1100" => seg <= "0110001" & point_now ; -- C
                when "1101" => seg <= "1000010" & point_now ; -- d
                when "1110" => seg <= "0110000" & point_now ; -- E
                when "1111" => seg <= "0111000" & point_now ; -- F
                when others => seg <= "1111111" & '0'       ; -- -
            end case ;
        else 
            seg <= "1111111" & '1';
        end if;
    end process;

end Behavioral;
