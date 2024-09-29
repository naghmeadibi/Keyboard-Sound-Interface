module generator (
	lrck,
	reset_n,
	note,
	
	data);

	
	input	lrck, reset_n;
	input [6:0] note;
	output	[15:0] data;
	
	reg [8:0]	address_c3;
	reg [8:0]	address_d3;
	reg [8:0]	address_e3;
	reg [8:0]	address_f3;
	reg [8:0]	address_g3;
	reg [8:0]	address_a3;
	reg [8:0]	address_b3;
	
	wire [15:0] value_c3;
	wire [15:0] value_d3;
	wire [15:0] value_e3;
	wire [15:0] value_f3;
	wire [15:0] value_g3;
	wire [15:0] value_a3;
	wire [15:0] value_b3;

	assign data		= 	note[6] ? value_c3 :
						note[5] ? value_d3 :
						note[4] ? value_e3 :
						note[3] ? value_f3 :
						note[2] ? value_g3 :
						note[1] ? value_a3 :
						note[0] ? value_b3 :
						16'b0; // silent by default

	always @(negedge lrck or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			address_c3 <= 9'h00;
		else
		begin
			if (address_c3 != 9'd372)
				address_c3 <= address_c3 + 1'b1;
			else
				address_c3 <= 9'h00;
		end
	end

	always @(negedge lrck or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			address_d3 <= 9'h00;
		else
		begin
			if (address_d3 != 9'd331)
				address_d3 <= address_d3 + 1'b1;
			else
				address_d3 <= 9'h00;
		end
	end

	always @(negedge lrck or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			address_e3 <= 9'h00;
		else
		begin
			if (address_e3 != 9'd295)
				address_e3 <= address_e3 + 1'b1;
			else
				address_e3 <= 9'h00;
		end
	end

	always @(negedge lrck or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			address_f3 <= 9'h00;
		else
		begin
			if (address_f3 != 9'd279)
				address_f3 <= address_f3 + 1'b1;
			else
				address_f3 <= 9'h00;
		end
	end

	always @(negedge lrck or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			address_g3 <= 9'h00;
		else
		begin
			if (address_g3 != 9'd248)
				address_g3 <= address_g3 + 1'b1;
			else
				address_g3 <= 9'h00;
		end
	end

	always @(negedge lrck or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			address_a3 <= 9'h00;
		else
		begin
			if (address_a3 != 9'd221)
				address_a3 <= address_a3 + 1'b1;
			else
				address_a3 <= 9'h00;
		end
	end

	always @(negedge lrck or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			address_b3 <= 9'h00;
		else
		begin
			if (address_b3 != 9'd197)
				address_b3 <= address_b3 + 1'b1;
			else
				address_b3 <= 9'h00;
		end
	end

	
lpm_rom0 ROM (
	.address (address_c3),
	.clock (lrck),
	.q (value_c3));
	defparam ROM.lpm_file="sinc3.mif";

lpm_rom0 ROMd3 (
	.address (address_d3),
	.clock (lrck),
	.q (value_d3));
	defparam ROMd3.lpm_file="sind3.mif";
	
lpm_rom0 ROMe3 (
	.address (address_e3),
	.clock (lrck),
	.q (value_e3));
	defparam ROMe3.lpm_file="sine3.mif";

lpm_rom0 ROMf3 (
	.address (address_f3),
	.clock (lrck),
	.q (value_f3));
	defparam ROMf3.lpm_file="sinf3.mif";

lpm_rom0 ROMg3 (
	.address (address_g3),
	.clock (lrck),
	.q (value_g3));
	defparam ROMg3.lpm_file="sing3.mif";

lpm_rom0 ROMa3 (
	.address (address_a3),
	.clock (lrck),
	.q (value_a3));
	defparam ROMa3.lpm_file="sina3.mif";
	
lpm_rom0 ROMb3 (
	.address (address_b3),
	.clock (lrck),
	.q (value_b3));
	defparam ROMb3.lpm_file="sinb3.mif";
	
	
endmodule
