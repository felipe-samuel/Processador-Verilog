module BCD(
	input      [7:0] binario,
	output reg [3:0] centenas,
	output reg [3:0] dezenas,
	output reg [3:0] unidades
	);

	integer i;
	
	always@(binario)
	begin
		centenas = 4'd0;
		dezenas  = 4'd0;
		unidades = 4'd0;

		for(i=7 ; i>=0; i=i-1)
		begin
			if(centenas >= 5)
				centenas = centenas + 3;
			if(dezenas  >= 5)
				dezenas  = dezenas  + 3;
			if(unidades >= 5)
				unidades = unidades + 3;
			
			centenas = centenas << 1;
			centenas[0] = dezenas[3];

			dezenas = dezenas << 1;
			dezenas[0] = unidades[3];
			
			unidades = unidades << 1;			
			unidades[0] = binario[i];
		end
	end

endmodule
