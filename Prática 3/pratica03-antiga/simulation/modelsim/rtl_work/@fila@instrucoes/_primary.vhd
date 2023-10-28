library verilog;
use verilog.vl_types.all;
entity FilaInstrucoes is
    generic(
        ADD             : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        SUB             : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        inst            : out    vl_logic_vector(11 downto 0);
        addFullControl  : in     vl_logic_vector(2 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADD : constant is 1;
    attribute mti_svvh_generic_type of SUB : constant is 1;
end FilaInstrucoes;
