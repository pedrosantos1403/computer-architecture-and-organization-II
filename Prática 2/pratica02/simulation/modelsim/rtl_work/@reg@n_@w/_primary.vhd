library verilog;
use verilog.vl_types.all;
entity RegN_W is
    port(
        Clock           : in     vl_logic;
        W_D             : in     vl_logic;
        R_output        : out    vl_logic
    );
end RegN_W;
