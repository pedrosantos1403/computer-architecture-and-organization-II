library verilog;
use verilog.vl_types.all;
entity RegUpcode is
    port(
        reg_input       : in     vl_logic_vector(2 downto 0);
        is_Load         : in     vl_logic;
        is_mvi          : in     vl_logic;
        reg_output      : out    vl_logic_vector(7 downto 0)
    );
end RegUpcode;
