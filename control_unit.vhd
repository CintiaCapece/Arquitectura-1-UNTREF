library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.segm_mips_const_pkg.all;

-- Unidad de control: genera se馻les de control para los componentes a partir de 
-- los bits del codigo de la instruccion.

entity CONTROL_UNIT is
	port(
		OP       : in  STD_LOGIC_VECTOR(5 downto 0); --C贸digo de operaci贸n

		RegWrite : out STD_LOGIC;       --Se帽al de habilitaci贸n de escritura (RegWrite)
		MemtoReg : out STD_LOGIC;       --Se帽al de habilitaci贸n  (MemToReg)
		Branch    : out STD_LOGIC;       --Se帽al de habilitaci贸n  (Branch)
		MemRead  : out STD_LOGIC;       --Se帽al de habilitaci贸n  (MemRead)
		MemWrite : out STD_LOGIC;       --Se帽al de habilitaci贸n  (MemWrite)
		RegDst   : out STD_LOGIC;       --Se帽al de habilitaci贸n  (RegDst)
		ALUSrc   : out STD_LOGIC;       --Se帽al de habilitaci贸n  (ALUSrc)
		alu_op   : out STD_LOGIC_VECTOR(1 downto 0)    
	);
end CONTROL_UNIT;

architecture CONTROL_UNIT_ARC of CONTROL_UNIT is

	--Decaraci贸n de se帽ales
	signal R_TYPE : STD_LOGIC;
	signal LW     : STD_LOGIC;
	signal SW     : STD_LOGIC;
	signal BEQ    : STD_LOGIC;
	signal LUI    : STD_LOGIC;

begin
	process(R_TYPE,LW,SW,BEQ,LUI,RegWrite,MemtoReg,Branch,MemRead,MemWrite,RegDst,ALUSrc,alu_op)
		begin

	R_TYPE <= not OP(5) and not OP(4) and not OP(3) and not OP(2) and not OP(1) and not OP(0);

	LW <= OP(5) and not OP(4) and not OP(3) and not OP(2) and OP(1) and OP(0);

	SW <= OP(5) and not OP(4) and OP(3) and not OP(2) and OP(1) and OP(0);

	BEQ <= not OP(5) and not OP(4) and not OP(3) and OP(2) and not OP(1) and not OP(0);

	LUI <= not OP(5) and not OP(4) and OP(3) and OP(2) and OP(1) and OP(0);

	RegWrite <= R_TYPE or LW or LUI;
	MemtoReg <= LW;
	Branch    <= BEQ;
	MemRead  <= LW or LUI;
	MemWrite <= SW;
	RegDst   <= R_TYPE;
	ALUSrc   <= LW or SW or LUI;
	
	if BEQ = "1" then
		alu_op <= "01";
	elsif R_TYPE = "1" then
		alu_op <= "10";
	elsif LW = "1" or SW = "1" then
		alu_op <= "00";
	elsif LUI = "1" then
		alu_op <= "11";
	end if;
	
	--ALUOp0   <= BEQ;
	--ALUOp1   <= R_TYPE;
	--ALUOp2   <= LUI;
	end process;

end CONTROL_UNIT_ARC;
