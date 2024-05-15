module tb_pow5_valid();

  localparam  DATA_WIDTH = 8;
  localparam STOP = 10;

  logic clk_i = 1;
  logic rst_i = 1;
  logic [DATA_WIDTH-1:0] pow_data_i;
  logic data_valid_i;
  logic [(5*DATA_WIDTH)-1:0] pow_data_o;
  logic  data_valid_o;

  pow5_pipelined_valid #(
  .DATA_WIDTH(DATA_WIDTH)
  ) pow5_pipelined_valid_instance(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pow_data_i(pow_data_i),
    .data_valid_i(data_valid_i),
    .pow_data_o(pow_data_o),
    .data_valid_o(data_valid_o)
  );
  logic [STOP*2-1:0] count;
  initial forever #(10) clk_i++;
  initial #(100) rst_i = 0;



  initial begin
    pow_data_i <= 0 ;
    data_valid_i <= 0;
    wait(!rst_i);
    for ( count = 0; count <= STOP; count++ )begin
      if(count <= 1 ) begin
        data_valid_i <=1;
      end
      else begin
        data_valid_i <=0;
        repeat (1) @(posedge clk_i);
        count <=0;
      end
      pow_data_i <= pow_data_i + 1 ;
      repeat (4) @(posedge clk_i);
    end
  end

endmodule : tb_pow5_valid
