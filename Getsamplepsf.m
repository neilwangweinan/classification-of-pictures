function [samplepsf] = Getsamplepsf(orimg,errorwindow,windowsize,IndexMatrix_obj)
%% this function aims to get PSF in a orimg; so we need errowwindow and fixing psfwindow.

[row_num,colum_num]=size(IndexMatrix_obj);
%orimg=all_img2(:,:,1);

row=1;
while row < row_num
    estposx=IndexMatrix_obj(row,1);
    estposy=IndexMatrix_obj(row,2);
%     errorwindow=ceil(sqrt(IndexMatrix_obj(row,3)))+2;
    if estposx < errorwindow || estposy < errorwindow
       IndexMatrix_obj(row,:)=[];              %delete one row
        row_num=row_num-1;
    end
    row=row+1;    
end

samplepsf=cell(row_num,3);

for row = 1:row_num
    
    estposx=IndexMatrix_obj(row,1);
    estposy=IndexMatrix_obj(row,2);
  
    %Cut part of the image and estimate positions of stars in this step
    ticimg=orimg(estposx-errorwindow:estposx+errorwindow,estposy-errorwindow...
        :estposy+errorwindow);
    
    %Obtain postion of the max value...
    [maxposx,maxposy]=find(ticimg==max(max(ticimg)),1);
    
    maxposx=estposx-errorwindow+maxposx-1;
    maxposy=estposy-errorwindow+maxposy-1;
    
    %Cut part of image from orimg with the psf center in middle of psffig
    sampsf=orimg(maxposx-windowsize:maxposx+windowsize,maxposy-windowsize:...
        maxposy+windowsize);

    %---Part: background substraction
    backimg=orimg(maxposx-2*windowsize:maxposx+2*windowsize,maxposy-...
    2*windowsize:maxposy+2*windowsize);

    %Added in Oct 20th, 2015 We perform denoise in this step
    %backimg=homodenoise(backimg);
    
    backimg=reshape(backimg,(4*windowsize+1)^2,1);
    back=(backimg);
    standardvar=std(backimg);
    
    %delete the image with less than 3 sigma
    backimg=backimg(backimg<back+3*standardvar);
    %recalculate the mean
    
    backmean=mean(backimg);
    sampsf=sampsf-backmean*ones(size(sampsf));
    %Direct make all the pixels with negative value to zero
    sampsf(sampsf<0)=0;       
    
    % Third Part: N wormalization psf 
    %make peak value to one - changed in Nov. 2015 ref to Lupton's SDSS paper
    %Maybe they are different for psf with good sample and different PSFs
    %<check later>
    
    sampsf=sampsf/max(max(sampsf));
    
    samplepsf{row,1}=maxposx;
    samplepsf{row,2}=maxposy;
    samplepsf(row,3)=sampsf;
end

end