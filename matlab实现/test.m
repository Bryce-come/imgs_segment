img =imread('images2 2/org_1.png');
imshow(img);
x=[114,198,284,366];
y=[113,200,280,367];

diff_R=100; diff_G=120; diff_B=100; % 设置红、绿、蓝三种颜色提取阈值（越大越严格）

result=cell(4,4);

for i=0:3
    for j=0:3
        R=img(x(i),y(j),1);
        G=img(x(i),y(j),2);
        B=img(x(i),y(j),3);
        if (R-B)>diff_R&&(R-G)>diff_R
            result(i+1,j+1)='R';
        elseif (G-B)>diff_G&&(G-R)>diff_G
            result(i+1,j+1)='G';
        elseif (B-R)>diff_B&&(B-G)>diff_B
            result(i+1,j+1)='B';
        elseif (R-B)>diff_R&&(G-B)>diff_G
            result(i+1,j+1)='Y';
        end
    end
end

result;



