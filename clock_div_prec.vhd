library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_div_prec is
  port (sel       : in  std_logic_vector(1 downto 0);
        reset     : in  std_logic;
        clock_in  : in  std_logic;
        clock_out : out std_logic);
end entity;

architecture clock_div_prec of clock_div_prec is

  signal clock_buf    : std_logic;
  signal CNT, CNT_max : integer;

begin

  clock_out <= clock_buf;

  CMAX : process (Sel)
  begin
    case (Sel) is
      when "00"   => CNT_max <= 24999;     -- 1 kHz
      when "01"   => CNT_max <= 249999;    -- 100 Hz
      when "10"   => CNT_max <= 2499999;   -- 10 Hz
      when "11"   => CNT_max <= 24999999;  -- 1 Hz
      when others => CNT_max <= 24999;     -- 1 kHz
    end case;
  end process;

  CLK : process (clock_in, reset)
  begin
    if (reset = '0') then
      clock_buf <= '0';
      CNT       <= 0;
    elsif (rising_edge(clock_in)) then
      if (CNT >= CNT_max) then
        clock_buf <= not clock_buf;
        CNT       <= 0;
      else
        CNT <= CNT + 1;
      end if;
    end if;
  end process;

end architecture;
