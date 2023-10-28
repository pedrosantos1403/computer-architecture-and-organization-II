/**** GUARDA DADOS DENTRO DO REG ****/

module registrador1(clk,InputData,DataControl,InputLabel,LabelControl,OutputLabel,OutputData);
	input [8:0] InputData,InputLabel;
	input DataControl,LabelControl,clk;
	output reg[8:0] OutputLabel,OutputData;
	
	initial begin
		OutputLabel = 9'b111111111;
		OutputData = 9'b000000001;
	end
	always@(posedge DataControl)begin
		if(DataControl) begin
			OutputData = InputData;
		end
	end
	always@(posedge LabelControl)begin
		if(LabelControl) begin
				OutputLabel = InputLabel;
		end
	end
	
endmodule 


module registrador2(clk,InputData,DataControl,InputLabel,LabelControl,OutputLabel,OutputData);
	input [8:0] InputData,InputLabel;
	input DataControl,LabelControl,clk;
	output reg[8:0] OutputLabel,OutputData;
	
	initial begin
		OutputLabel = 9'b111111111;
		OutputData = 9'b000000010;
	end
	always@(posedge DataControl)begin
		if(DataControl) begin
			OutputData = InputData;
		end
	end
	always@(posedge LabelControl)begin
		if(LabelControl) begin
				OutputLabel = InputLabel;
		end
	end
	
endmodule 

module registrador0(clk,InputData,DataControl,InputLabel,LabelControl,OutputLabel,OutputData);
	input [8:0] InputData,InputLabel;
	input DataControl,LabelControl,clk;
	output reg[8:0] OutputLabel,OutputData;
	
	initial begin
		OutputLabel = 9'b111111111;
		OutputData = 9'b000000000;
	end
	always@(posedge DataControl)begin
		if(DataControl) begin
			OutputData = InputData;
		end
	end
	always@(posedge LabelControl)begin
		if(LabelControl) begin
				OutputLabel = InputLabel;
		end
	end
	
endmodule 