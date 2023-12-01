library verilog;
use verilog.vl_types.all;
entity mem_inst is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        send            : in     vl_logic;
        done_p0         : in     vl_logic;
        done_p1         : in     vl_logic;
        done_p2         : in     vl_logic;
        proc            : out    vl_logic_vector(1 downto 0);
        opcode          : out    vl_logic_vector(1 downto 0);
        tag             : out    vl_logic_vector(3 downto 0);
        data            : out    vl_logic_vector(7 downto 0)
    );
end mem_inst;
