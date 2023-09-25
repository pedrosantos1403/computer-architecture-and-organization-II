library verilog;
use verilog.vl_types.all;
entity RegN_pc is
    port(
        \Bus\           : in     vl_logic;
        Rin             : in     vl_logic;
        Clock           : in     vl_logic;
        incr            : in     vl_logic;
        Clear           : in     vl_logic;
        Counter         : out    vl_logic_vector(15 downto 0)
    );
end RegN_pc;
