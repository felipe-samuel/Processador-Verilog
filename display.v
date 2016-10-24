module display(
		input      [3:0] BCD,
		output wire 		 A,
		output wire 		 B,
		output wire 		 C,
		output wire 		 D,
		output wire 		 E,
		output wire 		 F,
		output wire 		 G
	);

	reg [6:0] SevenSeg;

	always @(*)
	case(BCD)
		4'h0:    SevenSeg = 8'b1111110;
		4'h1:    SevenSeg = 8'b0110000;
		4'h2:    SevenSeg = 8'b1101101;
		4'h3:    SevenSeg = 8'b1111001;
		4'h4:    SevenSeg = 8'b0110011;
		4'h5:    SevenSeg = 8'b1011011;
		4'h6:    SevenSeg = 8'b1011111;
		4'h7:    SevenSeg = 8'b1110000;
		4'h8:    SevenSeg = 8'b1111111;
		4'h9:    SevenSeg = 8'b1111011;
		default: SevenSeg = 8'b0000000;
	endcase

	assign {A, B, C, D, E, F, G} = ~SevenSeg;

endmodule
