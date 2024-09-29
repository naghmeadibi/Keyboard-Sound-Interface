module synthesizer(	input CLOCK_50, reset,
					input AUD_BCLK, AUD_DACLRCK, output AUD_DACDAT, AUD_XCK,
					inout I2C_SDAT, output I2C_SCLK,
					input [3:0] keycode, output data_request, input data_ready);

// Key codes to map to the notes
localparam	key1 = 1,
			key2 = 2,
			key3 = 3,
			key4 = 4,
			key5 = 5,
			key6 = 6,
			key7 = 7;

// Sound duration in clocks
localparam snd_len = 100000000;

wire [6:0] note; // One-hot note value
wire play_done;

assign play_done = (dur_cnt == snd_len);

// Select which note to play
assign note =	(keycode == key1) ? 1:
				(keycode == key2) ? 2:
				(keycode == key3) ? 4:
				(keycode == key4) ? 8:
				(keycode == key5) ? 16:
				(keycode == key6) ? 32:
				(keycode == key7) ? 64:0;

// Duration counter

reg [31:0] dur_cnt;

always @(posedge CLOCK_50)
	if(reset || st == st_play_start) dur_cnt <= 0;
	else if(!play_done) dur_cnt <= dur_cnt + 1;


// Handshaking state machine

localparam st_datarq = 0, st_play_start = 1, st_play = 2, st_play_done = 3;

reg [1:0] st;

always @(posedge CLOCK_50)
	if(reset) st <= st_datarq;
	else
		case(st)
			st_datarq: if(data_ready) st <= (note != 0) ? st_play_start : st_play_done;	// Raise data_request and wait for data_ready, check if the key was valid
			st_play_start: st <= st_play;												// Clear the counter and start playing
			st_play: st <= (play_done || !data_ready) ? st_play_done : st_play;			// Keep playing... data_request stays on
			st_play_done: st <= data_ready ? st_play_done : st_datarq;					// Done, deassert data request and wait for data ready to go down
		endcase

assign data_request = (st != st_play_done);



// Internal modules

wire [15:0] aud_data;
reg olrck;

always @(posedge CLOCK_50) olrck <= AUD_DACLRCK;

Audio_Controller Audio_Controller (
	// Inputs
	.CLOCK_50					(CLOCK_50),
	.reset						(reset),

	.left_channel_audio_out		({aud_data, 16'b0}),
	.right_channel_audio_out	({aud_data, 16'b0}),
	.write_audio_out			((olrck ^ AUD_DACLRCK) && !AUD_DACLRCK),

	// Bidirectionals
	.AUD_BCLK					(AUD_BCLK),
	.AUD_DACLRCK				(AUD_DACLRCK),

	.I2C_SDAT					(I2C_SDAT),

	.AUD_XCK					(AUD_XCK),
	.AUD_DACDAT					(AUD_DACDAT),

	.I2C_SCLK					(I2C_SCLK)
);

generator gen(.lrck(AUD_DACLRCK), .reset_n(!reset), .data(aud_data), .note((play_done || !data_ready) ? 7'h00:note));

endmodule
