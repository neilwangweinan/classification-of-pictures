function [samplepsf,IndexMatrix_obj] = Getsamplepsf(orimg,errorwindow,windowsize,IndexMatrix_obj)
%% this function aims to get PSF in a orimg; so we need errowwindow and fixing psfwindow.

[row_num,colum_num]=size(IndexMatrix_obj);
%orimg=all_img2(:,:,1);

row=1;
%remove brim and invalid objects
while row <= row_num          % this was a BUG... replacing of ‘row < row_num’
    estposx=IndexMatrix_obj(row,1);  
    estposy=IndexMatrix_obj(row,2);
% errorwindow=ceil(sqrt(IndexMatrix_obj(row,3)))+2;
    if (estposx<=2*errorwindow)||(estposy <= 2*errorwindow)||(estposx+2*errorwindow >= size(orimg,1))||(estposy+2*errorwindow >= size(orimg,1))
       IndexMatrix_obj(row,:)=[];              %delete one row
        row_num=row_num-1;
    else                      %this was a bug... replacing of ’end‘ 
    row=row+1;    
    end
end

%---Part:the whole objects of one pictue save into "samplepsf of cell Array",
%the data respectively represent for  X pos, Y pos and sample Psf . 
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
    
    samplepsf{row,1}=maxposx;
    samplepsf{row,2}=maxposy;
    
    %Cut part of image from orimg with the psf center in middle of psffig
    sampsf=orimg(maxposx-windowsize:maxposx+windowsize,maxposy-windowsize:...
       maxposy+windowsize);
%     sampsf=orimg(estposx-windowsize:estposx+windowsize,estposy-windowsize:...
%         estposy+windowsize);
    %---Part: background substraction    
    % an unresolved Bug: if maxposx-2*windowsize<0
    backimg=orimg(maxposx-windowsize:maxposx+windowsize,maxposy-...
    windowsize:maxposy+windowsize);

    backimg=reshape(backimg,(2*windowsize+1)^2,1);
    back=(backimg);
    standardvar=std(backimg);
    %delete the image with less than 3 sigma
    backimg=backimg(backimg<back+3*standardvar);
    %recalculate the mean
    backmean=mean(backimg);
    sampsf=sampsf-backmean*ones(size(sampsf));
    %Direct make all the pixels with negative value to zero
    sampsf(sampsf<0)=0;       
    
    % Third Part: N normalization psf 
    sampsf=sampsf/max(max(sampsf));
    
    samplepsf{row,3}=sampsf;
    
end

end