// Módulo referente ao PC -> Registrador R7
module regn_pc(R, Rin, Clock, Q, inc);
 
parameter n = 16;
 
input [n-1:0] R;
input Rin; // Sinal que habilita a escrita no PC em caso de branch
input Clock;
input inc; // Sinal que habilita o incremento padrão no PC
 
output reg [n-1:0] Q;
 
initial begin 
	Q<=16'b0000000010000000; // Saída do PC começa apontando pro registrador 0
end
 
always @(posedge Clock)
	begin
		if (Rin)
			Q <= R;
		else if(inc)
			Q <= Q + 1'b1;
	end

endmodule