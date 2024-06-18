module full_adder (input Cin, input A, input B, output Cout, output S);

    wire x1;
    xor (x1, A, B);
    xor (S, x1, Cin);

    wire x2, x3;
    and (x2, Cin, x1);
    and (x3, A, B);

    or (Cout, x2, x3);

endmodule