library verilog;
use verilog.vl_types.all;
entity pratica_2 is
    port(
        Resetn          : in     vl_logic;
        Run             : in     vl_logic;
        Done            : out    vl_logic
    );
end pratica_2;
