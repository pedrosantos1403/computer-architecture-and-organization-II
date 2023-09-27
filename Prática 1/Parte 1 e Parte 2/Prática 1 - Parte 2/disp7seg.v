module disp7seg(entry, display);
	parameter tamanho = 8;
	input [tamanho - 1:0] entry;
	output reg [6:0] display;
	
	always @(entry) begin
	case(entry)
			8'b00000000: display = 7'b0000001; // 0
			8'b00000001: display = 7'b1001111; // 1
			8'b00000010: display = 7'b0010010; // 2
			8'b00000011: display = 7'b0000110; // 3
			8'b00000100: display = 7'b1001100; // 4
			8'b00000101: display = 7'b0100100; // 5
			8'b00000110: display = 7'b0100000; // 6
			8'b00000111: display = 7'b0001101; // 7
			8'b00001000: display = 7'b0000000; // 8
			8'b00001001: display = 7'b0000100; // 9
			8'b00001010: display = 7'b0001000; // A
			8'b00001011: display = 7'b1100000; // b
			8'b00001100: display = 7'b0110001; // C
			8'b00001101: display = 7'b1000010; // d
			8'b00001110: display = 7'b0110000; // E
			8'b00001111: display = 7'b0111000; // F
			default    : display = 7'b0111111; // -
	endcase
	end
endmodule