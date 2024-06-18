


module subtractor_64(input signed [63:0] A, input signed [63:0] B, output signed [63:0] Y, output Overflow);

    wire signed [63:0] carry;
    wire signed [63:0] Bnot;

    genvar i;

    generate for( i=0; i< 64; i = i+1)
    begin
        not(Bnot[i],B[i]);
    end
    endgenerate

    wire unsigned [63:0] one;
    assign one = 64'b1;

    wire x;

    wire signed [63:0] Bfinal;

    adder_64 add1(Bnot,one,Bfinal,x);

    adder_64 add2(A,Bfinal,Y,Overflow);



endmodule