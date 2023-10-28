library verilog;
use verilog.vl_types.all;
entity memoriaInstrucao is
    port(
        origem          : in     vl_logic_vector(7 downto 0);
        saida           : out    vl_logic_vector(11 downto 0)
    );
end memoriaInstrucao;
