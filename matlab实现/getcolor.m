function datacolor = getcolor(image,x,y)

% R=image(:,:,1); G=image(:,:,2); B=image(:,:,3);

test=image;
% [m,n,d]=sxze(image);

    
if(test(x,y,1)>85 && test(x,y,1)<255)&&(test(x,y,2)>200 && test(x,y,2)<255)&&(test(x,y,3)>0 && test(x,y,3)<80)%黄色
    
    datacolor = 'Y';
    
elseif (test(x,y,1)>80 && test(x,y,1)<255)&&(test(x,y,2)>0 && test(x,y,2)<80)&&(test(x,y,3)>0 && test(x,y,3)<80)%红色
    datacolor = 'R';
    
elseif (test(x,y,1)>0 && test(x,y,1)<80)&&(test(x,y,2)>0 && test(x,y,2)<80)&&(test(x,y,3)>80 && test(x,y,3)<255)%蓝色
    datacolor = 'B';
    
elseif(test(x,y,1)>0 && test(x,y,1)<80)&&(test(x,y,2)>80 && test(x,y,2)<255)&&(test(x,y,3)>0 && test(x,y,3)<80)%绿色
    datacolor = 'G';

end
    
    
end




