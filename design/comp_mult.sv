module comp_mult (
    input clk,
    input rst_n,

    input logic [15:0] a,
    b,
    c,
    d,

    output logic [15:0] w,
    x,
    input logic i_valid,
    output logic o_valid,
    output logic signed [31:0] y,
    z

);


  logic [31:0] s1_p1, s1_p2, s1_p3, s1_w, s1_x, s1_valid;
  logic [31:0] s2_y, s2_z, s2_w, s2_x, s2_valid;

  always_ff @(posedge clk) begin : stage_1
    if (~rst_n) begin
      s1_p1 <= 0;
      s1_p2 <= 0;
      s1_p3 <= 0;
      s1_w <= 0;
      s1_x <= 0;
      s1_valid <= 0;
    end else begin
      s1_p1 <= (a + b) * (c + d);
      s1_p2 <= a * c;
      s1_p3 <= b * d;

      s1_w <= a + c;
      s1_x <= b + d;

      s1_valid <= i_valid;
    end
  end

  always_ff @(posedge clk) begin : stage_2
    if (~rst_n) begin
      s2_valid <= 0;
      s2_y <= 0;
      s2_z <= 0;
      s2_w <= 0;
      s2_x <= 0;
    end else begin
      s2_valid <= s1_valid;
      s2_y <= s1_p2 - s1_p3;
      s2_z <= s1_p1 - s1_p2 - s1_p3;

      s2_x <= s1_x;
      s2_w <= s1_w;
    end
  end


  always_comb begin : output_stage
    y = s2_y;
    z = s2_z;

    w = s2_w;
    x = s2_x;

    o_valid = s2_valid;
  end

endmodule : comp_mult
