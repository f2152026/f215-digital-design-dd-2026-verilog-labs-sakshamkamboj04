// cla64_hier.v
// BONUS -- open-ended. No detailed scaffold is provided; this is meant to
// be a genuine design exercise. Not required for lab submission.
//
// You will likely need to modify cla4.v (or add signals alongside it) so
// that block-generate/block-propagate summaries of its own Gi, Pi signals
// are exposed as outputs, since the second-level lookahead unit below
// needs them. As with every module in this lab from Task 2 onward, every
// gate/assign you add should carry an explicit delay.
//
// Starting point (from Tutorial 3, Q4(d)):
//   - Reuse 16 four-bit CLA blocks (your cla4.v) -- their internal logic
//     doesn't change.
//   - For each block k, define:
//       Gblk_k = "this block produces a carry regardless of its incoming
//                 carry" -- a Boolean function of that block's own 4
//                 bit-level Gi, Pi signals.
//       Pblk_k = "an incoming carry sails straight through this whole
//                 block" -- likewise a function of its own Gi, Pi.
//   - Build a second-level lookahead unit -- structurally identical to
//     cla4.v, just one level up -- that computes each block's carry-in
//     directly from Gblk_0..Gblk_15, Pblk_0..Pblk_15, and cin, instead of
//     rippling block to block.
//
// To test this, wire it into dut.v as a fourth option (copy the pattern
// used for the other three) and run it through the same tb.v. Compare
// your final delay to cla64_blocked.v from Task 4.

// cla64_hier.v
// Hierarchical O(log n) 64-bit CLA using 16 4-bit blocks and a 2nd-level Lookahead Carry Unit

module cla64_hier(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [15:0] p_blk;
  wire [15:0] g_blk;
  wire [16:0] c_blk;   // c_blk[0] is cin, c_blk[1..16] are block carry-ins

  assign c_blk[0] = cin;

  // -------------------------------------------------------------------------
  // Level 2: Lookahead Carry Unit for the 16 Blocks
  // -------------------------------------------------------------------------
  genvar k, j;
  generate
    for (k = 1; k <= 16; k = k + 1) begin : gen_block_carries
      wire [k:0] term;
      assign term[0] = g_blk[k-1];
      for (j = 1; j < k; j = j + 1) begin : gen_terms
        assign term[j] = (&p_blk[k-1 : k-j]) & g_blk[k-1-j];
      end
      assign term[k] = (&p_blk[k-1 : 0]) & cin;
      assign #(2) c_blk[k] = |term;
    end
  endgenerate

  assign cout = c_blk[16];

  // -------------------------------------------------------------------------
  // Level 1: 16 Four-Bit CLA Blocks operating in parallel
  // -------------------------------------------------------------------------
  genvar i;
  generate
    for (i = 0; i < 16; i = i + 1) begin : gen_cla4_blocks
      cla4 block_inst (
        .a     (a[4*i + 3 : 4*i]),
        .b     (b[4*i + 3 : 4*i]),
        .cin   (c_blk[i]),
        .sum   (sum[4*i + 3 : 4*i]),
        .cout  (),
        .p_blk (p_blk[i]),
        .g_blk (g_blk[i])
      );
    end
  endgenerate

endmodule