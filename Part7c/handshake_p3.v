module handshake_p3(input clock, reset,
					input [3:0] ps2_data, input ps2_en,
					output reg [3:0] sound_code,	// Code for the music box
					input data_rq,		// Data request from music box
					output reg data_rd);		// Data ready for music box


  parameter IDLE = 4'b0001, SEND = 4'b0010, CAPTURE = 4'b0100, WAIT = 4'b1000;

  // declare a state register and a next state 
  reg [3:0] state_reg; 
  reg [3:0] state_next;

  always @(posedge clock) begin  //: state_table

    if (reset) state_reg = IDLE;
    else state_reg = state_next;

    case (state_reg)
      IDLE: begin
        sound_code = 4'b0000;
        data_rd = 1'b0;
        // if the synthesizer requests data, go to CAPTURE state
        if (data_rq) state_next = CAPTURE;
        // else stay in IDLE state
        else state_next = IDLE;
      end
      CAPTURE: begin
        sound_code = ps2_data;
        data_rd = 1'b0;
        // if the PS/2 controller enables data, go to SEND state
        if (ps2_en) state_next = SEND;
        // else stay in CAPTURE state
        else state_next = CAPTURE;
      end
      SEND: begin
        data_rd = 1'b1;
        // if the synthesizer deasserts data request, go to WAIT state
        if (~data_rq) state_next = WAIT;
        // else stay in SEND state
        else state_next = SEND;
      end
      WAIT: begin
        data_rd = 1'b0;
        // if the PS/2 controller deasserts data enable, go to IDLE state
        if (data_rq) state_next = IDLE;
        // else stay in WAIT state
        else state_next = WAIT;
      end
      default: begin 
        state_next = IDLE;
        sound_code = 4'b0000;
        data_rd = 1'b0;
      end
    endcase
  end // state_table


endmodule
