library ieee;
use ieee.std_logic_1164.all;

entity Control_Unit is
    port (
        OpCode:   in  std_logic_vector(3 downto 0) := "0000";
        MemRead:  out std_logic; 
        MemWrite: out std_logic;
        MemToReg: out std_logic;

        RegRead:  out std_logic;
        RegWrite: out std_logic;
        RegWCond: out std_logic;
        RegToAdr: out std_logic;

        ALUOp:   out std_logic_vector(1 downto 0);

        CondOp:  out std_logic_vector(1 downto 0);
        PCWrite: out std_logic
    );
end entity;

architecture rtl of Control_Unit is 
begin
    process(OpCode)
    begin
        MemRead  <= '0';
        MemWrite <= '0';
        MemToReg <= '0';

        RegRead  <= '0';
        RegWrite <= '0';
        RegWCond <= '0';

        PCWrite  <= '0';

        report "CU OpCode: " & to_string(OpCode);
        case OpCode is
            when "0000" => -- lw
                MemRead  <= '1';
                RegWrite <= '1';
                
                MemToReg <= '1';

            when "0001" => -- sw
                RegRead  <= '1';
                MemWrite <= '1';

            when "0100" => -- sum
                RegRead <= '1';
                ALUOp   <= "00";

                RegWrite <= '1';

            when "0101" => -- sub
                RegRead <= '1';
                ALUOp   <= "01";

                RegWrite <= '1';

            when "0110" => -- cmp
                RegRead <= '1';
                ALUOp   <= "10";

                RegWrite <= '1';

            when "0111" => -- mov
                RegRead  <= '1';
                RegWrite <= '1';

            when "1000" => -- lwr
                RegRead <= '1';
                
                MemRead <= '1';
                RegToAdr <= '1';

                MemToReg <= '1';
                RegWrite <= '1';

            when "1001" => -- swr
                RegRead  <= '1';
                
                RegToAdr <= '1'; 
                MemWrite <= '1';

            when "1010" => -- cmov
                RegRead  <= '1';
                RegWrite <= '1';
                RegWCond <= '1';

            when "1100" => -- jr
                RegRead <=  '1';
                CondOp  <= "00";
                PCWrite <=  '1';

            when "1101" => --je
                RegRead <=  '1';
                CondOp  <= "01";
                PCWrite <=  '1';
            
            when "1110" => --jl;
                RegRead <=  '1';
                CondOp  <= "10";
                PCWrite <=  '1';

            when "1111" => --jg;
                RegRead <=  '1';
                CondOp  <= "11";
                PCWrite <=  '1';

            when others =>
                assert False
                report "Invalid instruction " & to_string(OpCode)
                severity failure;
        end case;
    end process;
end rtl;
