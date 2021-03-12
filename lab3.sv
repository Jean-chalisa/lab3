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
  logic [12:0] temp;

  assign PGfail = ^codeWord;

  always_comb begin

    correctCodeWord = codeWord;

  if (PGfail === 1 && syndrome !== 4'b0000)
    correctCodeWord[syndrome] = ~codeWord[syndrome];

  else if (PGfail === 1 && syndrome === 4'b0000)
    correctCodeWord[0] = ~codeWord[0];
  
  end

endmodule:makeCorrect

module makeCorrect_test();

  logic [12:0] codeWord, correctCodeWord;
  logic [3:0] syndrome;

  makeSyndrome t1 (.*);
  makeCorrect DUT (.*);

  initial begin
  $monitor($time,,
            "code = %b, syndrome = %b, correctCodeWord= %b",
            codeWord, syndrome, correctCodeWord);

  #5 codeWord = 13'b0000_0000_0000_0;
  #5 codeWord = 13'b0000_0000_0000_1;
  #5 codeWord = 13'b0000_0000_0001_1;
  #5 codeWord = 13'b0000_0000_0001_0; //
  #5 codeWord = 13'b0000_0001_1001_0;
  #5 codeWord = 13'b0000_0001_0101_1; //G0
  #5 codeWord = 13'b0000_0001_0101_0; //PG wrong ->2 bits err
  #5 codeWord = 13'b0000_0000_0111_0; //check again

  #10 $finish;
  end
endmodule:makeCorrect_test


module errorCheck
  (input logic [12:0] inCode,
   input logic [3:0] syndrome,
   output logic is1BitErr,
   output logic is2BitErr);

  logic isEven, PGfail;

  assign isEven = ^inCode;  //if it is even, PG fails
  assign PGfail = isEven;

  always_comb begin
    if (~PGfail && syndrome === 4'b0000)
      begin
        assign is1BitErr = 0;
        assign is2BitErr = 0;
      end
    else if (PGfail) // 1 bit error, either in the PG or normal bit
      begin
         assign is1BitErr = 1;
         assign is2BitErr = 0;
      end
    else if (~PGfail && syndrome !== 4'b0000)  // 2bits errors
      begin
        assign is1BitErr = 0;
        assign is2BitErr = 1;
    end
  end

endmodule : errorCheck



