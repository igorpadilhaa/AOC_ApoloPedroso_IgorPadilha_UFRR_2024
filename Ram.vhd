library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ram is
    Port (
        Clock:       in  std_logic;
        EnableWrite: in  std_logic;
        EnableRead:  in  std_logic;
        AddressIn:   in  unsigned(7 downto 0);
        DataIn:      in  std_logic_vector(7 downto 0);
        DataOut:     out std_logic_vector(7 downto 0) := "ZZZZZZZZ";
    );
end entity;

architecture rtl of Ram is
    type RamVector is array (0 to 255) of std_logic_vector(7 downto 0);
    signal Data: RamVector;
    signal Address: integer;
begin
    Address <= to_integer(AddressIn);

    process(Clock)
    begin
        if rising_edge(Clock) then
            if EnableWrite = '1' then
                Data(Address) <= DataIn;
            end if;
        
            if EnableRead = '1' then
                DataOut <= Data(Address);
            else
                DataOut <= "ZZZZZZZZ";
            end if;
        end if;
    end process;
end rtl;
