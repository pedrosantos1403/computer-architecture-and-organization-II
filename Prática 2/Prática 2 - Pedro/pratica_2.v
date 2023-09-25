module pratica_2(Resetn, Run, Done);

input Resetn, Run;
output Done;

reg Clock;
wire W;
wire [15:0] DataInProc, DataInMem, Addr;

processador proc(DataInProc, Resetn, Clock, Run, Done, Addr, DataInMem, W);
//memory mem(Addr, DataInMem, W, Clock, DataInProc);
ram_lpm RAM(Addr,clock,data,W,DataInProc);
rom_lpm ROM(Addr,clock,q_rom);

initial begin
	Clock=1;
end
always begin
	#1 Clock = ~Clock;
end
endmodule

