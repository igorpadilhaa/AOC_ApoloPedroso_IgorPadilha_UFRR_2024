library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Core is
    port (
        Clock: in std_logic;
        PCIn:  in unsigned(7 downto 0);
        Instruction: in std_logic_vector(7 downto 0);
        
        MemWrite: out std_logic;
        MemRead:  out std_logic;
        MemAddr:  out unsigned(7 downto 0);
    
        MemOut: in std_logic_vector(7 downto 0);
        MemIn:  out std_logic_vector(7 downto 0);

        PCOut: out unsigned(7 downto 0) := to_unsigned(0, 8)
    );
end entity;

architecture rtl of Core is
    signal OpCode: std_logic_vector(3 downto 0) := (others => '0');

    signal RegWrite: std_logic;
    signal RegRead:  std_logic;
    
    signal RegL:     std_logic_vector(1 downto 0);
    signal RegLOut:  std_logic_vector(7 downto 0);

    signal RegR:     std_logic_vector(1 downto 0);
    signal RegROut:  std_logic_vector(7 downto 0);

    signal RegIn: std_logic_vector(7 downto 0);
    
    signal ALUOp:  std_logic_vector(1 downto 0);
    signal ALUOut: signed(7 downto 0);

    signal ALUOpA: signed(7 downto 0);
    signal ALUOpB: signed(7 downto 0);

    signal RelAdr:   std_logic;
    signal MemToReg: std_logic;
    signal RegToReg: std_logic;

    signal MemAddrShort: std_logic_vector(3 downto 0);
    signal CmpData: std_logic_vector(2 downto 0);

    signal CondOp: std_logic_vector(1 downto 0);
    signal PCWrite: std_logic;

begin
    Decoder: entity work.Decoder port map(
        Instruction => Instruction,
        OpCode => OpCode,
        RegL => RegL,
        RegR => RegR,
        MemAddr => MemAddrShort
    );

    ControlUnit: entity work.Control_Unit port map(
        OpCode   => OpCode,
        MemRead  => MemRead,
        MemWrite => MemWrite,
        MemToReg => MemToReg,
        
        RegRead  => RegRead,
        RegWrite => RegWrite,
        RegToReg => RegToReg,
        RegWCond => open,

        ALUOp => ALUOp,
        CondOp => CondOp,

        PCWrite => PCWrite
    );

    Bank: entity work.Register_Bank port map(
        RegA => RegL,
        RegB => RegR,
        RegAOut => RegLOut,
        RegBOut => RegROut,
        
        RegC   => RegL,
        RegCIn => RegIn,

        Clock => Clock,
        EnableWrite => RegWrite,
        EnableRead  => RegRead
    );

    ALU: entity work.ALU port map(
        OpCode  => ALUOp,
        OpA => ALUOpA,
        OpB => ALUOpB,
        Result => ALUOut
    );

    CmpData <= std_logic_vector(ALUOut(2 downto 0));

    process(RegL, RegR, PCIn, MemAddrShort)
    begin
        if RelAdr = '1' then
            ALUOpA <= signed(PCIn);
            ALUOpB <= signed("0000" & MemAddrShort);
        else
            ALUOpA <= signed(RegLOut);
            ALUOpB <= signed(RegROut);
        end if;
    end process;

    process(ALUOut, RegR)
    begin
        if RelAdr = '1' then
            MemAddr <= unsigned(ALUOut);
        else
            MemAddr <= unsigned(RegROut);
        end if;
    end process;

    process(MemOut, RegR, ALUOut)
    begin
        if MemToReg = '1' then
            RegIn <= MemOut;
        elsif RegToReg = '1' then
            RegIn <= RegROut;
        else
            RegIn <= std_logic_vector(ALUOut);
        end if;
    end process;

    process(Clock)
    begin
        if Clock = '1' then
            if PCWrite = '1' then
                if CondOp = "00" then
                    PCOut <= unsigned(RegLOut);
                elsif CondOp = "01" and CmpData = "010" then
                    PCOut <= unsigned(RegLOut);
                elsif CondOp <= "10" and CmpData = "001" then
                    PCOut <= unsigned(RegLOut);
                elsif CondOP = "11" and CmpData = "100" then
                    PCOut <= unsigned(RegLOut);
                else
                    PCOut <= to_unsigned(to_integer(PCOut) + 1, 8);
                end if;
            else
                PCOut <= to_unsigned(to_integer(PCOut) + 1, 8);
            end if;
        end if;
    end process;
end rtl;
