% statistics.m
%
% This script shows how to get pixel statistics from an image
% and from selected pixels.
%
%
% In order to make this script run, you need to install CLATLAB an
% run it from matlab. Tested with Matlab 2019b
%         https://clij.github.io/clatlab/
%
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

% initialize CLATLAB
clx = init_clatlab();

% load example data
filename = '../../test/resources/blobs.tif';
img = imread(filename);
% there are issues with unit8/int8 conversion; 
% thus, we convert the image to double
img = double(img);

% show input image in a subplot
figure;
subplot(1,2,1), imshow(img, [0 255]);

% check on which GPU it's running 
string(clx.getGPUName())

% push image to GPU
input = clx.push(img);

meanIntensity = clx.op.sumPixels(input) / input.getWidth() / input.getHeight();
string("Mean intensity of all pixels: " + meanIntensity)


% reserve memory for a mask and masked image, same size and type as input
mask = clx.create(input);
masked = clx.create(input);

% apply threshold method on GPU
clx.op.automaticThreshold(input, mask, "Otsu");

% mask the image
clx.op.mask(input, mask, masked);

% determine mean intensity of masked area:
meanIntensity = clx.op.sumPixels(masked) / input.getWidth() / input.getHeight();
string("Mean intensity of masked pixels: " + meanIntensity)

% clean up
input.close();
mask.close();
masked.close();

