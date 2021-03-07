`default_nettype none

module SECDEDdecoder (input  logic [12:0] inCode,
                      output logic [3:0] syndrome,
                      output logic is1BitErr, is2BitErr, 
                      output logic [12:0] outCode);


makeSyndrome dut1 (.codeWord(inCode), .*);

makeCorrect dut2 ( .codeWord(inCode), .syndrome(syndrome),
                   .correctCode(corrected));

errorCheck dut2 ( .*)



endmodule:  SECDEDdecoder


module makeSyndrome (input  logic [12:0] codeWord,
                     output logic [3:0] syndrome);

  assign syndrome[0] = codeWord[1] ^ codeWord[3] ^ codeWord[5] ^ codeWord[7] ^
                       codeWord[9] ^ codeWord[11];
                       
  assign syndrome[1] = codeWord[2] ^ codeWord[3] ^ codeWord[6] ^ codeWord[7] ^
                       codeWord[10] ^ codeWord[11]

  assign syndrome[2] = codeWord[4] ^ codeWord[5] ^ codeWord[6] ^ codeWord[7] ^
                       codeWord[12];
                       
  assign syndrome[3] = codeWord[8] ^ codeWord[9] ^ codeWord[10] ^ codeWord[11] ^
                       codeWord[12];
                       

endmodule: makeSyndrome


module makeCorrect (input  logic [12:0] codeWord,
                    input  logic [3:0] syndrome,
                    output logic [12:0] correctCodeWord);

  always_comb begin

  assign correctCodeWord = codeWord;

  //if (inCode[0] === 1 && syndrome !== 4'b0000)
  //  correctCodeWord[syndrome] = ~codeWord[syndrome];

  //else if (inCode[0] === 1 && syndrome === 4'b0000)
  //  assign correctCodeWord[0] = 0;
    
  //else if (inCode[0] === 0 && syndrome !== 4'b0000)
  //  assign correctCodeWord = codeWord;

  end


endmodule:makeCorrect

  
module errorCheck
  (input [12:0] inCode,
   input [3:0] syndrome,
   output is1BitErr,
   output is2BitErr);

  logic isEven, PGfail;

  makeSyndrome DUT (.codeWord(inCode), .syndrome(syndrome));

  assign isEven = ^inCode;  //if it is even, PG fails
  assign PGfail = isEven;

  always_comb begin
    if (~PGfail & syndrome = 0)
      begin
        assign is1BitErr = false;
        assign is2BitErr = false;
      end
    else if (PGfail) // 1 bit error, either in the PG or normal bit
      begin
         assign is1BitErr = true;
         assign is2BitErr = false;
      end
    else if (~PGfail & syndrome != 0):  // 2bits errors
      begin
        assign is1BitErr = false;
        assign is2BitErr = true;
    end
  end

endmodule : errorCheck


logic [12:0] temp;

makeCorrect MC (.codeWord(temp), .*)

if (inCode[0] === 0 && syndrome === 4'b0000)
  assign outCode = inCode;
else if (inCode[0] === 1 && syndrome !== 4'b0000)
  assign temp = inCode[12:0];
  assign is1BitErr = 1;
else if (inCode[0] === 1 && syndrome === 4'b0000)
  assign outCode = inCode;
  assign outCode[0] = 0;
  assign is1BitErr = 1;
else if (inCode[0] === 0 && syndrome !== 4'b0000)
  assign is2BitErr = 1
  assign outCode = inCode;
