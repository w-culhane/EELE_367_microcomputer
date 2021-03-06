library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom_128x8_sync is
  port (clock    : in  std_logic;
        address  : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0));
end entity;

architecture rom_128x8_sync_arch of rom_128x8_sync is

  type ROM_type is array(0 to 127) of std_logic_vector(7 downto 0);

  constant ROM : ROM_type := (0      => "00000000",
                              1      => "00000000",
                              2      => "00000000",
                              others => "00000000");

begin

  MEMFETCH : process (clock)
  begin
    if (rising_edge(clock)) then
      data_out <= ROM(to_integer(unsigned(address)));
    end if;
  end process;

end architecture;
