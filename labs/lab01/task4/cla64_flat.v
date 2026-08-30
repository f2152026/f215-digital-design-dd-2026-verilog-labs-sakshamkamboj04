// cla64_flat.v
// A flat, unblocked 64-bit carry-lookahead adder: every carry is computed
// directly (two-level, no rippling), exactly like cla4.v, just scaled to
// 64 bits. Add delays throughout (same convention as cla4.v) so it can be
// fairly compared against rca64.v and cla64_blocked.v.

module cla64_flat(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [63:0] p, g;
  wire [64:1] c;

  // Step 1: generate/propagate signals
  genvar i;
  generate
    for (i = 0; i < 64; i = i + 1) begin : gen_pg
      xor #(2) (p[i], a[i], b[i]);
      and #(2) (g[i], a[i], b[i]);
    end
  endgenerate

  // Step 2: The 64 direct carry equations
  assign #(2) c[1]  = g[0]  | (&p[0:0] & cin);
  assign #(2) c[2]  = g[1]  | (&p[1:1] & g[0])  | (&p[1:0] & cin);
  assign #(2) c[3]  = g[2]  | (&p[2:2] & g[1])  | (&p[2:1] & g[0])  | (&p[2:0] & cin);
  assign #(2) c[4]  = g[3]  | (&p[3:3] & g[2])  | (&p[3:2] & g[1])  | (&p[3:1] & g[0])  | (&p[3:0] & cin);
  assign #(2) c[5]  = g[4]  | (&p[4:4] & g[3])  | (&p[4:2] & g[1])  | (&p[4:1] & g[0])  | (&p[4:3] & g[2])  | (&p[4:0] & cin);
  assign #(2) c[6]  = g[5]  | (&p[5:5] & g[4])  | (&p[5:4] & g[3])  | (&p[5:3] & g[2])  | (&p[5:2] & g[1])  | (&p[5:1] & g[0])  | (&p[5:0] & cin);
  assign #(2) c[7]  = g[6]  | (&p[6:6] & g[5])  | (&p[6:5] & g[4])  | (&p[6:4] & g[3])  | (&p[6:3] & g[2])  | (&p[6:2] & g[1])  | (&p[6:1] & g[0])  | (&p[6:0] & cin);
  assign #(2) c[8]  = g[7]  | (&p[7:7] & g[6])  | (&p[7:6] & g[5])  | (&p[7:5] & g[4])  | (&p[7:4] & g[3])  | (&p[7:3] & g[2])  | (&p[7:2] & g[1])  | (&p[7:1] & g[0])  | (&p[7:0] & cin);
  assign #(2) c[9]  = g[8]  | (&p[8:8] & g[7])  | (&p[8:7] & g[6])  | (&p[8:6] & g[5])  | (&p[8:5] & g[4])  | (&p[8:4] & g[3])  | (&p[8:3] & g[2])  | (&p[8:2] & g[1])  | (&p[8:1] & g[0])  | (&p[8:0] & cin);
  assign #(2) c[10] = g[9]  | (&p[9:9] & g[8])  | (&p[9:8] & g[7])  | (&p[9:7] & g[6])  | (&p[9:6] & g[5])  | (&p[9:5] & g[4])  | (&p[9:4] & g[3])  | (&p[9:3] & g[2])  | (&p[9:2] & g[1])  | (&p[9:1] & g[0])  | (&p[9:0] & cin);
  assign #(2) c[11] = g[10] | (&p[10:10] & g[9]) | (&p[10:9] & g[8]) | (&p[10:8] & g[7]) | (&p[10:7] & g[6]) | (&p[10:6] & g[5]) | (&p[10:5] & g[4]) | (&p[10:4] & g[3]) | (&p[10:3] & g[2]) | (&p[10:2] & g[1]) | (&p[10:1] & g[0]) | (&p[10:0] & cin);
  assign #(2) c[12] = g[11] | (&p[11:11] & g[10]) | (&p[11:10] & g[9]) | (&p[11:9] & g[8]) | (&p[11:8] & g[7]) | (&p[11:7] & g[6]) | (&p[11:6] & g[5]) | (&p[11:5] & g[4]) | (&p[11:4] & g[3]) | (&p[11:3] & g[2]) | (&p[11:2] & g[1]) | (&p[11:1] & g[0]) | (&p[11:0] & cin);
  assign #(2) c[13] = g[12] | (&p[12:12] & g[11]) | (&p[12:11] & g[10]) | (&p[12:10] & g[9]) | (&p[12:9] & g[8]) | (&p[12:8] & g[7]) | (&p[12:7] & g[6]) | (&p[12:6] & g[5]) | (&p[12:5] & g[4]) | (&p[12:4] & g[3]) | (&p[12:3] & g[2]) | (&p[12:2] & g[1]) | (&p[12:1] & g[0]) | (&p[12:0] & cin);
  assign #(2) c[14] = g[13] | (&p[13:13] & g[12]) | (&p[13:12] & g[11]) | (&p[13:11] & g[10]) | (&p[13:10] & g[9]) | (&p[13:9] & g[8]) | (&p[13:8] & g[7]) | (&p[13:7] & g[6]) | (&p[13:6] & g[5]) | (&p[13:5] & g[4]) | (&p[13:4] & g[3]) | (&p[13:3] & g[2]) | (&p[13:2] & g[1]) | (&p[13:1] & g[0]) | (&p[13:0] & cin);
  assign #(2) c[15] = g[14] | (&p[14:14] & g[13]) | (&p[14:13] & g[12]) | (&p[14:12] & g[11]) | (&p[14:11] & g[10]) | (&p[14:10] & g[9]) | (&p[14:9] & g[8]) | (&p[14:8] & g[7]) | (&p[14:7] & g[6]) | (&p[14:6] & g[5]) | (&p[14:5] & g[4]) | (&p[14:4] & g[3]) | (&p[14:3] & g[2]) | (&p[14:2] & g[1]) | (&p[14:1] & g[0]) | (&p[14:0] & cin);
  assign #(2) c[16] = g[15] | (&p[15:15] & g[14]) | (&p[15:14] & g[13]) | (&p[15:13] & g[12]) | (&p[15:12] & g[11]) | (&p[15:11] & g[10]) | (&p[15:10] & g[9]) | (&p[15:9] & g[8]) | (&p[15:8] & g[7]) | (&p[15:7] & g[6]) | (&p[15:6] & g[5]) | (&p[15:5] & g[4]) | (&p[15:4] & g[3]) | (&p[15:3] & g[2]) | (&p[15:2] & g[1]) | (&p[15:1] & g[0]) | (&p[15:0] & cin);

  // Remaining carries c[17]..c[64] generated algorithmically using generate:
  genvar k, j;
  generate
    for (k = 17; k <= 64; k = k + 1) begin : gen_c
      wire [k:0] term;
      assign term[0] = g[k-1];
      for (j = 1; j < k; j = j + 1) begin : gen_term
        assign term[j] = (&p[k-1 : k-j]) & g[k-1-j];
      end
      assign term[k] = (&p[k-1 : 0]) & cin;
      assign #(2) c[k] = |term;
    end
  endgenerate

  assign cout = c[64];

  // Step 3: sum bits
  assign #(2) sum = p ^ {c[63:1], cin};

endmodule