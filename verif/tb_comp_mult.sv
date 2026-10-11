`timescale 1ps / 1ps

module tb_comp_mult;

  localparam int NUM_PKTS = 16;

  logic clk, rst_n, i_valid, o_valid;
  logic [15:0] a, b, c, d, w, x, sim_w, sim_x;

  logic [31:0] y, z, sim_y, sim_z;

  comp_mult dut (
      .clk  (clk),
      .rst_n(rst_n),

      .a(a),
      .b(b),
      .c(c),
      .d(d),

      .w      (w),
      .x      (x),
      .i_valid(i_valid),
      .o_valid(o_valid),
      .y      (y),
      .z      (z)
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

    function void randomize_inputs();
      a = $urandom_range(0, 15);
      b = $urandom_range(0, 15);
      c = $urandom_range(0, 15);
      d = $urandom_range(0, 15);
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
      i_valid <= 1;
      a <= p.a;
      b <= p.b;
      c <= p.c;
      d <= p.d;

      sim_w = p.w;
      sim_x = p.x;
      sim_y = p.y;
      sim_z = p.z;

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
      if (~o_valid) continue;

      gen2scb.get(p);
      assert (w === p.w)
      else begin
        errors++;
        $error("w mismatch: a=%0d c=%0d | got %0d exp %0d", p.a, p.c, w, p.w);
      end

      assert (x === p.x)
      else begin
        errors++;
        $error("x mismatch: b=%0d d=%0d | got %0d exp %0d", p.b, p.d, x, p.x);
      end

      assert (y === p.y)
      else begin
        errors++;
        $error("y mismatch: a=%0d b=%0d c=%0d d=%0d | got %0d exp %0d", p.a, p.b, p.c, p.d,
               $signed(y), $signed(p.y));
      end

      assert (z === p.z)
      else begin
        errors++;
        $error("z mismatch: a=%0d b=%0d c=%0d d=%0d | got %0d exp %0d", p.a, p.b, p.c, p.d,
               $signed(z), $signed(p.z));
      end
      checked++;
    end
  endtask

  initial begin
    clk     = 0;
    rst_n   = 0;
    i_valid = 0;

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
