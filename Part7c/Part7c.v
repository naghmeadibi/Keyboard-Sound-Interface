module Part7c(	input CLOCK_50, inout PS2_CLK, PS2_DAT, input [0:0] KEY,
				input AUD_BCLK, AUD_DACLRCK, output AUD_DACDAT, AUD_XCK,
				inout I2C_SDAT, output I2C_SCLK);

wire [3:0] ps2data;

wire [3:0] sound_code;
wire data_rq, data_rd, ts;

///////////////////////////////////////////////////////////////////
// Enter new code into handshake_p3.v
// HINT: Start from handshake_p1.v from part 3a and add in code for the sound synthesizer
///////////////////////////////////////////////////////////////////
handshake_p3 h(.clock(CLOCK_50), .reset(~KEY[0]), .ps2_data(ps2data), .ps2_en(ts),
			.sound_code(sound_code), .data_rq(data_rq), .data_rd(data_rd));

///////////////////////////////////////////////////////////////////
// PS2_Controller (keyboard) and synthesizer (sound)
// Don't modify this
///////////////////////////////////////////////////////////////////
PS2_Controller PS2(	.clk(CLOCK_50), .reset(~KEY[0]), .PS2_CLK(PS2_CLK), .PS2_DAT(PS2_DAT),
					.ps2data(ps2data), .tx_start(ts));

synthesizer s(	CLOCK_50, !KEY[0], AUD_BCLK, AUD_DACLRCK, AUD_DACDAT, AUD_XCK, I2C_SDAT, I2C_SCLK,
				sound_code, data_rq, data_rd);

endmodule
