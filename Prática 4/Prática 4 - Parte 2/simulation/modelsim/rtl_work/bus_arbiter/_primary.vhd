library verilog;
use verilog.vl_types.all;
entity bus_arbiter is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        proc            : in     vl_logic_vector(1 downto 0);
        bus_p0          : in     vl_logic_vector(15 downto 0);
        bus_p1          : in     vl_logic_vector(15 downto 0);
        bus_p2          : in     vl_logic_vector(15 downto 0);
        \bus\           : out    vl_logic_vector(15 downto 0)
    );
end bus_arbiter;
