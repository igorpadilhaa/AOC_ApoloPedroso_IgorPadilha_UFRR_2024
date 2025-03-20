library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity Processor is
end entity;

architecture rtl of Processor is
    signal Clock: std_logic := '1';
    signal Instrucao: std_logic_vector(7 downto 0) := (others => '0');
    signal OpCode: std_logic_vector(3 downto 0) := (others => '0');

    constant ClockPeriod: time := 10 ns;

    signal MemWrite: std_logic := '0';
    signal MemRead: std_logic := '0';
    signal Data: std_logic_vector(7 downto 0);
    signal Address: unsigned(7 downto 0) := to_unsigned(0, 8);

begin
    Ram: entity work.Ram port map(
       EnableRead => MemRead,
       EnableWrite => MemWrite,
       DataIn => Data,
       DataOut => Data,
       Clock => Clock,
       AddressIn => Address
    );

    Decoder: entity work.Decoder port map(
        Instruction => Instrucao,
        OpCode => OpCode,
        RegL => open,
        RegR => open,
        MemAddr => open
    );

    ControlUnit: entity work.Control_Unit port map(
        OpCode   => OpCode,
        MemRead  => open,
        MemWrite => open,
        MemToReg => open,

        RegRead  => open,
        RegWrite => open,
        RegWCond => open,
        RegToAdr => open,

        ALUOp => open,

        CondOp  => open,
        PCWrite => open
    );

    Clock <= '0', not Clock after ClockPeriod / 2;

    process
        variable PC: integer := 0;
    begin
        MemWrite <= '1';
        Data <= std_logic_vector(to_unsigned(PC, 8));
        wait for ClockPeriod;
        
        MemWrite <= '0';
        MemRead <= '1';
        wait for ClockPeriod;

        Instrucao <= Data;
        MemRead <= '0';
        PC := PC + 1;

        if PC > 255 then
            std.env.stop;
        end if;
end process;
end rtl;
