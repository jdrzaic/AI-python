function Y = tmul( T, X, dim )
% TMUL( T, X, DIM )   Tensor Multiplication
%
% Multiply the matrix X by the tensor T along dimension DIM.
%
% Author: Greg Coombe
%

U = flatten( T, dim);
tmpY = X*U;

Y = unflatten( tmpY, dim, size(T) );