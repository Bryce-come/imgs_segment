ortho = imread('images2 2/org_1.png');
figure(1);
imshow(ortho)
text(size(ortho,2),size(ortho,1)+15, ...
    'Image courtesy of Massachusetts Executive Office of Environmental Affairs', ...
    'FontSize',7,'HorizontalAlignment','right');

unregistered = imread('proj1_2.png');
figure(2)
imshow(unregistered)
text(size(unregistered,2),size(unregistered,1)+15, ...
    'Image courtesy of mPower3/Emerge', ...
    'FontSize',7,'HorizontalAlignment','right');


[mp,fp] = cpselect(unregistered,ortho,'Wait',true);

% The projective transformation parameters of the optimal alignment of moving points and fixed points are obtained.
t = fitgeotrans(mp,fp,'projective');


Rfixed = imref2d(size(ortho));
registered = imwarp(unregistered,t,'OutputView',Rfixed);

imshowpair(ortho,registered,'blend')

Rmin = 30;
Rmax = 50;
[centers, radii,metric] = imfindcircles(pre,[Rmin,Rmax]);
centers = sortrows(center,1);
if cneters(1,2) > centers(2,2)
    centers([1,2],:) = centers([2,1],:);
end

if centers(3,2) > centers(4,2)
    cneters([3,4],:) =centers([4,3],:);
end