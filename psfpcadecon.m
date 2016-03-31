function [ psfbas,relativeweight ] = psfpcadecon( psfnmatrix )
%It is used to get the principle components from a series of psf
%   Based on Pattern Recongnition, with a set of psfs we could obtain a set
%   of basic to represent these psfs with less loss
%   And based on the above truth we will further process our research to
%   generate pca of these psfs and their relative weight
%INPUT:psfmatrix: a set of psf with the same size and centered in the
%middle of matrix

%OUTPUT: psfbas, psf base obtained directrly from pca decompostion
%OUTPUT: relativeweight is used to estimate relative weight for different
%components...
%% I will add some scripts later Peng
%
%% Main body
%Evaluate the size of PCA matrix and size of PSF
[psfa,psfb,psfc]=size(psfnmatrix);
psfmatrix=zeros(psfa,psfb,psfc);
%My function set abnormal psfs to zero. so a precessing acess is performed
%before we begin our process...
%error flag
k=0;
for i=1:psfc
    if sum(sum(psfnmatrix(:,:,i)))<0.1
        k=k+1;
    else
        psfmatrix(:,:,i-k)=psfnmatrix(:,:,i);
    end
end
psfc=psfc-k;
psfmatrix=psfmatrix(:,:,1:psfc);
%Reshape matrix to make pca decompostion easier
psfmatrix=reshape(psfmatrix,psfa*psfb,psfc);
%PCA analysis of psf matrix
[basU,relativeweight,~]=svd(psfmatrix);
relativeweight=diag(relativeweight)/max(max(diag(relativeweight)));
grad=abs(diff(diff(relativeweight')));
grad=grad(grad>10^(-3));
[c,~]=size(grad);
psfc=c+1;
relativeweight=relativeweight(1:psfc);
%Reshape to get the psf base
psfbas=zeros(psfa,psfb,psfc);
for i=1:psfc
    psfbas(:,:,i)=reshape(basU(:,i),psfa,psfb);
end

%% 
%2. Using moment estimation metod to find results
% for i=1:psfc
%     [vectormatrix(1,i), vectormatrix(2,i)]=momentest(psfbas(:,:,i));
% end
end
