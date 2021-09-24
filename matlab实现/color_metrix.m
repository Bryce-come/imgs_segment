img =imread('org_1.png');
imshow(img);
x=[114,198,284,366];
y=[113,200,280,367];

diff_R=100; diff_G=80; diff_B=100; % 设置红、绿、蓝三种颜色提取阈值（越大越严格）

result=char(4,4);

for i=1:4
    for j=1:4
        R=img(x(i),y(j),1);
        G=img(x(i),y(j),2);
        B=img(x(i),y(j),3);
        if (R-B)>diff_R&&(R-G)>diff_R
            result(i,j)='R';
        elseif (G-B)>diff_G&&(G-R)>diff_G
            result(i,j)='G';
        elseif (B-R)>diff_B&&(B-G)>diff_B
            result(i,j)='B';
        elseif (R-B)>diff_R&&(G-B)>diff_G
            result(i,j)='Y';
        end
    end
end

disp(result);
