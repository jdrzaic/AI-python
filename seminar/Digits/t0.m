
load azip
load dzip

TRI = azip(:,dzip==3) ;
[m3,n3]=size(TRI) ; 

for i = 1 : n3 
    T3(:,:,i) = reshape(TRI(:,i),16,16) ;
end

rank = 16 ; 
[U1,U2,U3,S] = svd3(T3) ; 


A1 = U1*S(:,:,1)*U2' ; 
figure, ima2(-A1)

sum(diag(S(:,:,1)'*S(:,:,1)))