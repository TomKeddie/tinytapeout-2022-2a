`default_nettype none

module uart_tx (
                input  clk,
                input  reset,
                output tx_pin0,
                output tx_pin1,
                output tx_pin2
                );

  wire [7:0]           text0 [0:31];
  wire [7:0]           text1 [0:31];
  wire [7:0]           text2 [0:31];

  // a couple of random things to push out a serial port
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
  assign text0[15] = "2";
  assign text0[16] = "0";
  assign text0[17] = "2";
  assign text0[18] = "2";
  assign text0[19] = " ";
  assign text0[20] = "T";
  assign text0[21] = "o";
  assign text0[22] = "m";
  assign text0[23] = "K";
  assign text0[24] = "e";
  assign text0[25] = "d";
  assign text0[26] = "d";
  assign text0[27] = "i";
  assign text0[28] = "e";
  assign text0[29] = " ";
  assign text0[30] = "\r";
  assign text0[31] = "\n";
  
  assign text1[0] = "O";
  assign text1[1] = "p";
  assign text1[2] = "e";
  assign text1[3] = "n";
  assign text1[4] = " ";
  assign text1[5] = "t";
  assign text1[6] = "h";
  assign text1[7] = "e";
  assign text1[8] = " ";
  assign text1[9] = "p";
  assign text1[10] = "o";
  assign text1[11] = "d";
  assign text1[12] = " ";
  assign text1[13] = "b";
  assign text1[14] = "a";
  assign text1[15] = "y";
  assign text1[16] = " ";
  assign text1[17] = "d";
  assign text1[18] = "o";
  assign text1[19] = "o";
  assign text1[20] = "r";
  assign text1[21] = "s";
  assign text1[22] = ",";
  assign text1[23] = " ";
  assign text1[24] = "H";
  assign text1[25] = "A";
  assign text1[26] = "L";
  assign text1[27] = " ";
  assign text1[28] = " ";
  assign text1[29] = " ";
  assign text1[30] = "\r";
  assign text1[31] = "\n";

  assign text2[0] = "T";
  assign text2[1] = "e";
  assign text2[2] = "d";
  assign text2[3] = " ";
  assign text2[4] = "P";
  assign text2[5] = "a";
  assign text2[6] = "r";
  assign text2[7] = "k";
  assign text2[8] = "e";
  assign text2[9] = "r";
  assign text2[10] = " ";
  assign text2[11] = "2";
  assign text2[12] = "3";
  assign text2[13] = "M";
  assign text2[14] = "a";
  assign text2[15] = "r";
  assign text2[16] = "1";
  assign text2[17] = "9";
  assign text2[18] = "4";
  assign text2[19] = "2";
  assign text2[20] = "-";
  assign text2[21] = "1";
  assign text2[22] = "2";
  assign text2[23] = "A";
  assign text2[24] = "p";
  assign text2[25] = "r";
  assign text2[26] = "1";
  assign text2[27] = "9";
  assign text2[28] = "9";
  assign text2[29] = "5";
  assign text2[30] = "\r";
  assign text2[31] = "\n";

  reg [3:0]            bit_counter;
  reg [4:0]            text_index;
  
  reg                  tx_pin0_int;
  reg                  tx_pin1_int;
  reg                  tx_pin2_int;
  assign tx_pin0 = tx_pin0_int;
  assign tx_pin1 = tx_pin1_int;
  assign tx_pin2 = tx_pin2_int;

  always @(posedge clk) begin
    // if reset, set counter to 0
    if (reset) begin
      bit_counter <= 0;
      tx_pin0_int  <= 1'b1;
      tx_pin1_int  <= 1'b1;
      tx_pin2_int  <= 1'b1;
      text_index <= 0;
    end else begin
      // bit counter - START, 8xDATA, STOP, IDLE = 11 bits
      if (bit_counter == 10) begin
        // reset
        bit_counter    <= 0;
        if (text_index == 31) begin
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
          tx_pin2_int = 1'b1; // idle
        end
        1       : begin
          tx_pin0_int = 1'b0; // start
          tx_pin1_int = 1'b0; // start
          tx_pin2_int = 1'b0; // start
        end
        10      : begin
          tx_pin0_int = 1'b1; // stop
          tx_pin1_int = 1'b1; // stop
          tx_pin2_int = 1'b1; // stop
        end
        default : begin
          tx_pin0_int = text0[text_index][bit_counter-2];
          tx_pin1_int = text1[text_index][bit_counter-2];
          tx_pin2_int = text2[text_index][bit_counter-2];
        end
      endcase
    end
  end
endmodule
