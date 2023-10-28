library verilog;
use verilog.vl_types.all;
entity tomasulo is
    generic(
        SOM             : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        SUB             : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        registrador0    : out    vl_logic_vector(8 downto 0);
        registrador1    : out    vl_logic_vector(8 downto 0);
        registrador2    : out    vl_logic_vector(8 downto 0);
        registrador3    : out    vl_logic_vector(8 downto 0);
        registrador4    : out    vl_logic_vector(8 downto 0);
        registrador5    : out    vl_logic_vector(8 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SOM : constant is 1;
    attribute mti_svvh_generic_type of SUB : constant is 1;
end tomasulo;
