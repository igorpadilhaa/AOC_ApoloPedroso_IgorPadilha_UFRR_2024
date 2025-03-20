library ieee;
use ieee.std_logic_1164.all;

entity Decoder is
    port (
        Instruction: in std_logic_vector(7 downto 0);
        OpCode: out std_logic_vector(3 downto 0) := "0000";
        RegL: out std_logic_vector(1 downto 0);
        RegR: out std_logic_vector(1 downto 0);
        MemAddr: out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of Decoder is
begin
    process(Instruction)
    begin
        RegR <= "--";
        MemAddr <= "----";
        
        if Instruction(0) = '0' then            -- RM class (Op[0X], Reg[XX], Mem[XXXX])
            OpCode <= "000" & Instruction(1);
            RegL <= Instruction(3 downto 2);
            MemAddr <= Instruction(7 downto 4);

        elsif Instruction(1) = '1' then         -- RR Class (Op[11XX], RegR[XX], RegL[XX])
            OpCode <= "01" & Instruction(3 downto 2);
            RegL <= Instruction(5 downto 4);
            RegR <= Instruction(7 downto 6);
        
        elsif Instruction(2) = '0' then         -- RR-Ex Class (Op[100X], RegR[XX], RegL[XX])
            OpCode <= "100" & Instruction(3);
            RegL <= Instruction(5 downto 4);
            RegR <= Instruction(7 downto 6);

        elsif Instruction(3) = '0' then         -- RR-Ex Class (Op[1010], RegR[XX], RegL[XX])
            OpCode <= "1010";
            RegL <= Instruction(5 downto 4);
            RegR <= Instruction(7 downto 6);
            
        else                                    -- R Class (Op[1011XX], RegR[XX])
            Opcode <= "11" & Instruction(5 downto 4);
            RegL <= Instruction(7 downto 6);
        end if;
    end process;
end rtl;
