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

          IR                 : out std_logic_vector(7 downto 0);
          IR_load, MAR_load  : in  std_logic;
          PC_load, PC_inc    : in  std_logic;
          A_load, B_load     : in  std_logic;
          CCR_load           : in  std_logic;
          CCR_result         : out std_logic_vector(3 downto 0);
          bus1_sel, bus2_sel : in  std_logic_vector(1 downto 0);

          address     : out std_logic_vector(7 downto 0);
          from_memory : in  std_logic_vector(7 downto 0);
          to_memory   : out std_logic_vector(7 downto 0));
  end component;

  component control_unit
    port (clock : in std_logic;
          reset : in std_logic;

          IR                : in  std_logic_vector(7 downto 0);
          IR_load, MAR_load : out std_logic;
          PC_load, PC_inc   : out std_logic;
          A_load, B_load    : out std_logic;

          ALU_sel            : out std_logic_vector(2 downto 0);
          CCR_result         : in  std_logic_vector (3 downto 0);
          CCR_load           : out std_logic;
          bus1_sel, bus2_sel : out std_logic_vector(1 downto 0);

          write : out std_logic);
  end component;

  signal bus1_sel, bus2_sel : std_logic_vector(1 downto 0);

  signal IR, MAR, PC, A, B : std_logic_vector(7 downto 0);

  signal IR_load, MAR_load : std_logic;
  signal PC_load, PC_inc   : std_logic;
  signal PC_uns            : unsigned(7 downto 0);
  signal A_load, B_load    : std_logic;
  signal CCR_load          : std_logic;
  signal NZVC, CCR_result  : std_logic_vector(3 downto 0);
  signal ALU_sel           : std_logic_vector(2 downto 0);
  signal ALU_result        : std_logic_vector(7 downto 0);

begin

  CU : control_unit port map (clock, reset, IR, IR_load, MAR_load,
                              PC_load, PC_inc, A_load, B_load,
                              ALU_sel, CCR_result, CCR_load,
                              bus1_sel, bus2_sel, write);

  DP : data_path port map (clock, reset,
                           IR, IR_load, MAR_load,
                           PC_load, PC_inc,
                           A_load, B_load,
                           CCR_load, CCR_result,
                           bus1_sel, bus2_sel,
                           address, from_memory, to_memory);

end architecture;
