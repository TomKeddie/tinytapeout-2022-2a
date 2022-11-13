`default_nettype none

module uart_tx (
                input  clk,
                input  reset,
                output tx_pin
                );

  wire [7:0]           text [0:35];
  assign text[0] = "1";
  assign text[1] = "6";
  assign text[2] = "a";
  assign text[3] = "o";
  assign text[4] = "D";
  assign text[5] = "N";
  assign text[6] = "g";
  assign text[7] = "M";
  assign text[8] = "1";
  assign text[9] = "9";
  assign text[10] = "i";
  assign text[11] = "d";
  assign text[12] = "x";
  assign text[13] = "S";
  assign text[14] = "z";
  assign text[15] = "C";
  assign text[16] = "e";
  assign text[17] = "S";
  assign text[18] = "5";
  assign text[19] = "c";
  assign text[20] = "s";
  assign text[21] = "i";
  assign text[22] = "f";
  assign text[23] = "f";
  assign text[24] = "r";
  assign text[25] = "M";
  assign text[26] = "x";
  assign text[27] = "5";
  assign text[28] = "G";
  assign text[29] = "6";
  assign text[30] = "d";
  assign text[31] = "D";
  assign text[32] = "9";
  assign text[33] = "U";
  assign text[34] = "\r";
  assign text[35] = "\n";
  
  reg [3:0]            bit_counter;
  reg [5:0]            text_index;
  
  reg                  tx_pin_int;
  assign tx_pin = tx_pin_int;

  always @(posedge clk) begin
    // if reset, set counter to 0
    if (reset) begin
      bit_counter <= 0;
      tx_pin_int  <= 1'b1;
      text_index <= 0;
    end else begin
      // bit counter - START, 8xDATA, STOP, IDLE = 11 bits
      if (bit_counter == 10) begin
        // reset
        bit_counter    <= 0;
        if (text_index == 35) begin
          text_index <= 0;
        end else begin
          text_index <= text_index + 1;
        end
      end else begin
        // increment counter
        bit_counter <= bit_counter + 1;
      end
      case(bit_counter)
        0       : tx_pin_int = 1'b1; // idle
        1       : tx_pin_int = 1'b0; // start
        10      : tx_pin_int = 1'b1; // stop
        default : tx_pin_int = text[text_index][bit_counter-2];
      endcase
    end
  end
endmodule
