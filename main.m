[all_img1,num_img1]=Getfits('D:\astronomy images\binding\20120908-1\20120908_1');
[all_img2,num_img2]=Getfits('D:\astronomy images\binding\20120908-1\20120908_2');
[all_img3,num_img3]=Getfits('D:\astronomy images\binding\20120908-1\20120908_3');
[all_img4,num_img4]=Getfits('D:\astronomy images\binding\20120908-1\20120908_4');

AllIndex_objimg=cell(num_img1,4);
Allsamplepsf=cell(num_img1,4);

errorwindow=6;
windowsize=3;
 for i=1:num_img4
     img_4=all_img4(:,:,i);
     [Index_objimg,num_label]=Getposobj(img_4); 
     AllIndex_objimg{i,4}=Index_objimg;           %read Index_objimg by cell Array 
     %obtain psf 
     Allsamplepsf{i,4}=Getsamplepsf(img_4,errorwindow,windowsize,Index_objimg); 
 end
 
 for i=1:num_img3
     img_3=all_img3(:,:,i);
     [Index_objimg,num_label]=Getposobj(img_3);  
     AllIndex_objimg{i,3}=Index_objimg;           %read Index_objimg by cell Array
     Allsamplepsf{i,3}=Getsamplepsf(img_3,errorwindow,windowsize,Index_objimg);
 end
 for i=1:num_img2
     img_2=all_img2(:,:,i);
     [Index_objimg,num_label]=Getposobj(img_2);  
     AllIndex_objimg{i,2}=Index_objimg;           %read Index_objimg by cell Array
     Allsamplepsf{i,2}=Getsamplepsf(img_2,errorwindow,windowsize,Index_objimg);
 end
 
 for i=1:num_img1
     img_1=all_img1(:,:,i);
     [Index_objimg,num_label]=Getposobj(img_1);  
     AllIndex_objimg{i,1}=Index_objimg;           %read Index_objimg by cell Array
     Allsamplepsf{i,1}=Getsamplepsf(img_1,errorwindow,windowsize,Index_objimg);
 end
clear img_1 img_2 img_3 img_4 num_label Index_objimg i
