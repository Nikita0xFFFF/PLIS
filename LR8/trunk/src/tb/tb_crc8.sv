import crc_pkg::*;
module tb_crc8;
  logic        p_clk_i;
  logic        p_rst_i;
  logic [31:0] p_dat_i;
  logic [31:0] p_dat_o;
  logic        p_enable_i;
  logic        p_sel_i;
  logic        p_we_i;
  logic [31:0] p_adr_i;
  logic        p_ready;

  //CLK PERIOD
  initial begin
    p_clk_i=1;
    forever #50 p_clk_i = ~p_clk_i; // Сигнал инвертируется каждые 50нс
  end

  wrapper_crc8
  dut_wrapper_crc8
  (
    .p_clk_i    (p_clk_i),
    .p_rst_i    (p_rst_i),
    .p_dat_i    (p_dat_i),
    .p_dat_o    (p_dat_o),
    .p_enable_i (p_enable_i),
    .p_sel_i    (p_sel_i),
    .p_we_i     (p_we_i),
    .p_adr_i    (p_adr_i),
    .p_ready    (p_ready)
  );
  
  initial
  begin
    p_dat_i    = 'hz;
    p_enable_i = 0;
    p_sel_i    = 0;
    p_we_i     = 'hz;
    p_adr_i    = 'hz;
    p_rst_i    = 1;
    #200
    p_rst_i    = 0; // Запись #200 обозначает что смена значения сигнала сброса произойдет через 200нс.
  end

  //Input data
  initial
  begin
    write_register(write_crc8, 32'hAA);
    #1200 write_register(write_crc8, 32'h33);
    #1200 read_register(read_crc8);
    
    write_register(write_crc15, 32'hAA);
    #1200 write_register(write_crc15, 32'h33);
    #1200 read_register(read_crc15);
  end

  //Write
  task write_register; // Название task
    input [31:0] reg_addr; // Параметры передаваемые в task, в нашем случае адрес и данные
    input [31:0] reg_data;

    begin
      @ (posedge p_clk_i); // Ожидаем один такт

      // Формируем посылку согласно документации на APB
      p_adr_i    = reg_addr; // Выставляем значения на шины адреса и данных
      p_dat_i    = reg_data;
      p_enable_i = 0;
      p_sel_i    = 1;
      p_we_i     = 1;

      @ (posedge p_clk_i); // Ожидаем один такт

      p_enable_i = 1;

      wait (p_ready); // Ожидаем появление сигнала p_ready

      // Вывод информации о совершенной операции
      $display("(%0t) Writing register [%0d] = 0x%0x", $time, p_adr_i, reg_data);
      @ (posedge p_clk_i);

      // Возвращаем сигналы в исходное состояние
      p_adr_i    = 'hz;
      p_dat_i    = 'hz;
      p_enable_i = 0;
      p_sel_i    = 0;
      p_we_i     = 'hz;
    end
  endtask

  //READ
  task read_register;
    input [31:0] reg_addr;
    begin
      @ (posedge p_clk_i);

      p_adr_i    = reg_addr;
      p_enable_i = 0;
      p_sel_i    = 1;
      p_we_i     = 0;

      @ (posedge p_clk_i);

      p_enable_i = 1;

      wait (p_ready);

      $display("(%0t) Reading register [%0d] = 0x%0x", $time, p_adr_i, p_dat_o);

      @ (posedge p_clk_i);

      p_adr_i    = 'hz;
      p_enable_i = 0;
      p_sel_i    = 0;
      p_we_i     = 'hz;
    end
  endtask

endmodule : tb_crc8
