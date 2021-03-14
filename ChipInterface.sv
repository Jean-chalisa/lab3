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

  // divide each data bits into two four bits so we can represent in hex
  
  assign inData1 = {inCode[12], inCode[11], inCode[10],
                    inCode[9]};
  
  assign inData0 = {inCode[7], inCode[6],
                   inCode[5], inCode[3]};
  
  // do the same for outdata
  assign outData1 = {outCode[12], outCode[11], outCode[10],
                     outCode[9]};
  
  assign outData0 = {outCode[7], outCode[6],
                    outCode[5], outCode[3]};

  SECDEDdecoder dec(.inCode, .syndrome,
                    .is1BitErr, .is2BitErr, .outCode);
                 
  SevenSegmentControl ssc(.HEX9, .HEX8, .HEX7, .HEX6, .HEX5,
                          .HEX4, .HEX3, .HEX2, .HEX1, .HEX0,
                          .BCH9(inData1), .BCH8(inData0), .BCH7(outData1),
                          .BCH6(outData0), .BCH5(4'b0000), .BCH4(4'b0000),
                          .BCH3(outCode[12]), .BCH2(outCode[11:8]),
                          .BCH1(outCode[7:4]), .BCH0(outCode[3:0]));

                          //hard coded for BCH5 and BCH4
                     
endmodule: ChipInterface
