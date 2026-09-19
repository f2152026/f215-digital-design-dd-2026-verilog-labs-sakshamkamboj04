// and_df.v - Dataflow style with continuous assignment delay
module and_df (
  input  a,
  input  b,
  output y
);

  // Set delay (#1, #2, or #3)
  assign #3 y = a & b;

endmodule