library ieee;
use ieee.std_logic_1164.all;

entity Ram_Test is
end entity;

architecture sim of Ram_Test is
    signal MemWrite, MemRead: std_logic;
    signal Address: std_logic_vector(7 downto 0);
begin
    Ram: entity work.Ram port map(
        EnableWrite => MemWrite,
        EnableRead => MemRead, 
        AddressIn => Address,
        DataIn => Input,
        DataOut => Output
    );
end sim;
