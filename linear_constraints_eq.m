function [Aeq, beq] = linear_constraints_eq(N)
% characterize a symmetric matrix
% by a linear system Aeq * g = 0 := beq
Aeq = zeros((N-1)*N/2, N*N);
idx = 1;
for i = 1:N
    for j = (i+1):N
        k = sub2ind([N, N], i, j);
        kc = sub2ind([N, N], j, i);
        Aeq(idx, k) = 1;
        Aeq(idx, kc) = -1;
        idx = idx+1;
    end
end
beq = zeros((N-1)*N/2, 1);
end
