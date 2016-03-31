function [coef,score,latent]=PCAdecon(psf)

% PCA decline dimension
psf=psf-mean(psf(:));
[coef,score,latent] = princomp(psf);
latent=100*latent/sum(latent);%?latent?????100????????
%pareto(latent);%??matla??
csum=cumsum(latent);
for i = 1:size(latent,1)   
 if csum(i) >= 85
    break;
 end 
end
score=score(1:size(score,1),1:i);

end