library verilog;
use verilog.vl_types.all;
entity dec3to8 is
    port(
        W               : in     vl_logic_vector(2 downto 0);
        En              : in     vl_logic;
        Y               : out    vl_logic_vector(0 to 7)
    );
end dec3to8;
