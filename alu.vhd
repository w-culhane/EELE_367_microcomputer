library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
  port (A, B       : in  std_logic_vector(7 downto 0);
        ALU_sel    : in  std_logic_vector(2 downto 0);
        NZVC       : out std_logic_vector(3 downto 0);
        ALU_result : out std_logic_vector(7 downto 0));
end entity;

architecture ALU_arch of ALU is
begin

  process (A, B, ALU_sel)
    variable Sum_uns : unsigned(8 downto 0);
  begin
    -- Addition
    if (ALU_sel = "000") then
      Sum_uns    := unsigned('0' & A) + unsigned('0' & B);
      ALU_result <= std_logic_vector(Sum_uns(7 downto 0));

      -- Negative flag (N)
      NZVC(3) <= Sum_uns(7);

      -- Zero flag (Z)
      if (Sum_uns(7 downto 0) = x"00") then
        NZVC(2) <= '1';
      else
        NZVC(2) <= '0';
      end if;

      -- Overflow flag (V)
      if ((A(7) = '0' and B(7) = '0' and Sum_uns(7) = '1') or
          (A(7) = '1' and B(7) = '1' and Sum_uns(7) = '0')) then
        NZVC(1) <= '1';
      else
        NZVC(1) <= '0';
      end if;

      -- Carry flag (C)
      NZVC(0) <= Sum_uns(8);
    -- TODO Add more ALU functionality
    -- - SUB
    -- - AND
    -- - OR
    -- - INCA/DECA
    -- - INCB/DECB
    end if;
  end process;

end architecture;
