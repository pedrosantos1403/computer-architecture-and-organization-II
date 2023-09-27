library verilog;
use verilog.vl_types.all;
entity proc is
    port(
        Clock           : in     vl_logic;
        DIN             : in     vl_logic_vector(15 downto 0);
        Reset           : in     vl_logic;
        R0_output       : out    vl_logic_vector(15 downto 0);
        R1_output       : out    vl_logic_vector(15 downto 0);
        R2_output       : out    vl_logic_vector(15 downto 0);
        R3_output       : out    vl_logic_vector(15 downto 0);
        R4_output       : out    vl_logic_vector(15 downto 0);
        R5_output       : out    vl_logic_vector(15 downto 0);
        R6_output       : out    vl_logic_vector(15 downto 0);
        R7_output       : out    vl_logic_vector(15 downto 0);
        Addr_output     : out    vl_logic_vector(15 downto 0);
        Dout_output     : out    vl_logic_vector(15 downto 0);
        W               : out    vl_logic;
        BusWires        : out    vl_logic_vector(15 downto 0);
        Done            : out    vl_logic;
        IR_output       : out    vl_logic_vector(9 downto 0);
        Counter         : out    vl_logic_vector(2 downto 0);
        ALUop           : out    vl_logic_vector(2 downto 0)
    );
end proc;
