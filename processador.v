module processador(clk,reset,chaves,botoes, saida1,saida2,saida3,
	A11, B11, C11, D11, E11, F11, G11, A12, B12, C12, D12, E12, F12, G12, A13, B13, C13, D13, E13, F13, G13
  ,A21, B21, C21, D21, E21, F21, G21, A22, B22, C22, D22, E22, F22, G22, A23, B23, C23, D23, E23, F23, G23
  ,A31, B31, C31, D31, E31, F31, G31, A32, B32, C32, D32, E32, F32, G32, A33, B33, C33, D33, E33, F33, G33);
	input clk;
	input reset;
	
	input [17:0]chaves;
	input [3:0]botoes;
	
	output [31:0]saida1;
	output [31:0]saida2;
	output [31:0]saida3;
	
	output A11, B11, C11, D11, E11, F11, G11, A12, B12, C12, D12, E12, F12, G12, A13, B13, C13, D13, E13, F13, G13
  ,A21, B21, C21, D21, E21, F21, G21, A22, B22, C22, D22, E22, F22, G22, A23, B23, C23, D23, E23, F23, G23
  ,A31, B31, C31, D31, E31, F31, G31, A32, B32, C32, D32, E32, F32, G32, A33, B33, C33, D33, E33, F33, G33;
	
	//sinais de controle
	wire m1;
	wire [2:0]m2;
	wire m3;
	wire [1:0]m4;
	wire m5;
	wire [1:0]PCstartEnd;
	wire MIW;
	wire MDW;
	wire RW;
	wire SW;
	//------------------
	
	//saidas mux--------
	wire [4:0]mux1out;
	wire [31:0]mux2out;
	wire [31:0]mux3out;
	wire [21:0]mux4out;
	wire [21:0]mux5out;
	//------------------
	
	wire [21:0]pcout;
	
	wire [31:0]instrucao;
	wire [4:0]opcode;
	wire [4:0]R1;
	wire [4:0]R2;
	wire [4:0]R3;
	wire [16:0]I;
	wire [21:0]E;
	
	wire [31:0]memoriaDadosOut;
	
	wire [31:0]RegOut1;
	wire [31:0]RegOut2;
	
	wire [3:0]control;

	wire [31:0]ALUout;
	
	wire flagZ;
	
	wire [31:0]entradaOut;
	
	wire [3:0]unidades1;
	wire [3:0]dezenas1;
	wire [3:0]centenas1;
	
	wire [3:0]unidades2;
	wire [3:0]dezenas2;
	wire [3:0]centenas2;
	
	wire [3:0]unidades3;
	wire [3:0]dezenas3;
	wire [3:0]centenas3;
	
	wire A11, B11, C11, D11, E11, F11, G11, A12, B12, C12, D12, E12, F12, G12, A13, B13, C13, D13, E13, F13, G13
  ,A21, B21, C21, D21, E21, F21, G21, A22, B22, C22, D22, E22, F22, G22, A23, B23, C23, D23, E23, F23, G23
  ,A31, B31, C31, D31, E31, F31, G31, A32, B32, C32, D32, E32, F32, G32, A33, B33, C33, D33, E33, F33, G33;
	
	wire clk2;
	
	
	assign opcode = instrucao[31:27];
	assign R1 = instrucao[26:22];
	assign R2 = instrucao[21:17];
	assign R3 = instrucao[16:12];
	assign I = instrucao[16:0];
	assign E = instrucao[21:0];
	
	Temporizador tttttttt(clk,clk2);
	//assign clk2 = clk;
	
	UC uuu(clk2,reset,flagZ,opcode,m1,m2,m3,m4,m5,PCstartEnd,MIW,MDW,RW,SW);
	PC pc1(clk2,PCstartEnd,mux4out,pcout);
	memoriaInstrucao mi(clk2,MIW,pcout,instrucao);
	memoriaDados md(clk2,MDW, mux5out ,RegOut2,memoriaDadosOut);
	Registradores R(clk2,RW,R1,R2,mux1out,mux2out,RegOut1,RegOut2);
	ALUcontrol c(opcode,control);
	ALU alu(control,RegOut1,mux3out,ALUout,flagZ);
	mux1 mm1(m1,R1,R3,mux1out);
	mux2 mm2(m2,memoriaDadosOut,ALUout,RegOut1,entradaOut,E,pcout,mux2out);
	mux3 mm3(m3,RegOut2,I,mux3out);
	mux4 mm4(m4,pcout,E,I,RegOut1,ALUout[1'b0],mux4out);
	mux5 mm5(m5,E,RegOut1,mux5out);
	Entradas eeee(clk2,R2,chaves,~botoes,entradaOut);
	Saidas ssss(clk2,SW,R1,RegOut1,saida1,saida2,saida3);
	
	BCD bcd1(saida1, centenas1, dezenas1, unidades1 );
	BCD bcd2(saida2, centenas2, dezenas2, unidades2 );
	BCD bcd3(saida3, centenas3, dezenas3, unidades3 );
	
	display d11(dezenas1,  A11, B11, C11, D11, E11, F11, G11);
	display d12(unidades1, A12, B12, C12, D12, E12, F12, G12);
	
	display d21(dezenas2 , A21, B21, C21, D21, E21, F21, G21);
	display d22(unidades2, A22, B22, C22, D22, E22, F22, G22);
	
	display d31(centenas3, A31, B31, C31, D31, E31, F31, G31);
	display d32(dezenas3 , A32, B32, C32, D32, E32, F32, G32);
	display d33(unidades3, A33, B33, C33, D33, E33, F33, G33);
	
endmodule



module PC(clk,PCstartEnd,entrada,saida);

	input clk;
	input [1:0]PCstartEnd;
	input [21:0]entrada;
	
	output reg [21:0]saida;
	
	always@(posedge clk)
	begin
		if(PCstartEnd==2'b01)
			saida<=22'b0;
		else if(PCstartEnd==2'b10)
			saida<=saida;
		else
			saida<=entrada;
	end
	
endmodule


module memoriaInstrucao(clk,MIW,endereco,instrucao);
	input clk;
	input MIW;
	input [21:0]endereco;
	output [31:0]instrucao;
	reg [31:0] RAM [0:200] ;
	
	always@(posedge clk)
	begin
		if(MIW==1'b1)
		begin//LOCAL DAS INSTRU��ES
			
			
			
			RAM[5'b00000]=32'b11011000000000000000000000000000; //set R0=0   //INICIO
			RAM[5'b00001]=32'b11011000010000000000000000000001; //set R1=1
			RAM[5'b00010]=32'b11001000100000000000000000000000; //input valor  R10 //A 
			
			RAM[5'b00011]=32'b11001000111010000000000000000000; //input bot�o 1
			RAM[5'b00100]=32'b10011000110000100000000000000010; //beq R11==R1 V10
			RAM[5'b00101]=32'b10000000000000000000000000000010; //junp A
			
			RAM[5'b00110]=32'b11001000111010000000000000000000; //input bot�o 1    //A2
			RAM[5'b00111]=32'b10011000110000000000000000000010; //beq R11==R0 V10
			RAM[5'b01000]=32'b10000000000000000000000000000110; //junp A2
			
			RAM[5'b01001]=32'b11010000100001000000000000000000; //output saida3 valor
			RAM[5'b01010]=32'b11001001000000000000000000000000; //input expoente  R100 //B 
			RAM[5'b01011]=32'b11001000111010000000000000000000; //input bot�o 1
			RAM[5'b01100]=32'b10011000110000100000000000000010; //beq R11==R1 V10
			RAM[5'b01101]=32'b10000000000000000000000000001010; //junp B
			
			RAM[5'b01110]=32'b11001000111010000000000000000000; //input bot�o 1 //B2
			RAM[5'b01111]=32'b10011000110000000000000000000010; //beq R11==R0 V10
			RAM[5'b10000]=32'b10000000000000000000000000001110; //junp B2
			
			RAM[5'b10001]=32'b11010000010010000000000000000000; //output saida2 expoente
			RAM[5'b10010]=32'b11011001010000000000000000000001; //set resultado R101=1
			RAM[5'b10011]=32'b10011001000000000000000000000100; //beq R100==R0 V100 //C
			RAM[5'b10100]=32'b00100001010010100010000000000000; //Mult R101=R101*R10 resultado=resultado*valor
			RAM[5'b10101]=32'b00011001000010000000000000000001; //SUBI R100=R100-1 expoente--
			RAM[5'b10110]=32'b10000000000000000000000000010011; //junp C
			RAM[5'b10111]=32'b11010000000010100000000000000000; //output saida1 resultado 
			
			RAM[5'b11000]=32'b10000000000000000000000000000000; //junp INICIO
			
			
			
			/*
			RAM[5'b00000]=32'b11011000000000000000000000000000; //set R0=0   //INICIO
			RAM[5'b00001]=32'b11011000010000000000000000000001; //set R1=1
			RAM[5'b00010]=32'b11001000100000000000000000000000; //input valor  R10 //A 
			RAM[5'b00011]=32'b11001000111010000000000000000000; //input bot�o 1
			RAM[5'b00100]=32'b10011000110000100000000000000010; //beq R11==R1 V10
			RAM[5'b00101]=32'b10000000000000000000000000000010; //junp A
			RAM[5'b00110]=32'b11010000100001000000000000000000; //output saida3 valor
			RAM[5'b00111]=32'b11001001000000000000000000000000; //input expoente  R100 //B 
			RAM[5'b01000]=32'b11001000111010000000000000000000; //input bot�o 1
			RAM[5'b01001]=32'b10011000110000100000000000000010; //beq R11==R1 V10
			RAM[5'b01010]=32'b10000000000000000000000000000111; //junp B
			RAM[5'b01011]=32'b11010000010010000000000000000000; //output saida2 expoente
			RAM[5'b01100]=32'b11011001010000000000000000000001; //set resultado R101=1
			RAM[5'b01101]=32'b10011001000000000000000000000100; //beq R100==R0 V100 //C
			RAM[5'b01110]=32'b00100001010010100010000000000000; //Mult R101=R101*R10 resultado=resultado*valor
			RAM[5'b01111]=32'b00011001000010000000000000000001; //SUBI R100=R100-1 expoente--
			RAM[5'b10000]=32'b10000000000000000000000000001101; //junp C
			RAM[5'b10001]=32'b11010000000010100000000000000000; //output saida1 resultado 
			RAM[5'b10010]=32'b00000000000000000000000000000000; //junp INICIO
			*/
			
			/*programa de teste 1
			RAM[4'b0000]=32'b11011000000000000000000000000010;
			RAM[4'b0001]=32'b11010000000000000000000000000000;
			RAM[4'b0010]=32'b11000000000000000000000000000000;
			RAM[4'b0011]=32'b10111000010000000000000000000000;
			RAM[4'b0100]=32'b11010000000000100000000000000000;
			RAM[4'b0101]=32'b11001000100000000000000000000000;
			RAM[4'b0110]=32'b11010000000001000000000000000000;
			RAM[4'b0111]=32'b00000000110000000001000000000000;
			RAM[4'b1000]=32'b11010000000001100000000000000000;
			RAM[4'b1001]=32'b00000001000001100010000000000000;
			RAM[4'b1010]=32'b11010000000010000000000000000000;*/
		end
	end
	
	assign instrucao = RAM[endereco];
endmodule

module memoriaDados(clk,MDW,endereco,dados,saida);
	
	input clk;
	input MDW;
	input [21:0]endereco;
	input [31:0]dados;
	output [31:0]saida;

	reg [31:0] RAM [200:0];
	
	always@(posedge clk)
	begin
		if(MDW==1'b1)
		begin
			RAM[endereco]=dados;
		end
	end
	
	assign saida = RAM[endereco];
	
	
endmodule


module Registradores(clk,RW,escrita,leitura1,leitura2,dados,saida1,saida2);
	
	input clk;
	input RW;
	
	input [4:0]escrita;
	input [4:0]leitura1;
	input [4:0]leitura2;
	input [31:0]dados;
	
	output [31:0]saida1;
	output [31:0]saida2;

	reg [31:0]BancoDeRegistradores[0:31];//31:0
	
	assign saida1 = BancoDeRegistradores[leitura1];
	assign saida2 = BancoDeRegistradores[leitura2];
	
	always@(posedge clk)
	begin
		if(RW==1'b1)
		begin
			BancoDeRegistradores[escrita]<=dados;
		end
	end
	
endmodule

module Saidas(clk,SW,endereco,dados,saida1,saida2,saida3,saida4,saida5);	
	input clk;
	input SW;
	input [4:0]endereco;
	input [31:0]dados;
	output [31:0]saida1;
	output [31:0]saida2;
	output [31:0]saida3;
	output [31:0]saida4;
	output [31:0]saida5;

	reg [31:0]saidas[31:0];

	always@(posedge clk)
	begin
		if(SW==1'b1)
		begin
			saidas[endereco]=dados;
		end
	end
	
	assign saida1 = saidas[5'b0];
	assign saida2 = saidas[5'b1];
	assign saida3 = saidas[5'b10];
	assign saida4 = saidas[5'b11];
	assign saida5 = saidas[5'b100];
endmodule


module Entradas(
	input clk,
	input [4:0]endereco,
	input [17:0]chaves,
	input [3:0]botoes,
	output [31:0]EntradaEscolhida);
	
	reg [31:0]RegEntradas[31:0];
	
	always@(*)
	begin
			RegEntradas[5'b0]={14'b0,chaves};
			RegEntradas[5'b1]={31'b0,chaves[5'b0]};
			RegEntradas[5'b10]={31'b0,chaves[5'b1]};
			RegEntradas[5'b11]={31'b0,chaves[5'b10]};
			RegEntradas[5'b100]={31'b0,chaves[5'b11]};
			RegEntradas[5'b101]={31'b0,chaves[5'b100]};
			RegEntradas[5'b110]={31'b0,chaves[5'b101]};
			RegEntradas[5'b111]={31'b0,chaves[5'b110]};
			RegEntradas[5'b1000]={31'b0,chaves[5'b111]};
			RegEntradas[5'b1001]={31'b0,chaves[5'b1000]};
			RegEntradas[5'b1010]={31'b0,chaves[5'b1001]};
			RegEntradas[5'b1011]={31'b0,chaves[5'b1010]};
			RegEntradas[5'b1100]={31'b0,chaves[5'b1011]};
			RegEntradas[5'b1101]={31'b0,chaves[5'b1100]};
			RegEntradas[5'b1110]={31'b0,chaves[5'b1101]};
			RegEntradas[5'b1111]={31'b0,chaves[5'b1110]};
			RegEntradas[5'b10000]={31'b0,chaves[5'b1111]};
			RegEntradas[5'b10001]={31'b0,chaves[5'b10000]};
			RegEntradas[5'b10010]={31'b0,chaves[5'b10001]};
			RegEntradas[5'b10011]={28'b0,botoes};
			RegEntradas[5'b10100]={31'b0,botoes[2'b0]};
			RegEntradas[5'b10101]={31'b0,botoes[2'b1]};
			RegEntradas[5'b10110]={31'b0,botoes[2'b10]};
			RegEntradas[5'b10111]={31'b0,botoes[2'b11]};
	end
	
	assign EntradaEscolhida=RegEntradas[endereco];
	
endmodule


module ALUcontrol(opcode,saida);
	input [4:0]opcode;
	output reg [3:0]saida;
	always@(*)
	begin
		case(opcode)
			5'b00000: saida = 4'b0000; //soma, SOMA
			5'b00001: saida = 4'b0000; //Soma I, SOMA
			5'b00010: saida = 4'b0001; // sub , SUB
			5'b00011: saida = 4'b0001; //Sub I , SUB
			5'b00100: saida = 4'b0010; //mult, MULT
			5'b00101: saida = 4'b0010; //mult I, MULT
			5'b00110: saida = 4'b0011; //and , AND
			5'b00111: saida = 4'b0011; //and I, AND
			5'b01000: saida = 4'b0100; //or, OR
			5'b01001: saida = 4'b0100; //or I, OR
			5'b01010: saida = 4'b0101; //not, NOT
			5'b01011: saida = 4'b1011; // slt, alu1<alu2
			5'b01100: saida = 4'b1011; // sltI, alu1<alu2-
			5'b01101: saida = 4'b0110; //sll, SLL
			5'b01110: saida = 4'b0111; //slr, SLR
			//5'b01111:;// MOVE, NADA
			//5'b10000:;// j, nada
			//5'b10001:;// jr, nada
			//5'b10010:;// jz, nada
			5'b10011: saida = 4'b1000; // beq, ALUin1==ALUin2 
			5'b10100: saida = 4'b1001; // bnq, ALUin1!=ALUin2 
			5'b10101: saida = 4'b1011; // bob, ALUin1<ALUin2, � o contr�rio pois as entradas da ula s�o trocadas
			5'b10110: saida = 4'b1010; // bos, ALUin1>ALUin2,  � o contr�rio pois as entradas da ula s�o trocadas
			//5'b10111:;// load, nada
			//5'b11000:;// store, nada
			//5'b11001:;// input, nada
			//5,b11010:;//output, nada
			//5'b11011:;// setR, nada

			5'b10010: saida = 4'b1100;// Div, DIV
			default: saida = 4'b1111;
		endcase
	end
endmodule

module ALU(control,entrada1,entrada2,saida,flagZ);
	
	input [3:0]control;
	input signed [31:0]entrada1;
	input signed [31:0]entrada2;
	
	output reg signed [31:0]saida;
	output reg flagZ;

	
	
	always@(*)
	begin
		case(control)
				4'b0000: saida = entrada1 + entrada2;// soma	
				4'b0001: saida = entrada1 - entrada2;// subtração
				4'b0010: saida = entrada1 * entrada2;// multiplicação
				4'b0011: saida = entrada1 & entrada2;// AND
				4'b0100: saida = entrada1 | entrada2;// OR
				4'b0101: saida = ~entrada1; // NOT
				4'b0110: saida = entrada1<<1;// shift leaft 
				4'b0111: saida = entrada1>>1;// shift right
				4'b1000: //ALUin1==ALUin2 
				begin
					if(entrada1==entrada2)
						saida = 32'b00000000000000000000000000000001;
					else
						saida = 32'b00000000000000000000000000000000;
				end//
				4'b1001: //ALUin1!=ALUin2 
				begin
					if(entrada1!=entrada2)
						saida = 32'b00000000000000000000000000000001;
					else
						saida = 32'b00000000000000000000000000000000;
				end
				4'b1010: //ALUin1>ALUin2
				begin
					if(entrada1>entrada2)
						saida = 32'b00000000000000000000000000000001;
					else
						saida = 32'b00000000000000000000000000000000;
				end
				4'b1011: // ALUin1 < ALUin2
				begin
					if(entrada1<entrada2)
						saida = 32'b00000000000000000000000000000001;
					else
						saida = 32'b00000000000000000000000000000000;
				end
				4'b1100: saida = entrada1 / entrada2;// divisao
				default: saida = 32'b0;
		endcase
		
		if(control!=4'b1111)
		begin
			case(saida)
					32'b0: flagZ=1;
					default: flagZ=0;
			endcase
		end
	end
endmodule

module mux1(m1,R1,R3,saida);
	
	input m1;
	input [4:0]R1;
	input [4:0]R3;
	
	output reg [4:0]saida;

	always@(*)
	begin
		case(m1)
			1'b0:saida=R1;
			1'b1:saida=R3;
		endcase
	end
	
endmodule

module mux2(m2,memoriaDados,ALUout,RegOut1,INPUT,E,PC,saida);
	
	input [2:0]m2;
	input [31:0]memoriaDados;
	input [31:0]ALUout;
	input [31:0]RegOut1;
	input [31:0]INPUT;
	input [22:0]E;
	input [22:0]PC;
	
	output reg [31:0]saida;

	always@(*)
	begin
		case(m2)
			3'b000:saida=memoriaDados;
			3'b001:saida=ALUout;
			3'b010:saida=RegOut1;
			3'b011:saida=INPUT;
			3'b100:saida={10'b0,E};
			3'b101:saida={10'b0,PC};
			default:saida=memoriaDados;
		endcase
	end
	
endmodule

module mux3(m3,RegOut2,I,saida);
	
	input m3;
	input [31:0]RegOut2;
	input [16:0]I;
	
	output reg [31:0]saida;

	always@(*)
	begin
		case(m3)
			1'b0:saida=RegOut2;
			1'b1:saida={15'b0,I};
		endcase
	end
	
endmodule

module mux4(m4,pc,E,I,RegOut1,l,saida);
	
	input [1:0]m4;
	input [21:0]pc;
	input [21:0]E;
	input [16:0]I;
	input [31:0]RegOut1;
	input l; 
	
	output reg [21:0]saida;

	always@(*)
	begin
		case(m4)
			2'b00:saida= pc + 22'b1;
			2'b01:saida= E;
			2'b10:
			begin
				if(l==1'b1)
					saida= pc + {5'b0,I};
				else
					saida= pc + 22'b1;
			end
			2'b11:saida= RegOut1[21:0];
		endcase
	end
endmodule


module mux5(m5,E,RegOut1,saida);
	
	input m5;
	input [21:0]E;
	input [31:0]RegOut1; 
	
	output reg [21:0]saida;

	always@(*)
	begin
		case(m5)
			1'b0:saida= E;
			1'b1:saida= RegOut1[21:0];
		endcase
	end
endmodule


	
module UC(clk,reset,z,opcode,m1,m2,m3,m4,m5,PCstartEnd,MIW,MDW,RW,SW);         
	input clk;
	input reset;
	input z;
	input [4:0]opcode;
	output reg m1;
	output reg [2:0]m2;
	output reg m3;
	output reg [1:0]m4;
	output reg m5;
	output reg [1:0]PCstartEnd;
	output reg MIW;
	output reg MDW;
	output reg RW;
	output reg SW;
	//estados: 0-Inicializa��o, 1-Execu��o 
	reg EstadoAtual;
	reg EstadoFuturo;
	
	always@(*)
	begin
		case(reset)
			1'b0: EstadoFuturo=1;
			1'b1: EstadoFuturo=0;
		endcase
	end
	
	always@(posedge clk)
	begin
		EstadoAtual<=EstadoFuturo;
	end
	
	always@(*)
	begin
		
		if(EstadoAtual==1'b1)
		begin
			case(opcode)
			
				5'b00000: //ADD
				begin
					m1=1'b1;
					m2=3'b1;
					m3=1'b0;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end

				5'b00001://ADD I
				begin
					m2=3'b001;
					m3=1'b1;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b00010://SUB
				begin
					m1=1'b1;
					m2=3'b1;
					m3=1'b0;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b00011://SUB I
				begin
					m2=3'b001;
					m3=1'b1;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b00100://MULT
				begin
					m1=1'b1;
					m2=3'b1;
					m3=1'b0;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b00101://MULT I
				begin
					m2=3'b001;
					m3=1'b1;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b00110://AND
				begin
					m1=1'b1;
					m2=3'b1;
					m3=1'b0;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b00111://AND I
				begin
					m2=3'b001;
					m3=1'b1;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b01000://OR
				begin
					m1=1'b1;
					m2=3'b1;
					m3=1'b0;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b01001://OR I
				begin
					m2=3'b001;
					m3=1'b1;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b01010://NOT
				begin
					m2=3'b001;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end				
				
				5'b01011://SLT
				begin
					m1=1'b1;
					m2=3'b1;
					m3=1'b0;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b01100://SLT I
				begin
					m2=3'b001;
					m3=1'b1;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b01101://SLL
				begin
					m2=3'b001;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b01110://SLR
				begin
					m2=3'b001;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end			
				
				5'b01111://MOVE
				begin
					m2=3'b010;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end		
				
				5'b10000://J
				begin
					m4=2'b01;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b0;
					SW=1'b0;
				end	
				
				5'b10001://Jr
				begin
					m4=2'b11;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b0;
					SW=1'b0;
				end	
				
				
				
				5'b10011://Beq
				begin
					m1=1'b0;
					m3=1'b0;
					m4=2'b10;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b0;
					SW=1'b0;
				end	
				
				5'b10100://Bnq
				begin
					m1=1'b0;
					m3=1'b0;
					m4=2'b10;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b0;
					SW=1'b0;
				end	
				
				5'b10101://Bob
				begin
					m1=1'b0;
					m3=1'b0;
					m4=2'b10;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b0;
					SW=1'b0;
				end	
				
				5'b10110://Bos
				begin
					m1=1'b0;
					m3=1'b0;
					m4=2'b10;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b0;
					SW=1'b0;
				end	
				
				5'b10111: //load
				begin
					m2=3'b0;
					m4=2'b0;
					m5=1'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b11000://store
				begin
					m1=1'b0;
					m4=2'b0;
					m5=1'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b1;
					RW=1'b0;
					SW=1'b0;
				end
			
				5'b11001://input
				begin
					m2=3'b11;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
			
				5'b11010://output
				begin
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b0;
					SW=1'b1;
				end
			
				5'b11011://setR
				begin
					m2=3'b100;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				//novas instrucoes para o compilador-------------------------------
				5'b11100://LoadR
				begin
					m2=3'b0;
					m4=2'b0;
					m5=1'b1;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
				5'b11101://StoreR
				begin
					m1=1'b0;
					m4=2'b0;
					m5=1'b1;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b1;
					RW=1'b0;
					SW=1'b0;
				end
				
				5'b11110://movePC
				begin
					m2=3'b101;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				


				5'b10010://Div
				begin
					m1=1'b1;
					m2=3'b1;
					m3=1'b0;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b1;
					SW=1'b0;
				end
				
	
				5'b11111://end
				begin
					PCstartEnd=2'b10;
				end
			
				default:
				begin
					m1=1'b0;
					m2=3'b0;
					m3=1'b0;
					m4=2'b0;
					PCstartEnd=2'b0;
					MIW=1'b0;
					MDW=1'b0;
					RW=1'b0;
					SW=1'b0;
				end
			endcase
		end
		
		else
		begin
					m1=1'b0;
					m2=3'b0;
					m3=1'b0;
					m4=2'b0;
					PCstartEnd=2'b01;
					MIW=1'b1;
					MDW=1'b0;
					RW=1'b0;
					SW=1'b0;
		end
	end
	
	
	
endmodule

