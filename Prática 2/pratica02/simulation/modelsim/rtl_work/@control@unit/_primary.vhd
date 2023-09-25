library verilog;
use verilog.vl_types.all;
entity ControlUnit is
    port(
        IR              : in     vl_logic_vector(9 downto 0);
        Counter         : in     vl_logic_vector(2 downto 0);
        XXX             : in     vl_logic_vector(7 downto 0);
        YYY             : in     vl_logic_vector(7 downto 0);
        G_output        : in     vl_logic_vector(15 downto 0);
        IRin            : out    vl_logic_vector(10 downto 0);
        RNout           : out    vl_logic_vector(7 downto 0);
        RNin            : out    vl_logic_vector(7 downto 0);
        Ain             : out    vl_logic;
        Gin             : out    vl_logic;
        Gout            : out    vl_logic;
        DINout          : out    vl_logic;
        ALUOp           : out    vl_logic_vector(2 downto 0);
        Done            : out    vl_logic;
        W_D             : out    vl_logic;
        Addr_in         : out    vl_logic;
        Dout_in         : out    vl_logic;
        Incr_pc         : out    vl_logic;
        is_Load         : out    vl_logic
    );
end ControlUnit;
