library verilog;
use verilog.vl_types.all;
entity ALU is
    port(
        A               : in     vl_logic_vector(15 downto 0);
        \Bus\           : in     vl_logic_vector(15 downto 0);
        ALUop           : in     vl_logic_vector(2 downto 0);
        ALU_output      : out    vl_logic_vector(15 downto 0)
    );
end ALU;
