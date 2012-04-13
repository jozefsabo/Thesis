function newU = uConstr(U,vrange)

newU = U;
newU(U<vrange(1)) = vrange(1);
newU(U>vrange(2)) = vrange(2);


