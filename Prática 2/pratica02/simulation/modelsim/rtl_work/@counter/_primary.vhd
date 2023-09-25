library verilog;
use verilog.vl_types.all;
entity Counter is
    port(
        Clock           : in     vl_logic;
        Clear           : in     vl_logic;
        Counter         : out    vl_logic_vector(2 downto 0)
    );
end Counter;
