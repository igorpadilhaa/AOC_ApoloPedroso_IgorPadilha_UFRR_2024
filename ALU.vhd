library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        OpCode: in std_logic_vector(1 downto 0);
        OpA:    in  signed(7 downto 0);
        OpB:    in  signed(7 downto 0);
        Result: out signed(7 downto 0) := to_signed(0, 8)
    );
end entity;

architecture rtl of ALU is
begin
    process(OpCode, OpA, OpB)
        variable Mind: signed(7 downto 0);
        variable Equal: std_logic;
    begin
        if Opcode(1) = '0' then
            if OpCode(0) = '0' then
                Mind := OpA + OpB;
            else
                Mind := OpA - OpB;
            end if;
            Result <= Mind;
        end if;
        
        if OpCode(1) = '1' then
            Mind := OpA - OpB;
            Result(0) <= Mind(7);
            
            Equal := '1' when Mind = to_signed(0, 8) else '0';
            Result(1) <= Equal;

            Result(2) <= not (Mind(7) or Equal);
        end if;
    end process;
end rtl;
