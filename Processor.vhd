library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processor is
end entity;

architecture rtl of Processor is
    signal Clock: std_logic;
    signal Instrucao: std_logic_vector(7 downto 0);

    type RamVector is array (0 to 255) of std_logic_vector(7 downto 0);
begin
    Clock <= '0', not Clock after 500 ms;

    process(Clock, Instrucao)
        variable Ram: RamVector := (
            0 => "00000000", 
            1 => "00000001",
            2 => "00000010", 
            others => "10101010"
        );
        variable PC: unsigned(7 downto 0) := to_unsigned(1, 8);
    begin
        Instrucao <= Ram(to_integer(PC));
        PC := PC + 1;
    end process;
        
    process(Instrucao)
        variable inst: integer;
    begin
        inst := to_integer(unsigned(Instrucao));
        report "Instrução coletada: " & integer'image(inst);
    end process;
end rtl;
