module and_64 (input signed [63:0] A, input signed [63:0] B, output signed [63:0] Y);

    genvar i;
    generate 
        for(i = 0; i < 64; i = i + 1)
        begin
            and (Y[i], A[i], B[i]);
        end
    endgenerate

endmodule