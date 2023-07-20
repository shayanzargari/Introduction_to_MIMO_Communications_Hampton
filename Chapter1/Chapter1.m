clc;
clear all;

% --------------------- Solution 1.6 (a) ---------------------
matrixA = [3 1; 1 3];
eigenvaluesA = eig(matrixA);
fprintf('Determinant of A: %.2f\n', det(matrixA));
fprintf('Product of eigenvalues: %.2f\n', prod(eigenvaluesA));
fprintf('Trace of A: %.2f\n', trace(matrixA));
fprintf('Sum of eigenvalues: %.2f\n\n', sum(eigenvaluesA));

% --------------------- Solution 1.7 (a) ---------------------
matrixC = rand(4,3);  
[U,D,V] = svd(matrixC);  
singularValuesD = diag(D);
nonZeroSingularValues = sum(singularValuesD > 1e-10);  
rankMatrixC = rank(matrixC);

fprintf('The number of non-zero singular values of D: %d\n', nonZeroSingularValues);  
fprintf('Rank of Matrix C: %d\n\n', rankMatrixC);

% --------------------- Solution 1.8 (a) ---------------------
n = 2;
matrixA = rand(4, n) + 1i*rand(4, n); 
HermitianMatrix = matrixA*matrixA';  

singularValuesA = svd(matrixA);  
eigenvaluesH = eig(HermitianMatrix);  
fprintf('Square root of eigenvalues of H:\n');
disp(sqrt(eigenvaluesH));
fprintf('Singular values of A:\n');
disp(singularValuesA);

% --------------------- Solution 1.8 (b) ---------------------
singularValuesH = sort(svd(HermitianMatrix), 'descend');  
eigenvaluesH = sort(abs(eig(HermitianMatrix)), 'descend');  
fprintf('Absolute and sorted eigenvalues of H:\n');
disp(eigenvaluesH);
fprintf('Sorted singular values of H:\n');
disp(singularValuesH);

% --------------------- Solution 1.9 (a) ---------------------
m = 3;
n = 2;
matrixA = rand(m,n);  
[Q, R] = qr(matrixA);  
fprintf('Difference between Q*R and A:\n');
disp(Q*R - matrixA);
fprintf('Difference between Q''*Q and identity matrix:\n');
disp(Q'*Q - eye(m));  % Size should be m, not n
fprintf('Matrix R:\n');
disp(R);

% --------------------- Solution 1.10 (a) ---------------------
matrixA = rand(m,n); 
nullSpaceBasis = null(matrixA); 
rankMatrixA = rank(matrixA); 
nullityMatrixA = size(nullSpaceBasis, 2); 
fprintf('Rank + Nullity of A: %d\n', rankMatrixA + nullityMatrixA); 
fprintf('Number of columns in A: %d\n\n', n);

% --------------------- Solution 1.10 (b) ---------------------
for i = 1:nullityMatrixA
    fprintf('A * basis vector %d:\n', i);
    disp(matrixA * nullSpaceBasis(:, i));
end

% --------------------- Solution 1.10 (c) ---------------------
if nullityMatrixA > 0
    for coeff = 1:nullityMatrixA
        linearComb = coeff * nullSpaceBasis;
        fprintf('A * linear combination of basis vectors with coefficient %d:\n', coeff);
        disp(matrixA * linearComb);
    end
else
    fprintf('The matrix A has full rank and nullity 0.\n');
end
