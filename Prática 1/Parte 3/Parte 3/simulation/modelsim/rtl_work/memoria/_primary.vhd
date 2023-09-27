library verilog;
use verilog.vl_types.all;
entity memoria is
    port(
        HEX0            : out    vl_logic_vector(0 to 6);
        HEX1            : out    vl_logic_vector(0 to 6);
        HEX2            : out    vl_logic_vector(0 to 6);
        HEX3            : out    vl_logic_vector(0 to 6);
        HEX4            : out    vl_logic_vector(0 to 6);
        HEX5            : out    vl_logic_vector(0 to 6);
        HEX6            : out    vl_logic_vector(0 to 6);
        HEX7            : out    vl_logic_vector(0 to 6);
        SW              : in     vl_logic_vector(17 downto 0);
        KEY             : in     vl_logic_vector(3 downto 0);
        LEDG            : out    vl_logic_vector(8 downto 0);
        LEDR            : out    vl_logic_vector(17 downto 0)
    );
end memoria;
