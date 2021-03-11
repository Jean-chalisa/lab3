module ChipInterface

(input logic [17:0] SW,
output logic [17:0] LEDR,
output logic [7:0] LEDG,
output logic [6:0] HEX7, HEX6, HEX5, HEX4,
HEX3, HEX2, HEX1, HEX0);
  
  logic [12:0] inCode;
  logic [12:0] outCode;
  logic is1BitErr;
  logic is2BitErr;
  
  assign inCode = SW[12:0];
  assign outCode = LEDR[12:0]; //red LED
  assign syndrome = LEDG[7:4];
  assign is1BitErr = LEDG[0];
  assign is2BitErr = LEDG[1];
  
  
  
//   SevenSegmentControl ssc(.HEX9, .HEX8, .HEX7, .HEX6, .HEX5,
//                           .HEX4, .HEX3, .HEX2, .HEX1, .HEX0,
//                           .BCD9, .BCD8, .BCD7, .BCD6, .BCD5,
//                           .BCD4, .BCD3, .BCD2, .BCD1, .BCD0,
//                           .turn_on(SW[17:8]));
 
  
//not done
