library verilog;
use verilog.vl_types.all;
entity memory is
    port(
        addr            : in     vl_logic_vector(15 downto 0);
        data            : in     vl_logic_vector(15 downto 0);
        wr_en           : in     vl_logic;
        clock           : in     vl_logic;
        q               : out    vl_logic_vector(15 downto 0)
    );
end memory;
