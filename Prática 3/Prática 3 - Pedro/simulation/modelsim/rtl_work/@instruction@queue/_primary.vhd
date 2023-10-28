library verilog;
use verilog.vl_types.all;
entity InstructionQueue is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        stall           : in     vl_logic;
        opcode          : out    vl_logic_vector(2 downto 0);
        RX              : out    vl_logic_vector(2 downto 0);
        RY              : out    vl_logic_vector(2 downto 0);
        RZ              : out    vl_logic_vector(2 downto 0);
        immediate       : out    vl_logic_vector(3 downto 0)
    );
end InstructionQueue;
