module ALUn(alu_control, A, B, ALU_out);

parameter n = 16;

input [n-1:0] A, B;
input [2:0] alu_control;

output reg [n-1:0] ALU_out;

always @(alu_control, A, B)
	case (alu_control)
		
		// Soma
		3'b000:
			ALU_out = A+B;
		
		// Subtração
		3'b001:
			ALU_out = A-B;
		
		// AND
		3'b010:
			ALU_out = A & B;
		
		// Less Than
		3'b011:
			if(A<B)
				ALU_out = 16'b1;
			else
				ALU_out = 16'b0;
		
		// Shift Left
		3'b100:	
			ALU_out = A << B;
		
		// Shift Right
		3'b101:
			ALU_out = A >> B;
			
		// mvi, mv, mvnz -> Não precisam estar na ALU, podem ser atribuições direto no processador
			
		default:
			ALU_out = 16'b0;
			
	endcase
 
 
endmodule