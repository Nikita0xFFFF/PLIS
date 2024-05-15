module syst_ws_tb;

  logic clk_i = 0;
  logic rst_i = 1;
  logic [7:0] x1_i;
  logic [7:0] x2_i;
  logic [7:0] x3_i;

  logic [18:0] y1_o;
  logic [18:0] y2_o;

  // Instantiate the syst_ws module
  syst_ws DUT (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .x1_i(x1_i),
    .x2_i(x2_i),
    .x3_i(x3_i),
    .y1_o(y1_o),
    .y2_o(y2_o)
  );

  // Clock generation
initial forever #(10) clk_i ++;
initial #(100) rst_i = 0;
  // Initial stimulus
  initial begin

    x1_i = 8'd10;
    x2_i = 8'd20;
    x3_i = 8'd30;

    wait (!rst_i);
    

    #100 
    $finish;
  end

endmodule