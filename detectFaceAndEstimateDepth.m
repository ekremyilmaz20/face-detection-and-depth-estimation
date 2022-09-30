clear all;
close all;


load('stereoVariables.mat');
stereoParams = stereoParameters_LQ;


imageLeft = imread('C:\Users\ekrem\Desktop\face-detection-and-depth-est-from-stereo-images\model-new\DSCF3290.JPG');
imageRight = imread('C:\Users\ekrem\Desktop\face-detection-and-depth-est-from-stereo-images\model-new\DSCF3291.JPG');
figure, imshow(imageLeft), title('Image Left');
figure, imshow(imageRight), title('Image Right');

imageLeftUndistorted = undistortImage(imageLeft, ...
    stereoParams.CameraParameters1, 'OutputView', 'same');
imageRightUndistorted = undistortImage(imageRight, ...
    stereoParams.CameraParameters2, 'OutputView', 'same'); 

[rectifiedImageLeft, rectifiedImageRight] = rectifyStereoImages(imageLeftUndistorted, ...
    imageRightUndistorted, stereoParams);

figure
imshow(stereoAnaglyph(rectifiedImageLeft, rectifiedImageRight))
title('Rectified Images');

rectifiedImageLeftGray = rgb2gray(rectifiedImageLeft);
rectifiedImageRightGray = rgb2gray(rectifiedImageRight);

disparityRange = [0, 96];
disparityMap = disparity(rectifiedImageLeftGray, rectifiedImageRightGray, ...
    DisparityRange=disparityRange, BlockSize = 5);

figure,
imshow(disparityMap, DisplayRange = disparityRange);
title('Disparity Map');
colormap jet; colorbar;

xyzPoints = reconstructScene(disparityMap, stereoParams);
points3D = xyzPoints;
points3D = points3D./1000;
ptCloud = pointCloud(points3D, 'Color', rectifiedImageLeft);
figure, pcshow(ptCloud);

X = points3D(:, :, 1);
Y = points3D(:, :, 2);
Z = points3D(:, :, 3);



faceDetector = vision.CascadeObjectDetector('ClassificationModel', 'FrontalFaceCART');
detectedFaceLeftList = faceDetector(imageLeftUndistorted);

faceArea = 0;

for i = 1 : size(detectedFaceLeftList, 1)
   if detectedFaceLeftList(i, 3) > faceArea
       faceLeft = detectedFaceLeftList(i, :);
   end
end

faceLeftCenter = faceLeft(1:2) + faceLeft(3:4)/2;
faceLeftCenter = round(faceLeftCenter); 
faceLeftCenter = [615, 219]; 


faceLeftCenterX = X(faceLeftCenter(2), faceLeftCenter(1));
faceLeftCenterY = Y(faceLeftCenter(2), faceLeftCenter(1));
faceLeftCenterZ = Z(faceLeftCenter(2), faceLeftCenter(1));

distance = sqrt(faceLeftCenterX.^2 + faceLeftCenterY.^2 + faceLeftCenterZ.^2); 
distanceAsString = num2str(distance);
annotation = strcat('Distance of Face: ', distanceAsString, ' meters');
detectedFace = insertObjectAnnotation(imageLeftUndistorted, 'rectangle', faceLeft, annotation, 'FontSize', 28);
figure
imshow(detectedFace)
title('Detected faces');











