function [U1,U2,U3,S] = svd3(A)
% Compute the HOSVD of a 3­way tensor A 
% [U1,U2,U3,S] = svd3(rank, A)
%
% Computes a Higher-Order SVD using the online SVD. Truncates
% the SVD after a certain number of terms (constant across all
% dimensions, i.e. a rank-R approximation). This is known to be
% sub-optimal, as shown in "On the Best Rank-1 and 
% Rank-(R1,R2...,Rn) Approximation of Higer-Order Tensors".
%
% From notes by Martin Holmberg
%
% Author: Greg Coombe
% Date: Aug 5, 2003
%

disp('Dimension 1');
fA = flatten(A, 1);
size(fA)
[U1, s, v] = svd( fA ); rank = min(size(fA)); 
U1 = U1(:, 1:rank);

s = s(1:rank, 1:rank);
v = v(:,1:rank);
compare( U1*s*v', fA, '1st');


disp('Dimension 2');
fA = flatten(A, 2);
size(fA)
[U2, s, v] = svd( fA );rank = min(size(fA));
U2 = U2(:, 1:rank);

s = s(1:rank, 1:rank);
v = v(:,1:rank);
compare( U2*s*v', fA, '2nd');


disp('Dimension 3');
fA = flatten(A, 3);
size(fA)
[U3, s, v] = svd( fA );rank = min(size(fA));
U3 = U3(:, 1:rank);

s = s(1:rank, 1:rank);
v = v(:,1:rank);
compare( U3*s*v', fA, '3rd');


% Compute the scaling tensor S = A * U1' * U2' * U3'
S = tmul(A, U1', 1);
S = tmul(S, U2', 2);
S = tmul(S, U3', 3); 

% Reconstruct the full tensor
%F = tmul( tmul( tmul( S, U1, 1), U2, 2), U3, 3);

