`default_nettype none

module SECDEDdecoder (input  logic [12:0] inCode,
                      output logic [3:0] syndrome,
                      output logic is1BitErr, is2BitErr, 
                      output logic [12:0] outCode);



endmodule:  SECDEDdecoder

module makeSyndrome (input  logic [12:0] codeWord,
                     output logic [3:0] syndrome);

  assign syndrome[0] = codeWord[1] ^ codeWord[3] ^ codeWord[5] ^ codeWord[7] ^
                       codeWord[9] ^ codeWord[11];
                       
  assign syndrome[1] = codeWord[2] ^ codeWord[3] ^ codeWord[6] ^ codeWord[7] ^
                       codeWord[10] ^ codeWord[11];

  assign syndrome[2] = codeWord[4] ^ codeWord[5] ^ codeWord[6] ^ codeWord[7] ^
                       codeWord[12] ^ codeWord[13];
                       
  assign syndrome[3] = codeWord[8] ^ codeWord[9] ^ codeWord[10] ^ codeWord[11] ^
                       codeWord[12] ^ codeWord[13];
                       

endmodule: makeSyndrome


module makeCorrect (input  logic [12:0] codeWord,
                    input  logic [3:0] syndrome,
                    output logic [12:0] correctCodeWord);


endmodule:makeCorrect

module ComparatorIsErr
  (input [12:0] A,
   input [12:0] B,
   output is1BitErr,
   output is2BitErr);
   
   logic [12:0] compare;

   xor comp(compare, A, B);

   if (AeqB = (A == B))
     begin
       assign is1BitErr = 0;
       assign is2BitErr = 0; 
     end;
   



endmodule : Comparator