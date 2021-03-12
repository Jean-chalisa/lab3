`default_nettype none

module BCDtoSevenSegment (input logic [3:0] bcd,
                          output logic [6:0] segment);


  always_comb
    unique case (bcd[3:0])
      4'b0000: segment = 7'b100_0000;
      4'b0001: segment = 7'b111_1001;
      4'b0010: segment = 7'b010_0100;
      4'b0011: segment = 7'b011_0000;
      4'b0100: segment = 7'b001_1001;
      4'b0101: segment = 7'b001_0010;
      4'b0110: segment = 7'b000_0010;
      4'b0111: segment = 7'b111_1000;
      4'b1000: segment = 7'b000_0000;
      4'b1001: segment = 7'b001_0000;
      4'b1010: segment = 7'b000_1000;
      4'b1011: segment = 7'b000_0011;
      4'b1100: segment = 7'b100_0110;
      4'b1101: segment = 7'b010_0001;
      4'b1010: segment = 7'b000_0110;
      4'b1111: segment = 7'b000_1110;
    endcase
endmodule: BCDtoSevenSegment

module SevenSegmentDigit (input logic [3:0] bcd,
                          output logic [6:0] segment, 
                          input logic blank);
  logic [6:0] decoded;
  
  BCDtoSevenSegment b2ss(.bcd(bcd), .segment(decoded)); 
  // obtain for a specific digit
  always_comb begin
    if (blank)
      segment = 7'b111_1111; // want blanks and 1 is off
    else
      segment = decoded;
  end

endmodule: SevenSegmentDigit

module SevenSegmentControl
  (output logic [6:0] HEX9, HEX8, HEX7, HEX6, HEX5,
   output logic [6:0] HEX4, HEX3, HEX2, HEX1, HEX0, 
   input logic [3:0] BCD9, BCD8, BCD7, BCD6, BCD5, 
   input logic [3:0] BCD4, BCD3, BCD2, BCD1, BCD0, 
   input logic [9:0] turn_on);
  
  // instantiate for 10 digits
  SevenSegmentDigit SSD0 (.bcd(BCD0), .segment(HEX0), .blank(turn_on[9]));
  SevenSegmentDigit SSD1 (.bcd(BCD1), .segment(HEX1), .blank(turn_on[8]));
  SevenSegmentDigit SSD2 (.bcd(BCD2), .segment(HEX2), .blank(turn_on[7]));
  SevenSegmentDigit SSD3 (.bcd(BCD3), .segment(HEX3), .blank(turn_on[6]));
  SevenSegmentDigit SSD4 (.bcd(BCD4), .segment(HEX4), .blank(turn_on[5]));
  SevenSegmentDigit SSD5 (.bcd(BCD5), .segment(HEX5), .blank(turn_on[4]));
  SevenSegmentDigit SSD6 (.bcd(BCD6), .segment(HEX6), .blank(turn_on[3]));
  SevenSegmentDigit SSD7 (.bcd(BCD7), .segment(HEX7), .blank(turn_on[2]));
  SevenSegmentDigit SSD8 (.bcd(BCD8), .segment(HEX8), .blank(~turn_on[1]));
  SevenSegmentDigit SSD9 (.bcd(BCD9), .segment(HEX9), .blank(~turn_on[0]));

endmodule: SevenSegmentControl

module ChipInterface
  (output logic [6:0] HEX9, HEX8, HEX7, HEX6, HEX5,
   output logic [6:0] HEX4, HEX3, HEX2, HEX1, HEX0,
   input logic [17:0] SW, input logic [3:0] KEY);
  
  logic [39:0] temp;
  logic [3:0] counter;
  SevenSegmentControl ssc(.HEX9, .HEX8, .HEX7, .HEX6, .HEX5,
                          .HEX4, .HEX3, .HEX2, .HEX1, .HEX0, 
                          .BCD9(temp[39:36]), 
                          .BCD8(temp[35:32]), 
                          .BCD7(temp[31:28]), 
                          .BCD6(temp[27:24]),
                          .BCD5(temp[23:20]),
                          .BCD4(temp[19:16]), 
                          .BCD3(temp[15:12]), 
                          .BCD2(temp[11:8]), 
                          .BCD1(temp[7:4]), 
                          .BCD0(temp[3:0]), 
                          .turn_on(SW[17:8]));


  always_comb begin
    // declares the base case of a looped default value
    temp[39:0] = {SW[7:4], SW[7:4], SW[7:4], SW[7:4], SW[7:4], 
                  SW[7:4], SW[7:4], SW[7:4], SW[7:4], SW[7:4]};
    // choose which 4 bits to change based on the key
    case (KEY[3:0])
      4'b1111: temp[3:0] = SW[3:0];
      4'b1110: temp[7:4] = SW[3:0];
      4'b1101: temp[11:8] = SW[3:0];
      4'b1100: temp[15:12] = SW[3:0];
      4'b1011: temp[19:16] = SW[3:0];
      4'b1010: temp[23:20] = SW[3:0];
      4'b1001: temp[27:24] = SW[3:0];
      4'b1000: temp[31:28] = SW[3:0];
      4'b0111: temp[35:32] = SW[3:0];
      4'b0110: temp[39:36] = SW[3:0];
    endcase
  end


endmodule: ChipInterface



module SevenSegmentDigit_test ();

  logic [3:0] bcd;
  logic [6:0] segment;
  logic blank;

  SevenSegmentDigit DUT (.bcd, .segment, .blank);


  initial begin
  $monitor ($time,, "bcd = %b, segment = %b", bcd, segment);
  for (bcd = 4'b0; bcd < 4'b1010; bcd++)
    #10;
  #10 $finish;
  end
endmodule:SevenSegmentDigit_test
