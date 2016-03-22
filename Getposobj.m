 function [IndexMatrix_obj,num_label] = Getposobj(orimg)

[row_img,col_img]=size(orimg);                       %Get size of orimg
trgamma_img=(imadjust(mat2gray(orimg),[],[],0.1));   %transform gamma and gamma parameter is 0.1
[conters_hist,freqhist]=imhist(trgamma_img);
csum = cumsum(conters_hist);
for gray_level = 1:size(conters_hist,1)              %set the threshold result from 1% pixels (regarding as objects)
    if csum(gray_level) >= row_img*col_img*0.99
    %    disp(['[0,',num2str(i-1),']']);             %trial(find gray level of the threshold) 
    break;
    end 
end
threshold = gray_level/256;                          %set graylevel of threshold
thres_img=im2bw(mat2gray(trgamma_img),threshold);    %threshold bw

objimg=bwareaopen(thres_img,6,8);                    %remove noise

%figure,imshow(objimg)                               %show objects after remove noise
[Label_objimg,num_obj] = bwlabel(objimg,8);          %set label of objects
obj_orimg=immultiply(objimg,orimg);                  %extract objects of the picture
%figure,imshow(mat2gray(obj_orimg))                  %show objects of the orgin picture
%disp(['There are ' num2str(num_obj) ' labels of the picture.']) %show the number of labels

  IndexMatrix_obj=zeros(num_obj,3);      
% IndexMatrix_obj=zeros(num_obj,2); 
for num_label= 1:num_obj       
      [x_Label_objimg y_Label_objimg]=find(Label_objimg==num_label);
      IndexMatrix_obj(num_label,1) = round(mean(x_Label_objimg));
      IndexMatrix_obj(num_label,2) = round(mean(y_Label_objimg));
      IndexMatrix_obj(num_label,3) = size(x_Label_objimg,1);
end

end
