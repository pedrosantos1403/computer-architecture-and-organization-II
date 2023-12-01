library verilog;
use verilog.vl_types.all;
entity processador1 is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        proc            : in     vl_logic_vector(1 downto 0);
        opcode          : in     vl_logic_vector(1 downto 0);
        tag             : in     vl_logic_vector(3 downto 0);
        data            : in     vl_logic_vector(7 downto 0);
        p0_block        : in     vl_logic_vector(15 downto 0);
        p2_block        : in     vl_logic_vector(15 downto 0);
        data_mem        : in     vl_logic_vector(15 downto 0);
        p0_has_block    : in     vl_logic;
        p2_has_block    : in     vl_logic;
        bus_in          : in     vl_logic_vector(15 downto 0);
        bus_out         : out    vl_logic_vector(15 downto 0);
        proc_out        : out    vl_logic_vector(15 downto 0);
        wb              : out    vl_logic;
        wb_block        : out    vl_logic_vector(15 downto 0);
        done            : out    vl_logic;
        p1_block        : out    vl_logic_vector(15 downto 0);
        p1_has_block    : out    vl_logic
    );
end processador1;
