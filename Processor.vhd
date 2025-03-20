library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity Processor is
end entity;

architecture rtl of Processor is
    signal Clock: std_logic := '1';
    signal Fetch: std_logic := '1';
    signal Exec:  std_logic;
    signal PC: unsigned(7 downto 0) := to_unsigned(0, 8);

    signal CoreMemWrite: std_logic;
    signal CoreMemRead:  std_logic;
    signal CoreMemAddr:  unsigned(7 downto 0);
    signal CoreMemIn: std_logic_vector(7 downto 0);

    signal Instruction: std_logic_vector(7 downto 0);
    
    signal MemRead: std_logic;
    signal MemWrite: std_logic;
    signal MemAddr: unsigned(7 downto 0);
    signal MemIn:  std_logic_vector(7 downto 0);
    signal MemOut: std_logic_vector(7 downto 0);

    constant ClockPeriod: time := 1000 ns;
begin
    Clock <= not Clock after ClockPeriod / 2;
    Fetch <= not Fetch after ClockPeriod;
    Exec  <= (not Fetch) and Clock;

    Ram: entity work.Ram 
        generic map(
            INIT_DATA => (
                0 => "10000100",
                1 => "10000110",
                8 => "00000110",
                others => (others => 'U')
            )
        )
        port map(
            EnableRead => MemRead,
            EnableWrite => MemWrite,
            DataIn => MemIn,
            DataOut => MemOut,
            Clock => Clock,
            AddressIn => PC
        );

    Core: entity work.Core port map(
        PCIn => PC, 
        Instruction => Instruction,

        MemWrite => CoreMemWrite,
        MemRead  => CoreMemRead,
        MemAddr  => CoreMemAddr,
        MemIn    => CoreMemIn,

        MemOut  => MemOut,

        PCOut => PC,
        Clock => Exec
    );

    process(Clock)
    begin
        if Fetch = '1' then
            MemRead <= '1';
            MemAddr <= PC;
            Instruction <= MemOut;

        else
            MemRead <= CoreMemRead;
            MemAddr <= CoreMemAddr;
        end if;
    end process;
end rtl;
