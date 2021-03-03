library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rw_96x8_sync is
  port (clock    : in  std_logic;
        data_in  : in  std_logic_vector(7 downto 0);
        write    : in  std_logic;
        address  : in  std_logic_vector(4 downto 0);
        data_out : out std_logic_vector(7 downto 0));
end entity;

architecture rw_96x8_sync_arch of rw_96x8_sync is

  type RW_type is array(0 to 95) of std_logic_vector(7 downto 0);

  signal RW : RW_type;

begin

  MEM : process (clock)
  begin
    if (rising_edge(clock)) then
      if (write = '1') then
        RW(to_integer(unsigned(address))) <= data_in;
      else
        data_out <= RW(to_integer(unsigned(address)));
      end if;
    end if;
  end process;

end architecture;
