library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity Tb_ALU is
end entity;

architecture sim of Tb_ALU is
    signal OpCode: std_logic_vector(1 downto 0);
    signal OpA: signed(7 downto 0);
    signal OpB: signed(7 downto 0);
    
    signal TestResult: signed(7 downto 0) := to_signed(0, 8);
    signal TestInt: integer;

    constant WaitTime: time := 1 ns;
begin
    DUT: entity work.ALU port map(
        OpCode => OpCode,
        OpA => OpA,
        OpB => OpB,
        Result => TestResult
    );

    TestInt <= to_integer(TestResult);

    process
    begin
        OpCode <= "01"; -- sub
        OpA <= to_signed(5, 8);
        OpB <= to_signed(3, 8);
        wait for WaitTime;
        assert TestInt = 2
        report "failed to subtract 3 of 5, expected 2 but got " & integer'image(TestInt)
        severity error;

        OpCode <= "00"; -- sum
        OpA <= to_signed(5, 8);
        OpB <= to_signed(4, 8);
        wait for WaitTime;
        assert TestInt = 9
        report "failed to sum 5 and 4, expected 9 but got " & integer'image(TestInt)
        severity error;

        OpCode <= "10";
        OpA <= to_signed(5, 8);
        OpB <= to_signed(2, 8);
        wait for WaitTime;
        assert TestResult(2 downto 0) = "100"
        report "failed to compare 5 and 2, expected 100 (l, e, g), but got " & to_string(TestResult(2 downto 0))
        severity error;

        OpCode <= "10";
        OpA <= to_signed(2, 8);
        OpB <= to_signed(5, 8);
        wait for WaitTime;
        assert TestResult(2 downto 0) = "001"
        report "failed to compare 2 and 5, expected 001 (l, e, g), but got " & to_string(TestResult(2 downto 0))
        severity error;

        OpCode <= "10";
        OpA <= to_signed(5, 8);
        OpB <= to_signed(5, 8);
        wait for WaitTime;
        assert TestResult(2 downto 0) = "010"
        report "failed to compare 5 and 5, expected 010 (l, e, g), but got " & to_string(TestResult(2 downto 0))
        severity error;

        std.env.stop;
    end process;
end sim;
