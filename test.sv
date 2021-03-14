module errorCheck_test();

  logic [12:0] inCode;
  logic [3:0] syndrome;
  logic is1BitErr;
  logic is2BitErr;

  makeSyndrome DUT1 (.codeWord(inCode), .syndrome);
  errorCheck DUT2 (.*);

  initial begin
    $monitor($time,, 
             "code = %b, syndrome = %b, 1bitErr = %b, 2bitErr = %b",
              inCode, syndrome, is1BitErr, is2BitErr);

    #5 inCode = 13'b0000_0000_0000_0; // consistent
    #5 inCode = 13'b0000_0000_0000_1; // one bit error, PG wrong
    #5 inCode = 13'b0000_0000_0001_1; // 2 bit err
    #5 inCode = 13'b0000_0000_0001_0; // one bit err, syndrome = 0001
    #5 inCode = 13'b0000_0001_1001_0; // syndrome = 0000, PG wrong
    #5 inCode = 13'b0000_0001_0101_1; // G0
    #5 inCode = 13'b0000_0001_0101_0; // PG wrong ->2 bits err
    #5 inCode = 13'b1111_1111_1111_1; // all ones , 1 bit error, syndrome = 1100

    #20 $finish;
  end

endmodule: errorCheck_test


module SECDEDdecoderTest();

  logic [12:0] inCode; 
  logic [3:0] syndrome;
  logic is1BitErr;
  logic is2BitErr;
  logic [12:0] outCode;

  makeSyndrome dut1 (.codeWord(inCode), .*);

  makeCorrect dut2 ( .codeWord(inCode), .syndrome(syndrome),
                   .correctCodeWord(outCode));

  errorCheck dut3 (.*);

  initial begin
    $monitor($time,, 
             "code = %b, syndrome = %b, 1bitErr = %b, 2bitErr = %b, \
              corrected : %b", 
              inCode, syndrome, is1BitErr, is2BitErr, outCode);

    #5 inCode = 13'b0000_0000_0000_0; //consistent
    #5 inCode = 13'b0000_0000_0000_1; //PG is wrong
    #5 inCode = 13'b0000_0000_0001_1; //2 bit err -> no change
    #5 inCode = 13'b0000_0000_0001_0; //one bit err, bit1 flipped
    #5 inCode = 13'b0000_0001_1001_0; // syndrome = 0000, PG wrong   
    #5 inCode = 13'b0000_0001_0101_0; //PG wrong ->2 bits err ->no changes on outcode
    #5 inCode = 13'b1111_1111_1111_1; //all ones
    #5 inCode = 13'b0000_0000_0101_0; //consistent
    #5 inCode = 13'b0000_0000_0100_0; //data = 1 
    #5 inCode = 13'b0000_0001_0101_1; //G0

    #20 $finish;
  end


endmodule: SECDEDdecoderTest




  





   



