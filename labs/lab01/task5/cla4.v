// cla4.v
// (Carried forward from Task 3 -- paste in your completed, delay-annotated
// version.)
// Gate-level 4-bit carry-lookahead adder, matching the lecture circuit.
// Every gate needs an explicit delay (constant is fine here, e.g. #(2)) --
// this is the default from Task 2 onward, not a special step.
//
// TODO -- Step 1: generate/propagate signals (one xor + one and per bit)
//   p[i] = a[i] ^ b[i]
//   g[i] = a[i] & b[i]
//
// TODO -- Step 2: direct (non-recursive) carry equations. Verilog's and/or
// primitives accept more than 2 inputs directly, e.g.:
//   and #(2) (t2, p1, p0, g0);
// so you do not need to manually chain 2-input gates.
//   c1 = g0 + p0.cin
//   c2 = g1 + p1.g0 + p1.p0.cin
//   c3 = g2 + p2.g1 + p2.p1.g0 + p2.p1.p0.cin
//   c4 = g3 + p3.g2 + p3.p2.g1 + p3.p2.p1.g0 + p3.p2.p1.p0.cin
//
// TODO -- Step 3: sum bits
//   sum[i] = p[i] ^ c[i]     (c0 = cin)

// cla4.v - 4-bit CLA block with Block Propagate (P_blk) and Block Generate (G_blk)
module cla4(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout,
  output       p_blk,
  output       g_blk
);

  wire [3:0] p, g;
  wire c1, c2, c3, c4;

  assign #(2) p = a ^ b;
  assign #(2) g = a & b;

  // Block propagate: all 4 bits propagate carry
  assign #(2) p_blk = &p;

  // Block generate: block generates carry internally
  assign #(2) g_blk = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

  // Internal carries
  assign #(2) c1   = g[0] | (p[0] & cin);
  assign #(2) c2   = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
  assign #(2) c3   = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
  assign #(2) c4   = g_blk | (p_blk & cin);
  assign cout = c4;

  // Sum bits
  assign #(2) sum = p ^ {c3, c2, c1, cin};

endmodule