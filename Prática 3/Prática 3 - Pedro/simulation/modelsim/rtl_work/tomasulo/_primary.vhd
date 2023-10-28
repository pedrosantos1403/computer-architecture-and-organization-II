library verilog;
use verilog.vl_types.all;
entity tomasulo is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic
    );
end tomasulo;
