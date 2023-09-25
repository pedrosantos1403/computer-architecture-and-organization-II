// Esse módulo controla o estado de execução em que o processador está
module upcount(Clear, Clock, Q);

input Clear, Clock;

output reg [1:0] Q;

always @(posedge Clock)

	if (Clear) begin
		Q <= 2'b0;
	end
	else begin
		Q <= Q + 1'b1;
	end

endmodule

