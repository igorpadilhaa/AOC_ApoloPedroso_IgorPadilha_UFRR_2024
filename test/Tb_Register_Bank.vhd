library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity Tb_Register_Bank is
end Tb_Register_Bank;

architecture sim of Tb_Register_Bank is
    constant ClockPeriod: time := 10 ns;
    signal DataA: std_logic_vector(7 downto 0);
    signal DataB: std_logic_vector(7 downto 0);
    signal AddrA: std_logic_vector(1 downto 0);
    signal AddrB: std_logic_vector(1 downto 0);
    
    signal Clock: std_logic := '0';
    signal RegWrite: std_logic := '0';
    signal RegRead: std_logic := '0';

    signal DataC: std_logic_vector(7 downto 0);
    signal AddrC: std_logic_vector(1 downto 0);
begin
    DUT: entity work.Register_Bank port map(
        RegAOut => DataA,
        RegBOut => DataB,
        RegCIn => DataC,
        RegA => AddrA,
        RegB => AddrB,
        RegC => AddrC,

        EnableRead => RegRead,
        EnableWrite => RegWrite,
        Clock => Clock
    );

    Clock <= not Clock after ClockPeriod / 2;
    
    process
    begin
        for i in 0 to 3 loop
            RegWrite <= '1';
            AddrC <= std_logic_vector(to_unsigned(i, 2));
            DataC <= std_logic_vector(to_unsigned(i, 8));
            
            wait for ClockPeriod;
            RegWrite <= '0';
        end loop;

        for i in 0 to 2 loop
            RegRead <= '1';
            AddrA <= std_logic_vector(to_unsigned(i, 2));
            AddrB <= std_logic_vector(to_unsigned(i + 1, 2));

            wait for ClockPeriod;
            
            assert DataA = std_logic_vector(to_unsigned(i, 8))
            report "Falha na leitura ou escrita do registrador A"
            severity error;

            assert DataB = std_logic_vector(to_unsigned(i + 1, 8))
            report "Falha na leitura ou escrita do registrador B"
            severity error;
        end loop;
        std.env.stop;
    end process;
end sim;
