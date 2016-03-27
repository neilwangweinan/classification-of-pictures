function [img,img_num] =Getfits(file_path)               %Read fits file under the directory. 
img_path_list=dir(fullfile(file_path,'*.fits'));  %Get the whole pictures of fits from this path.
img_num=length(img_path_list);                   %Get the number of pictures
    if img_num>0                                 
        for j=1:img_num
            image_name=img_path_list(j).name;    % name of the picture 
            image=fitsread(fullfile(file_path,image_name));
            [m,n]=size(image);
            img(:,:,j)=zeros(m,n);
            img(:,:,j)=image;
            %fprintf('%d %d %s\n',1i,j,strcat(file_path,image_name));  %show the name of the picture.
            end
    else fprintf('error------no *.fits in this file') ;   
    end
end