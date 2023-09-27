module memoria(SW, LEDG, LEDR,HEX0, HEX1, HEX2, HEX3, HEX4,  HEX5, HEX6, HEX7);
	input [17:0] SW;
	output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	output [7:0] LEDG;	//leds verdes
	output [17:0] LEDR;	//leds vermelhos
	wire [4:0] address;	//endereÃƒÂ§o
	wire [7:0] data; 		//dado
	wire clock; 			//clock
	wire wren;				//write enable
	wire [7:0] out;			//output
	
	assign clock = SW[17];		//aciona pulso de colck
	assign LEDG[1:1]=clock;
	assign LEDG[0:0]=~clock;
	
	assign wren = SW[16]; 		//(des)habilita escrita na memoria
	assign LEDR[0:0]=~wren; 	//deshabilita escrita na memoria
	assign LEDG[7:7]=wren; 		//habilita escrita na memoria
	
	assign data = SW[13:6]; 	//dado a ser escrito na memoria (input)
	assign address = SW[4:0]; 	//endereco da posiÃƒÂ§ÃƒÂ£o de memoria (output)
	
	ramlpm RAM(address, clock, data, wren, out);	//cria instancia de ramlpm
	
	assign HEX2=7'b1111111;	 //desativa display 7 segmentos HEX2
	assign HEX3=7'b1111111;	 //desativa display 7 segmentos HEX3
	

	
	disp7seg dispSeg1(out[7:4], HEX1); 			//conteudo da memoria (output)
	disp7seg dispSeg0(out[3:0], HEX0);
	disp7seg dispSeg5(address[4:4], HEX5);	//Endereco da posicao de memoria
	disp7seg dispSeg4(address[3:0], HEX4);
	disp7seg dispSeg7(data[7:4], HEX7);		//Dado inserido na memoria (input)
	disp7seg dispSeg6(data[3:0], HEX6);
 	
endmodule



////Para a simulacao
//module memoria (address, clock, data, wren, out);
//	
//	input [4:0] address; 
//	input clock; 
//	input [7:0] data; 
//	input wren;
//	output [7:0] out; 
//	
//	ramlpm RAM (address, clock, data, wren, out);
// 	
//endmodule
