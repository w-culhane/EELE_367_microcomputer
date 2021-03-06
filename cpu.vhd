library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu is
  port (clock : in std_logic;
        reset : in std_logic;

        write       : out std_logic;
        address     : out std_logic_vector(7 downto 0);
        from_memory : in  std_logic_vector(7 downto 0);
        to_memory   : out std_logic_vector(7 downto 0));
end entity;

architecture cpu_arch of cpu is

  component data_path
    port (clock : in std_logic;
          reset : in std_logic;

          address     : out std_logic_vector(7 downto 0);
          from_memory : in  std_logic_vector(7 downto 0);
          to_memory   : out std_logic_vector(7 downto 0));
  end component;

begin
-- TODO
end architecture;
