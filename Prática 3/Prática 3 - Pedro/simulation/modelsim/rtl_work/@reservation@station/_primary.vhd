library verilog;
use verilog.vl_types.all;
entity ReservationStation is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        RX              : in     vl_logic_vector(2 downto 0);
        RY              : in     vl_logic_vector(2 downto 0);
        RZ              : in     vl_logic_vector(2 downto 0);
        ULA_op          : in     vl_logic_vector(2 downto 0);
        immediate       : in     vl_logic_vector(3 downto 0);
        cdb             : in     vl_logic_vector(15 downto 0);
        R0_data         : in     vl_logic_vector(9 downto 0);
        R1_data         : in     vl_logic_vector(9 downto 0);
        R2_data         : in     vl_logic_vector(9 downto 0);
        operand1_sumsub : out    vl_logic_vector(15 downto 0);
        operand2_sumsub : out    vl_logic_vector(15 downto 0);
        Opcode_sumsub   : out    vl_logic_vector(2 downto 0);
        Reg_dest_sumsub : out    vl_logic_vector(2 downto 0);
        operands_ready_sumsub: out    vl_logic;
        sumsub_position : out    vl_logic_vector(1 downto 0);
        operand1_ldsd   : out    vl_logic_vector(15 downto 0);
        operand2_ldsd   : out    vl_logic_vector(15 downto 0);
        Opcode_ldsd     : out    vl_logic_vector(2 downto 0);
        Reg_dest_ldsd   : out    vl_logic_vector(2 downto 0);
        operands_ready_ldsd: out    vl_logic;
        ldsd_position   : out    vl_logic_vector(1 downto 0);
        stall           : out    vl_logic
    );
end ReservationStation;
