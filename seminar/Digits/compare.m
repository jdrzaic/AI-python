function [percent, NE, MAE, MSE] = compare( A, B, name )
% [percent, NE, MAE, MSE] = COMPARE( A, B, str )   Compare two matrices (or tensors)
%
% Return the mean absolute error, mean squared error, norm error, and percent
% and output the result
%
% Author: Greg Coombe
%
if ( any( size(A) ~= size(B) ) )
    error('Matrix dimensions must match for comparison.');
end

% Set NAN to zero
A(isnan(A)) = 0;
B(isnan(B)) = 0;

if ( ndims(A) == 2 )
    diff = A - B;
	MAE = mean(mean(abs(diff)));
	MSE = mean(mean( (diff) .* (diff) ));
	NE = norm(diff);
    VE = norm(var(diff));
    percent = 100 * NE / norm(B);
elseif ( ndims(A) == 3 )
 	MAE = mean(mean(mean(abs(A - B))));
 	MSE = mean(mean(mean( (A-B) .* (A-B) )));
	for i=1:size(A,3)
        vNE(i) = norm( A(:,:,i) - B(:,:,i));
        vVE(i) = norm(var(A(:,:,i) - B(:,:,i)));
        p1(i) = norm( B(:,:,i) );
    end
    NE = norm(vNE);
    VE = norm(vVE);
    percent = 100 * NE / norm(p1);
end       


compare = ['MAE: ' num2str(100*MAE) ...
           ', MSE: ' num2str(100*MSE) ...
           ', NVar: ' num2str(100*VE) ...
           ', NE: ' num2str(NE) ' for ' name ...
           ' (' num2str(percent) '%)']
   