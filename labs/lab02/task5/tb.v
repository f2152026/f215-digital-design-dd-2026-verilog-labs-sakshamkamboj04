// tb.v
// Self-checking testbench for 4-bit ALU

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg  [3:0] exp_result;
  integer errors = 0;
  integer total_tests = 0;
  integer i, j;

  // Instantiate DUT
  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    // -------------------------------------------------------------
    // TEST 1: Hold operands fixed, switch op (exposes Bug 1: sensitivity list)
    // -------------------------------------------------------------
    $display("=== Running Sensitivity Test (fixed a=6, b=2, toggle op) ===");
    t_a = 4'd6; t_b = 4'd2; t_op = 1'b0; #5;
    total_tests = total_tests + 1;
    exp_result = 4'd8; // 6 + 2
    if (t_result !== exp_result) begin
      $display("FAIL [Op 0]: a=%0d b=%0d op=0 | got %0d, expected %0d", t_a, t_b, t_result, exp_result);
      errors = errors + 1;
    end

    // Now toggle op to 1 WITHOUT changing a or b:
    t_op = 1'b1; #5;
    total_tests = total_tests + 1;
    exp_result = 4'd4; // 6 - 2
    if (t_result !== exp_result) begin
      $display("FAIL [Op 1 Sensitivity Bug]: a=%0d b=%0d op=1 | got %0d, expected %0d (result failed to respond to op!)",
               t_a, t_b, t_result, exp_result);
      errors = errors + 1;
    end

    // -------------------------------------------------------------
    // TEST 2: Comprehensive sweep of add and sub
    // -------------------------------------------------------------
    $display("\n=== Running Comprehensive Sweep ===");
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        // Test Add (op = 0)
        t_a = i; t_b = j; t_op = 1'b0;
        exp_result = (i + j) & 4'hF;
        #5;
        total_tests = total_tests + 1;
        if (t_result !== exp_result) begin
          $display("FAIL [ADD]: a=%0d b=%0d | got %0d expected %0d", t_a, t_b, t_result, exp_result);
          errors = errors + 1;
        end

        // Test Sub (op = 1)
        t_a = i; t_b = j; t_op = 1'b1;
        exp_result = (i - j) & 4'hF;
        #5;
        total_tests = total_tests + 1;
        if (t_result !== exp_result) begin
          $display("FAIL [SUB]: a=%0d b=%0d | got %0d expected %0d", t_a, t_b, t_result, exp_result);
          errors = errors + 1;
        end
      end
    end

    // Summary
    $display("\n==============================================");
    if (errors == 0) begin
      $display("TEST SUMMARY: ALL %0d tests PASSED! (0 errors)", total_tests);
    end else begin
      $display("TEST SUMMARY: %0d / %0d PASSED (%0d FAILURES)", (total_tests - errors), total_tests, errors);
    end
    $display("==============================================");

    $finish;
  end

endmodule