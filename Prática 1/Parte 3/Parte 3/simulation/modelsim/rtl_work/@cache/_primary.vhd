library verilog;
use verilog.vl_types.all;
entity Cache is
    port(
        clock           : in     vl_logic;
        address         : in     vl_logic_vector(4 downto 0);
        wren            : in     vl_logic;
        data            : in     vl_logic_vector(7 downto 0);
        q               : out    vl_logic_vector(7 downto 0);
        RAM             : out    vl_logic_vector(13 downto 0);
        qRAM            : in     vl_logic_vector(7 downto 0);
        hit             : out    vl_logic;
        state           : out    vl_logic_vector(2 downto 0);
        reset           : in     vl_logic;
        mem_access_done : out    vl_logic;
        lru0            : out    vl_logic_vector(1 downto 0);
        lru1            : out    vl_logic_vector(1 downto 0);
        lru2            : out    vl_logic_vector(1 downto 0);
        lru3            : out    vl_logic_vector(1 downto 0);
        d0              : out    vl_logic;
        d1              : out    vl_logic;
        d2              : out    vl_logic;
        d3              : out    vl_logic
    );
end Cache;
