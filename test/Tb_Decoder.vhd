library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity Tb_Decoder is
end entity;

architecture sim of Tb_Decoder is
    type PrefixArray is array (0 to 4) of std_logic_vector(1 downto 0);
    type NameArray is array (0 to 4) of string (1 to 3);
    type CaseArray is array (0 to 4) of std_logic_vector(7 downto 0);

        constant ClassPrefix: PrefixArray := ("00", "01", "10", "10", "11");
    constant ClassName: NameArray := ("RM ", "RR1", "RR2", "RR2", "R  ");  
    
    constant TestCases: CaseArray := (
        "00000010",
        "00000011",
        "11011001",
        "11000101",
        "11001101"
    );

    signal Test: std_logic_vector(7 downto 0);
    signal TestOut: std_logic_vector(3 downto 0);
begin
    DUT: entity work.Decoder port map(
        Instruction => Test,
        OpCode => TestOut,
        RegL => open,
        RegR => open,
        MemAddr => open
    );
    
    process
    begin
        for t in 0 to 4 loop
            Test <= TestCases(t);
            wait for 100 ms;

            assert TestOut(3 downto 2) = ClassPrefix(t)
            report "failed to indetify class " & ClassName(t) & " in case " & to_string(Test) & " and mask " & to_string(ClassPrefix(t))
                        & ", got " & to_string(TestOut)
            severity warning;
        end loop;
        wait for 500 ms;
        std.env.stop;
    end process;
end sim;
