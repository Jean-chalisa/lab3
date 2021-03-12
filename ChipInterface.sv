`default_nettype none

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
  logic [3:0] syndrome;
  logic [3:0] inData0, inData1, outData0, outData1;
  
  assign inCode = SW[12:0];
  assign LEDR[12:0] = outCode; //red LED
  assign LEDG[7:4] = syndrome; //green LED
  assign LEDG[0] = is1BitErr;  //green LED
  assign LEDG[1] = is2BitErr;  //red LED
  
  assign inData1 = {inCode[12], inCode[11], inCode[10],
                    inCode[9]};
  
  assign inData0 = {inCode[7], inCode[6],
                   inCode[5], inCode[3]};
  
  assign outData1 = {outCode[12], outCode[11], outCode[10],
                     outCode[9]};
  
  assign outData0 = {outCode[7], outCode[6],
                    outCode[5], outCode[3]};

  SECDEDdecoder dec(.inCode, .syndrome,
                    .is1BitErr, .is2BitErr, .outCode);
                 
  SevenSegmentControl ssc(.HEX9, .HEX8, .HEX7, .HEX6, .HEX5,
                          .HEX4, .HEX3, .HEX2, .HEX1, .HEX0,
                          .BCD9(inData1), .BCD8(inData0), .BCD7(outData1),
                          .BCD6(outData0), .BCD5(4'b0000), .BCD4(4'b0000),
                          .BCD3(outCode[12]), .BCD2(outCode[11:8]),
                          .BCD1(outCode[7:4]), .BCD0(outCode[3:0]));

                          //hard coded for BCD5 and BCD4
                     
endmodule: ChipInterface
