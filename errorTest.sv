module errorCheck

  (input logic [12:0] inCode,
   input logic [3:0] syndrome,
   output logic is1BitErr,
   output logic is2BitErr);

  logic isOdd, PGfail;

  assign isOdd = ^inCode;  //if it is odd PG is correct
  assign PGfail = ~isOdd;  //if it is even, PG fails

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

    #5 inCode = 13'b0000_0000_0000_0;
    #5 inCode = 13'b0000_0000_0000_1;
    #5 inCode = 13'b0000_0000_0001_1;
    #5 inCode = 13'b0000_0000_0001_0; //
    #5 inCode = 13'b0000_0001_1001_0;
    #5 inCode = 13'b0000_0001_0101_1; //G0
    #5 inCode = 13'b0000_0001_0101_0; //PG wrong ->2 bits err
    #5 inCode = 13'b0000_0000_0111_0; //check again


    #20 $finish;
  end

endmodule: errorCheck_test
  





   



