module count(clk, saida); // Recebe um clock
	input clk;
	output reg [20:0]saida;
	initial
		saida = 0; //Seta a saída inicialmente como zero
		
	always@(posedge clk) begin
			saida = saida + 1; //Acrescemta 1 no valor que estava na saída
	end
endmodule 