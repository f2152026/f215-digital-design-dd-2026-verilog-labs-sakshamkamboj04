// and_beh_before.v - Behavioral style with delay placed BEFORE assignment
module and_beh_before (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    // Waits first, then evaluates a & b using whatever values exist at that later time
    #3 y = a & b;
  end

endmodule