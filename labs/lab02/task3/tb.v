// tb.v
// Self-checking testbench for 2-bit comparator comp2

module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  // Expected signals computed independently by the testbench
  reg exp_gt, exp_lt, exp_eq;

  integer i, j;
  integer errors = 0;
  integer total_tests = 0;

  // Instantiate DUT
  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
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
    // Loop through all 16 combinations (A from 0 to 3, B from 0 to 3)
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;
        total_tests = total_tests + 1;

        // Compute independent ground-truth expected values
        exp_gt = (i > j);
        exp_lt = (i < j);
        exp_eq = (i == j);

        // Allow combinational logic to settle
        #5;

        // Self-checking assertion using !==
        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%0d (%b) B=%0d (%b) | got GT=%b LT=%b EQ=%b | expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_a, t_b, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end

    // Summary line built with $write and $display
    $write("TEST SUMMARY: ");
    if (errors == 0) begin
      $display("ALL %0d tests PASSED! (0 errors)", total_tests);
    end else begin
      $display("%0d / %0d tests PASSED (%0d FAILURES)", (total_tests - errors), total_tests, errors);
    end

    $finish;
  end

endmodule