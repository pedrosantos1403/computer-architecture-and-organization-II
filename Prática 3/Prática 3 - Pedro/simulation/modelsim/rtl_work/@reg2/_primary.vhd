library verilog;
use verilog.vl_types.all;
entity Reg2 is
    port(
        clock           : in     vl_logic;
        wren            : in     vl_logic;
        data            : in     vl_logic_vector(9 downto 0);
        R_output        : out    vl_logic_vector(9 downto 0)
    );
end Reg2;
