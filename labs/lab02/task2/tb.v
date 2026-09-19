// tb.v
// Testbench with parameter override for lut module

module tb;

  // With DEPTH=8, address needs $clog2(8) = 3 bits
  reg  [2:0] t_sel;
  wire [7:0] t_dout;

  // Instantiate DUT with parameter override
  lut #(
    .WIDTH(8),
    .DEPTH(8)
  ) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer i;

  initial begin
    // Loop through all 8 addresses 5 time units apart
    for (i = 0; i < 8; i = i + 1) begin
      t_sel = i;
      #5;
    end
    #5 $finish;
  end

  initial
    $monitor($time, " sel = %0d (3'b%b) | dout = %0d (8'b%b)", t_sel, t_sel, t_dout, t_dout);

endmodule