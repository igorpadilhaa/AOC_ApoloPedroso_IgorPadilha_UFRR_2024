library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Ram_Pkg.all;

entity Ram is
    Generic (
        INIT_DATA: RamVector := (others => (others => '0'))
    );
    Port (
        Clock:       in  std_logic;
        EnableWrite: in  std_logic;
        EnableRead:  in  std_logic;
        AddressIn:   in  unsigned(7 downto 0);
        DataIn:      in  std_logic_vector(7 downto 0);
        DataOut:     out std_logic_vector(7 downto 0) := "ZZZZZZZZ"
    );
end entity;

architecture rtl of Ram is
    signal Data: RamVector := INIT_DATA;
    signal Address: integer := 0;
begin
    process(AddressIn)
    begin
        if Clock = '1' and (EnableRead = '1' or EnableWrite = '1') then
            Address <= to_integer(AddressIn);
        end if;
    end process;

    process(Clock, EnableRead, EnableWrite)
    begin
        if Clock = '1' then
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
