library verilog;
use verilog.vl_types.all;
entity disp7seg is
    generic(
        tamanho         : integer := 8
    );
    port(
        entry           : in     vl_logic_vector;
        display         : out    vl_logic_vector(6 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of tamanho : constant is 1;
end disp7seg;
