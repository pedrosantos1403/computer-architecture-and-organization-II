library verilog;
use verilog.vl_types.all;
entity mem_data is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        wb_p0           : in     vl_logic;
        wb_p1           : in     vl_logic;
        wb_p2           : in     vl_logic;
        p0_block        : in     vl_logic_vector(15 downto 0);
        p1_block        : in     vl_logic_vector(15 downto 0);
        p2_block        : in     vl_logic_vector(15 downto 0);
        \bus\           : in     vl_logic_vector(15 downto 0);
        mem_block       : out    vl_logic_vector(15 downto 0)
    );
end mem_data;
