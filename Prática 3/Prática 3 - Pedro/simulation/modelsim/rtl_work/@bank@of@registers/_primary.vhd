library verilog;
use verilog.vl_types.all;
entity BankOfRegisters is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        cdb             : in     vl_logic_vector(15 downto 0);
        R0_output       : out    vl_logic_vector(15 downto 0);
        R1_output       : out    vl_logic_vector(15 downto 0);
        R2_output       : out    vl_logic_vector(15 downto 0)
    );
end BankOfRegisters;
