function [ sampsf,maxposx,maxposy ] = GetPsf( orgfig,estposx,estposy,errorwindow,windowsize )
%Get psf of the debris from a predefiend figure and the Guess position
%   This function is part of PCA-MaxPos astrometry package, it returns a
%   star image of psfwindow size from a predefined figure and a guess position
%INPUT: img is an original image obtained from fits file
%INPUT: Aposx and Aposy are postion of this star <Guessed postion >
%INPUT: errorwindow is the size of error window that will make the obsever
%confused
%INPUT: psfwindow is the size of psf we want to obtain.

%OUTPUT: sampsf is the psf we need with size 2*psfwindow+1 \times
%2*psfwindow+1

%%%%%Three parts in this function: 1. delete/return abnormal psf with zero
%%%%%psfs;  2. substract background;    3. Normalize psf

%% First part: Abnormal psf test
%Generate psf with its center in the middle of this function
%filter the image with median filter to remove cosmic ray noise....
orgfig=adpmedian(orgfig,3);
%Cut part of the image and estimate positions of stars in this step
ticimg=orgfig(estposx-errorwindow:estposx+errorwindow,estposy-errorwindow...
    :estposy+errorwindow);
%Obtain postion of the max value...
[maxposx,maxposy]=find(ticimg==max(max(ticimg)),1);
%Transform local coordinate into global coordinate
maxposx=estposx-errorwindow+maxposx-1;
maxposy=estposy-errorwindow+maxposy-1;
%Cut part of image from orgfig with the psf center in middle of psffig
sampsf=orgfig(maxposx-windowsize:maxposx+windowsize,maxposy-windowsize:...
    maxposy+windowsize);

%We assume the psf is uniformly distributed in a small area (for PMO data,
%5 pixle) and if they are not like that,we will directly return an all zero
%image
%outscale is a sequare that outside the window and will be used here (It
%depends on your choice and is possble to chage, we use the pixels outside
%the psf as test...)
outscale=[orgfig(maxposx-(windowsize+1):maxposx+(windowsize+1),maxposy-(windowsize+1)),...
    orgfig(maxposx-(windowsize+1):maxposx+(windowsize+1),maxposy+(windowsize+1)),...
    orgfig(maxposx-(windowsize+1),maxposy-(windowsize+1):maxposy+(windowsize+1))',...
    orgfig(maxposx+(windowsize+1),maxposy-(windowsize+1):maxposy+(windowsize+1))'];
%Test nonuniformty with the outscale 
if max(max(outscale))/min(min(outscale))>1.1
    %return abnormal psf as all zero value
    sampsf=zeros(2*windowsize+1,2*windowsize+1);
    %return max position as 0,0 for error detection...
    maxposx=0;
    maxposy=0;
    return
end



%% Second Part: background substraction
backimg=orgfig(maxposx-2*windowsize:maxposx+2*windowsize,maxposy-...
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




%% Third Part: Normalization psf 
%make peak value to one - changed in Nov. 2015 ref to Lupton's SDSS paper
%Maybe they are different for psf with good sample and different PSFs
%<check later>
sampsf=sampsf/max(max(sampsf));
end
