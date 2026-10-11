module axi_comp_mult (
    input clk,
    input rst_n,

    input TVALID,
    output logic TREADY,
    input [63:0] TDATA,
    input TLAST
);

  logic o_valid;

  logic [15:0] a, b, c, d;

  logic [15:0] w, x;

  logic signed [31:0] y, z;



  always_comb begin

    // for now
    TREADY = 1;

    a = TVALID ? TDATA[15:0] : 0;
    b = TVALID ? TDATA[31:16] : 0;
    c = TVALID ? TDATA[47:32] : 0;
    d = TVALID ? TDATA[63:48] : 0;
  end


  comp_mult multipllier (

      .clk  (clk),
      .rst_n(rst_n),

      .a(a),
      .b(b),
      .c(c),
      .d(d),

      .w(w),
      .x(x),
      .y(y),
      .z(z),

      .i_valid(TVALID),
      .o_valid(o_valid)

  );




endmodule
