library verilog;
use verilog.vl_types.all;
entity Reg0 is
    port(
        clock           : in     vl_logic;
        wren            : in     vl_logic;
        data            : in     vl_logic_vector(15 downto 0);
        R_output        : out    vl_logic_vector(15 downto 0)
    );
end Reg0;
