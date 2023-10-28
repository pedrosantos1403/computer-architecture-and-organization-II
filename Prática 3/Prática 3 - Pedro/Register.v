module Register(
   input clock,
	input wren,
   input [15:0] data,
   output reg[15:0] R_output
);  

initial begin
	R_output = 16'b0;
end
	
always @(posedge clock) begin
	if(wren) begin
		R_output = data;
	end
end

endmodule
