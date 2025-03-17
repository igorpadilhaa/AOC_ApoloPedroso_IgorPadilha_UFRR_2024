library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity Tb_Ram is
end entity;

architecture behavior of Tb_Ram is
    signal Clock:       std_logic := '0';
    signal EnableWrite: std_logic := '0';
    signal EnableRead:  std_logic := '0';
    signal AddressIn:   unsigned(7 downto 0) := (others => '0');
    signal DataIn:      std_logic_vector(7 downto 0) := (others => '0');
    signal DataOut:     std_logic_vector(7 downto 0);

    constant ClockPeriod: time := 10 ns;

begin
    DUT: entity work.Ram
        port map (
            Clock       => Clock,
            EnableWrite => EnableWrite,
            EnableRead  => EnableRead,
            AddressIn   => AddressIn,
            DataIn      => DataIn,
            DataOut     => DataOut
        );

    ClockProcess: process
    begin
        while true loop
            Clock <= '0';
            wait for ClockPeriod / 2;
            Clock <= '1';
            wait for ClockPeriod / 2;
        end loop;
    end process;

    TestProcess: process
        variable TestData: std_logic_vector(7 downto 0);
    begin
        for i in 0 to 255 loop
            TestData := std_logic_vector(to_unsigned(i, 8));
            AddressIn <= to_unsigned(i, 8);

            DataIn <= TestData;
            EnableWrite <= '1';
            wait for ClockPeriod;
            
            EnableWrite <= '0';
            EnableRead <= '1';
            wait for ClockPeriod;
            
            assert DataOut = TestData
            report "Erro: O dado lido difere do esperado!"
            severity failure;
            
            EnableRead <= '0';
            wait for ClockPeriod;
        end loop;
        std.env.stop;
    end process;
end architecture;
