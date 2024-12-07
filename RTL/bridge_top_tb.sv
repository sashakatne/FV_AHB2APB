module Bridge_Top_tb;

  // Clock and reset signals
  reg Hclk;
  reg Hresetn;

  // Inputs to the Bridge_Top module
  reg Hwrite;
  reg Hreadyin;
  reg [31:0] Hwdata;
  reg [31:0] Haddr;
  reg [31:0] Prdata;
  reg [1:0] Htrans;

  // Outputs from the Bridge_Top module
  wire Penable;
  wire Pwrite;
  wire Hreadyout;
  wire [1:0] Hresp;
  wire [2:0] Pselx;
  wire [31:0] Paddr;
  wire [31:0] Pwdata;
  wire [31:0] Hrdata;

  // Instantiate the Bridge_Top module
  Bridge_Top uut (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .Hwrite(Hwrite),
    .Hreadyin(Hreadyin),
    .Hwdata(Hwdata),
    .Haddr(Haddr),
    .Htrans(Htrans),
    .Prdata(Prdata),
    .Penable(Penable),
    .Pwrite(Pwrite),
    .Pselx(Pselx),
    .Paddr(Paddr),
    .Pwdata(Pwdata),
    .Hreadyout(Hreadyout),
    .Hresp(Hresp),
    .Hrdata(Hrdata)
  );

  // Clock generation
  initial begin
    Hclk = 0;
    forever #5 Hclk = ~Hclk; // 100 MHz clock
  end

  // Reset task
  task apply_reset();
    begin
      @(negedge Hclk);
      Hresetn = 0;
      @(negedge Hclk);
      Hresetn = 1;
    end
  endtask

  // Test procedure
  initial begin
    // Apply reset
    apply_reset();

    // Test Case 1: Single Write Transaction
    test_single_write();

    // Test Case 2: Single Read Transaction
    test_single_read();

    // Test Case 3: Burst Write Transaction
    test_burst_write();

    // Test Case 4: Burst Read Transaction
    test_burst_read();

    // End simulation
    #100;
    $finish;
  end

  // Test cases
  task test_single_write();
    begin
      $display("Starting Single Write Test...");
      Hwrite = 1;
      Hreadyin = 1;
      Haddr = 32'h8000_0000;
      Hwdata = 32'h1234_ABCD;
      Htrans = 2'b10; // NONSEQ

      @(posedge Hclk);
      #1; // Delay to observe signals

      // Check outputs
      if (Penable && Pwrite && Paddr == Haddr && Pwdata == Hwdata) begin
        $display("Single Write Test Passed");
      end else begin
        $display("Single Write Test Failed");
      end

      // Complete the transaction
      @(posedge Hclk);
      Htrans = 2'b00; // IDLE
    end
  endtask

  task test_single_read();
    begin
      $display("Starting Single Read Test...");
      Hwrite = 0;
      Hreadyin = 1;
      Haddr = 32'h8000_0000;
      Htrans = 2'b10; // NONSEQ

      // Provide dummy read data
      Prdata = 32'h5678_1234;

      @(posedge Hclk);
      #1; // Delay to observe signals

      // Check outputs
      if (Penable && !Pwrite && Paddr == Haddr && Hrdata == Prdata) begin
        $display("Single Read Test Passed");
      end else begin
        $display("Single Read Test Failed");
      end

      // Complete the transaction
      @(posedge Hclk);
      Htrans = 2'b00; // IDLE
    end
  endtask

  task test_burst_write();
    begin
      $display("Starting Burst Write Test...");
      Hwrite = 1;
      Hreadyin = 1;
      Haddr = 32'h8000_0000;
      Htrans = 2'b10; // NONSEQ

      for (integer i = 0; i < 4; i = i + 1) begin
        @(posedge Hclk);
        Hwdata = 32'h1000_0000 + i;
        Haddr = Haddr + 4;
        Htrans = 2'b11; // SEQ

        #1; // Delay to observe signals

        // Check outputs during the burst
        if (Paddr != Haddr || Pwdata != Hwdata) begin
          $display("Burst Write Test Failed at Transaction %0d", i);
        end
      end

      // Complete the burst
      @(posedge Hclk);
      Htrans = 2'b00; // IDLE

      $display("Burst Write Test Passed");
    end
  endtask

  task test_burst_read();
    begin
      $display("Starting Burst Read Test...");
      Hwrite = 0;
      Hreadyin = 1;
      Haddr = 32'h8000_0000;
      Htrans = 2'b10; // NONSEQ

      for (integer i = 0; i < 4; i = i + 1) begin
        @(posedge Hclk);
        Prdata = 32'h2000_0000 + i;
        Haddr = Haddr + 4;
        Htrans = 2'b11; // SEQ

        #1; // Delay to observe signals

        // Check outputs during the burst
        if (Paddr != Haddr || Hrdata != Prdata) begin
          $display("Burst Read Test Failed at Transaction %0d", i);
        end
      end

      // Complete the burst
      @(posedge Hclk);
      Htrans = 2'b00; // IDLE

      $display("Burst Read Test Passed");
    end
  endtask

endmodule
