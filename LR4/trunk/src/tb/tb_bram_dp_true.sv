module tb_bram_dp_true();

  localparam RAM_WIDTH     = 8;
  localparam RAM_ADDR_BITS = 10;
  localparam STOP = 10;

  logic                     clk_i = 1;
  logic [RAM_ADDR_BITS-1:0] addr_a_i;
  logic [RAM_ADDR_BITS-1:0] addr_b_i;
  logic [RAM_WIDTH-1:0]     data_a_i;
  logic [RAM_WIDTH-1:0]     data_b_i;
  logic                     we_a_i;
  logic                     we_b_i;
  logic                     en_a_i;
  logic                     en_b_i;
  logic                     rst_i = 1;
  logic [RAM_WIDTH-1:0]     data_a_o;
  logic [RAM_WIDTH-1:0]     data_b_o;

  initial forever #(10) clk_i++;
  initial #(100) rst_i = 0;

  logic[STOP-1:0] i = 0;
  logic[STOP-1:0] j = 0;
  initial begin
    addr_a_i <= 0;
    addr_b_i <= 0;
    data_a_i <= 0;
    data_b_i <= 0;
    we_a_i   <= 0;
    we_b_i   <= 0;
    en_a_i   <= 0;
    en_b_i   <= 0;

    wait(!rst_i);
    en_a_i   <= 1;
    en_b_i   <= 1;
    repeat (1)  @(posedge clk_i);

    for (i = 0; i < STOP; i++ ) begin
      we_a_i   <= 1;
      we_b_i   <= 1;
      data_b_i <= data_b_i + 10;
      data_a_i <= data_a_i + 5;
      repeat (2) @(posedge  clk_i);
      we_b_i   <= 0;
      repeat (2) @(negedge clk_i);
      we_a_i   <= 0;
      we_b_i   <= 1;
      repeat (1) @(negedge  clk_i);
      we_a_i   <= 1;
      addr_b_i <= addr_b_i + 1;
      addr_a_i <= addr_a_i + 1;
    end
    
  end

  bram_dp_true #(
    .RAM_WIDTH(RAM_WIDTH),
    .RAM_ADDR_BITS(RAM_ADDR_BITS)
  ) bram_dp_true_instance(
    .clk_i(clk_i),
    .addr_a_i(addr_a_i),
    .addr_b_i(addr_b_i),
    .data_a_i(data_a_i),
    .data_b_i(data_b_i),
    .we_a_i(we_a_i),
    .we_b_i(we_b_i),
    .en_a_i(en_a_i),
    .en_b_i(en_b_i),
    .rst_i(rst_i),
    .data_a_o(data_a_o),
    .data_b_o(data_b_o)
  );
endmodule