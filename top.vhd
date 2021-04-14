library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
  port (CLOCK_50 : in  std_logic;
        KEY      : in  std_logic_vector(1 downto 0);
        SW       : in  std_logic_vector(9 downto 0);
        LEDR     : out std_logic_vector(7 downto 0);
        HEX0     : out std_logic_vector(6 downto 0);
        HEX1     : out std_logic_vector(6 downto 0);
        HEX2     : out std_logic_vector(6 downto 0);
        HEX3     : out std_logic_vector(6 downto 0);
        HEX4     : out std_logic_vector(6 downto 0);
        HEX5     : out std_logic_vector(6 downto 0);
        GPIO     : out std_logic_vector(15 downto 0));
end entity;

architecture top_arch of top is

  component char_decoder
    port (BIN_IN  : in  std_logic_vector(3 downto 0);
          HEX_OUT : out std_logic_vector(6 downto 0));
  end component;

  component clock_div_prec
    port (reset     : in  std_logic;
          sel       : in  std_logic_vector(1 downto 0);
          clock_in  : in  std_logic;
          clock_out : out std_logic);
  end component;

  component computer
    port (clock : in std_logic;
          reset : in std_logic;

          port_in_00, port_in_01, port_in_02, port_in_03,
          port_in_04, port_in_05, port_in_06, port_in_07,
          port_in_08, port_in_09, port_in_10, port_in_11,
          port_in_12, port_in_13, port_in_14, port_in_15
          : in std_logic_vector(7 downto 0);

          port_out_00, port_out_01, port_out_02, port_out_03,
          port_out_04, port_out_05, port_out_06, port_out_07,
          port_out_08, port_out_09, port_out_10, port_out_11,
          port_out_12, port_out_13, port_out_14, port_out_15
          : out std_logic_vector(7 downto 0));
  end component;

  signal reset     : std_logic;
  signal clock_div : std_logic;

  signal POUT0, POUT1, POUT2, POUT3,
    POUT4, POUT5, POUT6, POUT7,
    POUT8, POUT9, POUT10, POUT11,
    POUT12, POUT13, POUT14, POUT15
    : std_logic_vector(7 downto 0);

begin

  reset <= KEY(0);

  VCLK : clock_div_prec port map (reset, SW(9 downto 8), CLOCK_50, clock_div);

  -- TODO Bind buttons
  MAIN : computer port map (clock_div, reset,

                            SW(7 downto 0), x"00", x"00", x"00",
                            x"00", x"00", x"00", x"00",
                            x"00", x"00", x"00", x"00",
                            x"00", x"00", x"00", x"00",

                            POUT0, POUT1, POUT2, POUT3,
                            POUT4, POUT5, POUT6, POUT7,
                            POUT8, POUT9, POUT10, POUT11,
                            POUT12, POUT13, POUT14, POUT15);

  LEDR <= POUT0;

  CD0 : char_decoder port map (POUT1(3 downto 0), HEX0);
  CD1 : char_decoder port map (POUT1(7 downto 4), HEX1);
  CD2 : char_decoder port map (POUT2(3 downto 0), HEX2);
  CD3 : char_decoder port map (POUT2(7 downto 4), HEX3);
  CD4 : char_decoder port map (POUT3(3 downto 0), HEX4);
  CD5 : char_decoder port map (POUT3(7 downto 4), HEX5);

  GPIO(7 downto 0)  <= POUT4;
  GPIO(15 downto 8) <= POUT5;

end architecture;
