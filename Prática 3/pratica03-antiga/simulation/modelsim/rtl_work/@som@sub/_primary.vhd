library verilog;
use verilog.vl_types.all;
entity SomSub is
    port(
        clk             : in     vl_logic;
        RUN             : in     vl_logic;
        RegX            : in     vl_logic_vector(8 downto 0);
        RegY            : in     vl_logic_vector(8 downto 0);
        RegZ            : in     vl_logic_vector(8 downto 0);
        OpCode          : in     vl_logic_vector(2 downto 0);
        Result          : out    vl_logic_vector(8 downto 0);
        Done            : out    vl_logic;
        XAddSub         : in     vl_logic_vector(2 downto 0);
        LabelAddSub     : in     vl_logic_vector(2 downto 0);
        EnderecoSaida   : out    vl_logic_vector(2 downto 0);
        \Label\         : out    vl_logic_vector(2 downto 0)
    );
end SomSub;
