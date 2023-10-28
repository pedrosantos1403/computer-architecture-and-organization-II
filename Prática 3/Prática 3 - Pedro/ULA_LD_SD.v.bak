module ULA_LD_SD(
   input [4:0] RX_data,
   input [4:0] RY_data, 
   input [2:0] ULA_op,
	
	// Sinal que indica se os dois operandos estão prontos para a operação
	input operands_ready,
	
   output reg [4:0] ALU_output
);

always @(operands_ready) begin
   case(ULA_op)
		3'b000: ALU_output <= RX_data + RY_data;          // ADD
      3'b001: ALU_output <= RX_data - RY_data;          // SUB
   endcase  
end
  
endmodule
