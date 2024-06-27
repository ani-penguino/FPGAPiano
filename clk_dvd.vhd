library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;

-- Clock Divider
--      Will create a 50% duty cycle clock
--      Set DIV to the integer number of half periods
--      to divide by. 
--
--      DIV = (CLK / FREQ) * 0.5
--
--      Example: To create a 1MHz clock from a 50MHz clock
--          DIV should be (50 / 1) * 0.5 = 25
--
--  Limits: 
--      DIV=N ->      F = 50 MHz / 2 * N
--      DIV=1 ->      F = 25 MHz
--      DIV=2^16-1 -> F = 381.4755 Hz
--      DIV=2^16-2 -> F = 381.4813
--

entity clk_dvd is 
    port (
          CLK     : in std_logic;
          RST     : in std_logic;
          DIV     : in std_logic_vector(15 downto 0);
          EN      : in std_logic;
          CLK_OUT : out std_logic;
          ONE_SHOT: out std_logic
         );
end clk_dvd;

architecture Behavioral of clk_dvd is
    signal count    : std_logic_vector(15 downto 0);
    signal trigger  : std_logic;
    signal clk_cur  : std_logic;
    signal toggle   : std_logic;
begin

CLK_OUT <= clk_cur;

-- Set ONE_SHOT every two toggles, since it 
--  is toggling on half_periods
toggle_trigger:
process (CLK,RST) begin
    if (RST = '1') then
        ONE_SHOT <= '0';
    elsif (CLK'event and CLK = '1') then
        if (trigger = '1' and toggle = '1') then
           ONE_SHOT <= '1'; 
           toggle   <= '0';
        elsif (trigger = '1') then
           ONE_SHOT <= '0';
           toggle   <= '1';
        else 
           ONE_SHOT <= '0';
        end if;
    end if;
end process;

counter:
process (CLK,RST) begin
    if (RST = '1') then
        -- Start with one since trigger is high for cycle DIV+1
        count    <= x"0001";
        trigger  <= '0';
    elsif (CLK'event and CLK = '1') then
        if (count = DIV) then
            count   <= x"0001";
            trigger <= '1';
        elsif (EN = '1') then 
            count   <= count + 1;
            trigger <= '0';
        else
            trigger <= '0';
        end if;
    end if;
end process;

output:
process (CLK,RST) begin
    if (RST = '1') then
        clk_cur <= '0';
    elsif (CLK'event and CLK = '1') then
        if (trigger = '1') then
           clk_cur <= not(clk_cur); 
        end if;
    end if;
end process;

end Behavioral;
