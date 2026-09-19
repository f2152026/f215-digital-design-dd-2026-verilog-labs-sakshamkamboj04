// alu.v
// 1-bit-opcode ALU: op=0 -> add, op=1 -> sub. 4-bit operands -- FIXED

module alu (
  input      [3:0] a,
  input      [3:0] b,
  input            op,      // 0 = add, 1 = sub
  output reg [3:0] result
);

  reg [3:0] b_inv;
  reg [3:0] b_twos;

  // Bug 1 Fixed: explicitly include op in sensitivity list
  always @(a, b, op) begin
    case (op)
      1'b0: begin
        result = a + b;                 // add
      end
      1'b1: begin
        // Bug 2 Fixed: use blocking assignments (=) for combinational chain
        b_inv  = ~b;                   // sub, via two's complement
        b_twos = b_inv + 1;
        result = a + b_twos;
      end
    endcase
  end

endmodule