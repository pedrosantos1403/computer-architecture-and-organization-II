library verilog;
use verilog.vl_types.all;
entity ULA is
    port(
        clock           : in     vl_logic;
        RY_data         : in     vl_logic_vector(15 downto 0);
        RZ_data         : in     vl_logic_vector(15 downto 0);
        reg_dest        : in     vl_logic_vector(2 downto 0);
        ULA_op          : in     vl_logic_vector(2 downto 0);
        RS_position     : in     vl_logic_vector(1 downto 0);
        operands_ready  : in     vl_logic;
        ULA_output      : out    vl_logic_vector(15 downto 0)
    );
end ULA;
