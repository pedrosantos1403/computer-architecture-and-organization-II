library verilog;
use verilog.vl_types.all;
entity ALUn is
    generic(
        n               : integer := 16
    );
    port(
        M               : in     vl_logic_vector(2 downto 0);
        A               : in     vl_logic_vector;
        B               : in     vl_logic_vector;
        Result          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
end ALUn;
