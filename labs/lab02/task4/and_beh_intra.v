// and_beh_intra.v - Behavioral style with INTRA-assignment delay
module and_beh_intra (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    // Evaluates a & b IMMEDIATELY, but delays writing to y
    y = #3 a & b;
  end

endmodule