library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_Bank is
    port (
        RegA: in std_logic_vector(1 downto 0);
        RegB: in std_logic_vector(1 downto 0);
        RegAOut: out std_logic_vector(7 downto 0);
        RegBOut: out std_logic_vector(7 downto 0);

        RegC: in std_logic_vector(1 downto 0);
        RegCIn: in std_logic_vector(7 downto 0);

        Clock: in std_logic;
        EnableWrite: in std_logic;
        EnableRead: in std_logic
    );   
end entity;

architecture rtl of Register_Bank is
    type RegisterVector is array (0 to 3) of std_logic_vector(7 downto 0);
    signal Registers: RegisterVector;
    signal RegAddrA: integer;
    signal RegAddrB: integer;
    signal RegAddrC: integer;
begin
    RegAddrA <= to_integer(unsigned(RegA));
    RegAddrB <= to_integer(unsigned(RegB));
    RegAddrC <= to_integer(unsigned(RegC));

    process(Clock)
    begin
        if rising_edge(Clock) then
            if EnableRead = '1' then
                RegAOut <= Registers(RegAddrA);
                RegBOut <= Registers(RegAddrB);
            else
                RegAOut <= (others => 'Z');
                RegBOut <= (others => 'Z');
            end if;
        end if;
        
        if falling_edge(Clock) then
            if EnableWrite = '1' then
                Registers(RegAddrC) <= RegCIn;
            end if;
        end if;
    end process;
end rtl;

