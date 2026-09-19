// comp2.v
// 2-bit unsigned magnitude comparator -- FIXED

module comp2 (
  input  [1:0] A,
  input  [1:0] B,
  output       GT,
  output       LT,
  output       EQ
);

  assign EQ = (A == B);
  assign GT = (A >  B);   // Fixed: changed >= to >
  assign LT = (A <  B);

endmodule