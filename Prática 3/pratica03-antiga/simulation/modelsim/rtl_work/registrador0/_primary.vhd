library verilog;
use verilog.vl_types.all;
entity registrador0 is
    port(
        clk             : in     vl_logic;
        InputData       : in     vl_logic_vector(8 downto 0);
        DataControl     : in     vl_logic;
        InputLabel      : in     vl_logic_vector(8 downto 0);
        LabelControl    : in     vl_logic;
        OutputLabel     : out    vl_logic_vector(8 downto 0);
        OutputData      : out    vl_logic_vector(8 downto 0)
    );
end registrador0;
