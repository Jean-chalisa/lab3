`default_nettype none

module SECDEDdecoder (input  logic [12:0] inCode,
                      output logic [3:0] syndrome,
                      output logic is1BitErr, is2BitErr,
                      output logic [12:0] outCode);


  makeSyndrome dut1 (.codeWord(inCode), .*);

  makeCorrect dut2 ( .codeWord(inCode), .syndrome(syndrome),
                   .correctCodeWord(outCode));

  errorCheck dut3 (.*);


endmodule:  SECDEDdecoder


module makeSyndrome (input  logic [12:0] codeWord,
                     output logic [3:0] syndrome);

  assign syndrome[0] = codeWord[1] ^ codeWord[3] ^ codeWord[5] ^ codeWord[7] ^
                       codeWord[9] ^ codeWord[11];

  assign syndrome[1] = codeWord[2] ^ codeWord[3] ^ codeWord[6] ^ codeWord[7] ^
                       codeWord[10] ^ codeWord[11];

  assign syndrome[2] = codeWord[4] ^ codeWord[5] ^ codeWord[6] ^ codeWord[7] ^
                       codeWord[12];

  assign syndrome[3] = codeWord[8] ^ codeWord[9] ^ codeWord[10] ^ codeWord[11] ^
                       codeWord[12];


endmodule: makeSyndrome


module makeCorrect (input  logic [12:0] codeWord,
                    input  logic [3:0] syndrome,
                    output logic [12:0] correctCodeWord);

  logic PGfail;

  assign PGfail = ^codeWord;

  always_comb begin

  correctCodeWord = codeWord;

  if (PGfail === 1 && syndrome !== 4'b0000)
    correctCodeWord[syndrome] = ~codeWord[syndrome];

  else if (PGfail === 1 && syndrome === 4'b0000)
    correctCodeWord[0] = ~codeWord[0];

  end


endmodule:makeCorrect


module errorCheck

  (input logic [12:0] inCode,
   input logic [3:0] syndrome,
   output logic is1BitErr,
   output logic is2BitErr);

  logic isOdd, GPfail;

  assign isOdd = ^inCode;  //if it is odd PG is correct
  assign GPfail = isOdd;  //if it is even, PG fails

  always_comb begin
  
  is1BitErr = 0;
  is2BitErr = 0;
  
    if (~GPfail && syndrome === 4'b0000)
      begin
        is1BitErr = 0;
        is2BitErr = 0;
      end
    else if (GPfail) // 1 bit error, either in the GP or normal bit
      begin
        is1BitErr = 1;
        is2BitErr = 0;
      end
    else if (~GPfail && syndrome !== 4'b0000)  // 2bits errors
      begin
        is1BitErr = 0;
        is2BitErr = 1;
    end
  end

endmodule : errorCheck


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
      4'b1110: segment = 7'b000_0110;
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
   input logic [3:0] BCD4, BCD3, BCD2, BCD1, BCD0);
  

  logic turn_on;
  assign turn_on = 0;
  // instantiate for 10 digits
  SevenSegmentDigit SSD0 (.bcd(BCD0), .segment(HEX0), .blank(turn_on));
  SevenSegmentDigit SSD1 (.bcd(BCD1), .segment(HEX1), .blank(turn_on));
  SevenSegmentDigit SSD2 (.bcd(BCD2), .segment(HEX2), .blank(turn_on));
  SevenSegmentDigit SSD3 (.bcd(BCD3), .segment(HEX3), .blank(turn_on));
  SevenSegmentDigit SSD4 (.bcd(BCD4), .segment(HEX4), .blank(~turn_on)); //not used
  SevenSegmentDigit SSD5 (.bcd(BCD5), .segment(HEX5), .blank(~turn_on)); //not used
  SevenSegmentDigit SSD6 (.bcd(BCD6), .segment(HEX6), .blank(turn_on));
  SevenSegmentDigit SSD7 (.bcd(BCD7), .segment(HEX7), .blank(turn_on));
  SevenSegmentDigit SSD8 (.bcd(BCD8), .segment(HEX8), .blank(turn_on));
  SevenSegmentDigit SSD9 (.bcd(BCD9), .segment(HEX9), .blank(turn_on));

endmodule: SevenSegmentControl




  





   



