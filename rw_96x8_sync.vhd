library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RW_96x8_sync is
  port (clock    : in  std_logic;
        data_in  : in  std_logic_vector(7 downto 0);
        write    : in  std_logic;
        address  : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0));
end entity;

architecture RW_96x8_sync_arch of RW_96x8_sync is

  type RW_type is array(128 to 223) of std_logic_vector(7 downto 0);

  signal EN : std_logic;
  signal RW : RW_type := (others => x"00");

begin

  -- Verify requested address is valid before fetch
  ENABLE : process (address)
  begin
    if (to_integer(unsigned(address)) >= 128
        and to_integer(unsigned(address)) <= 223) then
      EN <= '1';
    else
      EN <= '0';
    end if;
  end process;

  MEM : process (clock)
  begin
    if (EN = '1' and rising_edge(clock)) then
      if (write = '1') then
        RW(to_integer(unsigned(address))) <= data_in;
      else
        data_out <= RW(to_integer(unsigned(address)));
      end if;
    end if;
  end process;

end architecture;
