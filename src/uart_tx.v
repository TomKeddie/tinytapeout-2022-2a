`default_nettype none

module uart_tx (
                input  clk,
                input  reset,
                output tx_pin0,
                output tx_pin1,
                );

  wire [7:0]           text0 [0:36];
  wire [7:0]           text1 [0:36];

  assign text0[0] = "T";
  assign text0[1] = "i";
  assign text0[2] = "n";
  assign text0[3] = "y";
  assign text0[4] = "T";
  assign text0[5] = "a";
  assign text0[6] = "p";
  assign text0[7] = "e";
  assign text0[8] = "o";
  assign text0[9] = "u";
  assign text0[10] = "t";
  assign text0[11] = " ";
  assign text0[12] = "N";
  assign text0[13] = "o";
  assign text0[14] = "v";
  assign text0[15] = "e";
  assign text0[16] = "m";
  assign text0[17] = "b";
  assign text0[18] = "e";
  assign text0[19] = "r";
  assign text0[20] = " ";
  assign text0[21] = "2";
  assign text0[22] = "0";
  assign text0[23] = "2";
  assign text0[24] = "2";
  assign text0[25] = " ";
  assign text0[26] = "T";
  assign text0[27] = "o";
  assign text0[28] = "m";
  assign text0[29] = "K";
  assign text0[30] = "e";
  assign text0[31] = "d";
  assign text0[32] = "d";
  assign text0[33] = "i";
  assign text0[34] = "e";
  assign text0[35] = "\r";
  assign text0[36] = "\n";
  
  assign text1[0] = "1";
  assign text1[1] = "6";
  assign text1[2] = "a";
  assign text1[3] = "o";
  assign text1[4] = "D";
  assign text1[5] = "N";
  assign text1[6] = "g";
  assign text1[7] = "M";
  assign text1[8] = "1";
  assign text1[9] = "9";
  assign text1[10] = "i";
  assign text1[11] = "d";
  assign text1[12] = "x";
  assign text1[13] = "S";
  assign text1[14] = "z";
  assign text1[15] = "C";
  assign text1[16] = "e";
  assign text1[17] = "S";
  assign text1[18] = "5";
  assign text1[19] = "c";
  assign text1[20] = "s";
  assign text1[21] = "i";
  assign text1[22] = "f";
  assign text1[23] = "f";
  assign text1[24] = "r";
  assign text1[25] = "M";
  assign text1[26] = "x";
  assign text1[27] = "5";
  assign text1[28] = "G";
  assign text1[29] = "6";
  assign text1[30] = "d";
  assign text1[31] = "D";
  assign text1[32] = "9";
  assign text1[33] = "U";
  assign text1[34] = " ";
  assign text1[35] = "\r";
  assign text1[36] = "\n";
  
  reg [3:0]            bit_counter;
  reg [5:0]            text_index;
  
  reg                  tx_pin0_int;
  reg                  tx_pin1_int;
  assign tx_pin0 = tx_pin0_int;
  assign tx_pin1 = tx_pin1_int;

  always @(posedge clk) begin
    // if reset, set counter to 0
    if (reset) begin
      bit_counter <= 0;
      tx_pin0_int  <= 1'b1;
      tx_pin1_int  <= 1'b1;
      text_index <= 0;
    end else begin
      // bit counter - START, 8xDATA, STOP, IDLE = 11 bits
      if (bit_counter == 10) begin
        // reset
        bit_counter    <= 0;
        if (text_index == 36) begin
          text_index <= 0;
        end else begin
          text_index <= text_index + 1;
        end
      end else begin
        // increment counter
        bit_counter <= bit_counter + 1;
      end
      case(bit_counter)
        0       : begin
          tx_pin0_int = 1'b1; // idle
          tx_pin1_int = 1'b1; // idle
        end
        1       : begin
          tx_pin0_int = 1'b0; // start
          tx_pin1_int = 1'b0; // start
        end
        10      : begin
          tx_pin0_int = 1'b1; // stop
          tx_pin1_int = 1'b1; // stop
        end
        default : begin
          tx_pin0_int = text0[text_index][bit_counter-2];
          tx_pin1_int = text1[text_index][bit_counter-2];
        end
      endcase
    end
  end
endmodule
