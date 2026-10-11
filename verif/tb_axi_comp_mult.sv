
`timescale 1ps / 1ps

module tb_axi_comp_mult;

  localparam int NUM_PKTS = 16;




  logic clk, rst_n, i_valid, o_valid;
  logic [15:0] a, b, c, d, w, x, sim_w, sim_x;

  logic [31:0] y, z, sim_y, sim_z;

  logic TVALID, TREADY, TLAST;
  logic [63:0] TDATA;

  axi_comp_mult dut (
      .clk  (clk),
      .rst_n(rst_n),

      .TVALID(TVALID),
      .TREADY(TREADY),
      .TDATA (TDATA),
      .TLAST (TLAST)
  );

  // ---------------------------------------------------------------------------
  // Transaction: inputs + expected outputs
  //   (a + jb) + (c + jd) = w + jx
  //   (a + jb) * (c + jd) = y + jz
  // ---------------------------------------------------------------------------
  class packet;
    logic [15:0] a, b, c, d;  // inputs
    logic [15:0] w, x;  // expected sum
    logic [31:0] y, z;  // expected product
    logic valid;

    function void randomize_inputs();
      a = $urandom_range(0, 15);
      b = $urandom_range(0, 15);
      c = $urandom_range(0, 15);
      d = $urandom_range(0, 15);
      valid = $urandom_range(0, 1);
    endfunction

    function void calc();
      w = a + c;
      x = b + d;
      y = a * c - b * d;
      z = a * d + b * c;
    endfunction
  endclass

  mailbox #(packet) gen2scb = new();
  int errors = 0;

  // ---------------------------------------------------------------------------
  // gen: drive a new input every clock and send the expected result to scb
  // ---------------------------------------------------------------------------
  task automatic gen();
    packet p;
    for (int i = 0; i < NUM_PKTS; i++) begin
      p = new();
      p.randomize_inputs();
      p.calc();

      @(posedge clk);
      TVALID = p.valid;
      TDATA = {p.d, p.c, p.b, p.a};
      a = p.valid ? p.a : 0;
      b = p.valid ? p.b : 0;
      c = p.valid ? p.c : 0;
      d = p.valid ? p.d : 0;

      sim_w = p.valid ? p.w : 0;
      sim_x = p.valid ? p.x : 0;
      sim_y = p.valid ? p.y : 0;
      sim_z = p.valid ? p.z : 0;

      gen2scb.put(p);
    end
    // @(posedge clk);
    // i_valid <= 0;
  endtask

  // ---------------------------------------------------------------------------
  // scb: on every clock where o_valid is 1, compare DUT outputs to the next packet
  // ---------------------------------------------------------------------------
  task automatic scb();
    packet p;
    int checked = 0;
    while (checked < NUM_PKTS) begin
      @(posedge clk);
      if (~dut.o_valid) continue;

      gen2scb.get(p);
      assert (dut.w === p.w)
      else begin
        errors++;
        $error("w mismatch: a=%0d c=%0d | got %0d exp %0d", p.a, p.c, dut.w, p.w);
      end

      assert (dut.x === p.x)
      else begin
        errors++;
        $error("x mismatch: b=%0d d=%0d | got %0d exp %0d", p.b, p.d, dut.x, p.x);
      end

      assert (dut.y === p.y)
      else begin
        errors++;
        $error("y mismatch: a=%0d b=%0d c=%0d d=%0d | got %0d exp %0d", p.a, p.b, p.c, p.d,
               $signed(dut.y), $signed(p.y));
      end

      assert (dut.z === p.z)
      else begin
        errors++;
        $error("z mismatch: a=%0d b=%0d c=%0d d=%0d | got %0d exp %0d", p.a, p.b, p.c, p.d,
               $signed(dut.z), $signed(p.z));
      end
      checked++;
    end
  endtask

  initial begin
    clk    = 0;
    rst_n  = 0;
    TVALID = 0;
    TLAST  = 0;
    @(posedge clk) rst_n <= 1;

    fork
      gen();
      scb();
    join

    repeat (3) @(posedge clk);
    $finish;
  end

  always begin
    #5 clk = ~clk;
  end

endmodule
