module SubCounter(clk,RUN,reset,q);
	input clk,RUN,reset;
	output reg [2:0]q;
	initial
		q = 0;
	always@(posedge clk) begin
		if(q == 3 || reset)
			q = 0;
		else if(RUN)	
			q = q + 1;
	end
endmodule

module SomSub(clk,RUN,RegX,RegY,RegZ,OpCode,Result,Done,XAddSub,LabelAddSub,EnderecoSaida,Label);
	input [8:0]RegX,RegY,RegZ;
	input [2:0]OpCode,XAddSub,LabelAddSub;
	input clk,RUN;
	output reg Done;
	output [2:0]EnderecoSaida,Label;
	output reg [8:0]Result;
	wire [2:0]count;
	
	assign EnderecoSaida = XAddSub;
	assign Label = LabelAddSub;
	
	always@(clk,RegX,RegY,RegZ,OpCode,RUN) begin
		Done = 0;
		if(count == 2 && OpCode == 3'b000) begin
			Result = RegY + RegZ; //ADD
			Done = 1;
		end
		else if(count == 2 && OpCode == 3'b001) begin
			Result = RegY - RegZ; //SUB 
			Done = 1;
		end
	end
	SubCounter c(clk,RUN,Done,count);
endmodule 