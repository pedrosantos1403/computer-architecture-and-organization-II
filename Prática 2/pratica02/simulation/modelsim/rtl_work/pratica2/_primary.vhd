library verilog;
use verilog.vl_types.all;
entity pratica2 is
    port(
        PClock          : in     vl_logic;
        ResetIn         : in     vl_logic;
        \bus\           : out    vl_logic_vector(15 downto 0);
        Reg0            : out    vl_logic_vector(15 downto 0);
        Reg1            : out    vl_logic_vector(15 downto 0);
        Reg2            : out    vl_logic_vector(15 downto 0);
        Reg3            : out    vl_logic_vector(15 downto 0);
        Reg4            : out    vl_logic_vector(15 downto 0);
        Reg5            : out    vl_logic_vector(15 downto 0);
        Reg6            : out    vl_logic_vector(15 downto 0);
        PC              : out    vl_logic_vector(15 downto 0);
        Addr            : out    vl_logic_vector(15 downto 0);
        ir              : out    vl_logic_vector(9 downto 0);
        counter         : out    vl_logic_vector(2 downto 0);
        aluOp           : out    vl_logic_vector(2 downto 0)
    );
end pratica2;
