module fulladder(
    input a,
    input b,
    input Pin,
    
    output S,
    output Pout
);

wire c1,c2,c3,c4;


assign S = a^b^Pin;
assign  Pout = (a&b)|(a&Pin)|(b&Pin);


endmodule