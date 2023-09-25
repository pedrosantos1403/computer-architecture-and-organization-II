module regn(R, Rin, Clock, Q);

parameter n = 16;

// Dados de entrada para o registrador
input [n-1:0] R;

// Sinal que habilita a escrita no registrador
input Rin;

// Sinal de Clock
input Clock;

// Saída - Valor salvo no registrador
output reg [n-1:0] Q;
 
initial begin 
	Q<=16'b0;
end
 
always @(posedge Clock)
	if (Rin) begin
		Q <= R;
	end
 
endmodule