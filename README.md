# face-detection-and-depth-estimation
 This project detects human faces and estimates depth information from stereo images with MATLAB

Stereo image pairs which are 1920x1080 size and have 8777 film frames obtained with the FUJIFILM FinePix Real 3D W3 digital stereo camera and the stereo images were calibrated by using an 
asymmetrical chessboard pattern measuring 35x28 cm, with the help of stereo camera calibrator app whitin the possibilities of MATLAB enviroment. 
Lens distortion was eliminated from stereo images by using a noise reduction algorithm and in order to obtain the best possible disparity map, the stereo images with lens noise removed were rectified by using geometric correction processes. 
After rectification processes, stereo images were converted from RGB format to gray level format then disparity map was obtained with disparity range 0.96 and with the help of obtained disparity map, depth of the stereo images estimated. 
By using construction method with the inputs disparity map and reconstruction matrix, 3D point cloud was created. 
By using cascade object detector method, the face from the stereo images detected and the distance of face from camera calculated by using Euclidean Algorithm with the inputs X, Y, Z coordinates obtained from 3D point cloud.
