library verilog;
use verilog.vl_types.all;
entity CDBArbiter is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        ULA_output      : in     vl_logic_vector(15 downto 0);
        ULA_ld_sd_output: in     vl_logic_vector(15 downto 0);
        cdb             : out    vl_logic_vector(15 downto 0)
    );
end CDBArbiter;
