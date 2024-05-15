module tb_mult_dsp;

  

logic                      clk_i;
  logic                      rst_i;
  logic signed [24:0]         a_i;
  logic signed [17:0]         b_i;
  logic signed [42:0]         res_o;

  mult_dsp uut (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .a_i(a_i),
    .b_i(b_i),
    .res_o(res_o)
  );

  always #5 clk_i = ~clk_i; // Generate clock with a period of 10 time units

  initial begin
    clk_i = 0;
    rst_i = 0;
    a_i = 0;
    b_i = 0;

    #10 rst_i = 1; // Release reset after 10 time units

    #20 a_i = 100;
    #10 b_i = 200;

    #20 rst_i = 0; // Apply asynchronous reset after 20 time units from the last input change

    #30 $finish; // End simulation after 30 time units from the asynchronous reset
  end

endmodule