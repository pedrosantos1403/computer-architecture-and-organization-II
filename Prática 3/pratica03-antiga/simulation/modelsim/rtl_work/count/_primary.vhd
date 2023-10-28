library verilog;
use verilog.vl_types.all;
entity count is
    port(
        clk             : in     vl_logic;
        saida           : out    vl_logic_vector(20 downto 0)
    );
end count;
