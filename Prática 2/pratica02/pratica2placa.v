module pratica2 (SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDG, LEDR);
	

input [17:0] SW;

// KEY[0] -> Clock
// KEY[1] -> Reset
input [3:0] KEY;

// HEX[3:0] -> BusWires
// HEX[4] 	-> Counter
// HEX[6] 	-> Addr
// HEX[7] 	-> PC 
output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;

// LEDG[2:0] -> Reg X
// LEDG[7:5] -> Reg Y
output [8:0] LEDG;

// LEDR[17:8] -> IR 
// LEDR[4:2]  -> ALUop
output [17:0] LEDR;

// Saídas do Processador
wire [15:0] bus;
wire [15:0] r0;
wire [15:0] r1;
wire [15:0] r2;
wire [15:0] r3;
wire [15:0] r4;
wire [15:0] r5;
wire [15:0] r6;
wire [15:0] pc;
wire [15:0] addr;
wire [9:0] ir;
wire [2:0] counter;
wire [2:0] aluop;

pratica2 Pratic2(KEY[0]/*Clock*/, SW[17]/*Reset*/, r0, r1, r2, r3, r4, r5, r6, pc, addr, ir, counter, aluop);

// DISPLAYS
disp7seg PC (pc, HEX7);
disp7seg Addr (addr, HEX6);
disp7seg bus1 (bus[15:12], HEX3);
disp7seg bus2 (bus[11:8], HEX2);
disp7seg bus3 (bus[7:4], HEX1);
disp7seg bus4 (bus[3:0], HEX0);
disp7seg Counter (counter, HEX4);

// LEDG
assign LEDG[2:0] = r0; // RX -> Trataremos r0 e r1 como os registradores x e y das instruções em um primeiro momento para facilitar os testes
assign LEDG[7:5] = r1; // RY

// LEDR
assign LEDR[4:2] = aluop;
assign LEDR[17:8] = ir;

// Inicializando HEX5 sem valor
assign HEX5 = 7'b1111111;

endmodule
