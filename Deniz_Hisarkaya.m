% I read the images
img1 = imread('florence3.jpg');
img2 = imread('florence4.jpg');
% Finding corresponding points between two images using harris features
I1 = rgb2gray(img1);
I2 = rgb2gray(img2);

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[f1, vpts1] = extractFeatures(I1, points1);
[f2, vpts2] = extractFeatures(I2, points2);

indexPairs = matchFeatures(f1, f2) ;
matchedPoints1 = vpts1(indexPairs(1:17, 1));
matchedPoints2 = vpts2(indexPairs(1:17, 2));
% display(matchedPoints2.Location)
% Using these corresponding points and using the RANSAC method, I construct my Fundamental Matrix.
FundamentalMatrix = estimateFundamentalMatrix(matchedPoints2,matchedPoints1,'Method','RANSAC');

%%

% The 5 points I chose in the left image
MyPoints = [305, 288, 910, 812, 785; 1055, 815, 731, 436, 270; 1, 1, 1, 1, 1];
figure;imshow(img2);
% I show img2 with figure window.
hold on;
% I'm adding the new codes I wrote with the 'hold on' command to my figure. 
plot(MyPoints(1,:),MyPoints(2,:), 'm.', 'MarkerSize', 20, 'LineWidth', 2);
% With the plot library, I showed the location of the coordinates I chose on the figure with magenta dots.
hold on;

% I normalize my points so that the sum of their squares is 1. 
N = FundamentalMatrix*MyPoints; 

% I create the line equation; ax + by + c = 0, 
% and I solve the equation using the 'solve' function. 
% 'syms' represents unknown value. 
syms y
x=0;
% We create the for loop because we want the equation to do the same for every point. 
for i=1:5
% I pull the coefficients of the equation from the normalized dot matrix.    
    a = N(1,i);
    b = N(2,i);
    c = N(3,i);
% Line equation   
    eqn = a*x + b*y + c;
% y values found     
    soly(i) = solve(eqn,y);
end

syms y2
x2=1536;
% We create the for loop because we want the equation to do the same for every point.
for i=1:5
% I pull the coefficients of the equation from the normalized dot matrix.
    a = N(1,i);
    b = N(2,i);
    c = N(3,i);
% Line equation    
    eqn2 = a*x2 + b*y2 + c;
% y2 values found    
    soly2(i) = solve(eqn2,y2);
end

% The 'double' function allows me to get the points in pairs.
points=double([0,soly(1),1536,soly2(1);
         0,soly(2),1536,soly2(2);
         0,soly(3),1536,soly2(3);
         0,soly(4),1536,soly2(4);
         0,soly(5),1536,soly2(5);]);
% I determine the lines by writing the pairs of points. and I add in the figure with 'hold on' command.
figure;imshow(img1);
hold on;
%  I had the epipolar lines plotted with the 'Line' function.  
line(points(:,[1,3])',points(:,[2,4])');
