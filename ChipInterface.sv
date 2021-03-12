module ChipInterface

(input logic [17:0] SW,
output logic [17:0] LEDR,
output logic [7:0] LEDG,
output logic [6:0] HEX9, HEX8, HEX7, HEX6, HEX5,
                   HEX4, HEX3, HEX2, HEX1, HEX0);
  
  logic [12:0] inCode;
  logic [12:0] outCode;
  logic is1BitErr;
  logic is2BitErr;
  
  assign inCode = SW[12:0];
  assign outCode = LEDR[12:0]; //red LED
  assign syndrome = LEDG[7:4]; //green LED
  assign is1BitErr = LEDG[0];
  assign is2BitErr = LEDG[1];
  
  assign inData = {inCode[12], inCode[11], inCode[10],
                 inCode[9], inCode[7], inCode[6],
                   inCode[5], inCode[3]};
  
  assign outData = {outCode[12], outCode[11], outCode[10],
                    outCode[9], outCode[7], outCode[6],
                    outCode[5], outCode[3]);

  SECDEDdecoder dec(.inCode, .syndrome,
                    .is1BitErr, .is2BitErr, outCode);
                 
  SevenSegmentControl
  

//not done
