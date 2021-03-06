% matrix_multiply.m
%
% This script shows how to multiply matrices in the GPU using CLATLAB.
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

% init CLATLAB
clij2 = init_clatlab()
clij2.clear();

% create some test data
a = [1 2 3; 4 5 6]'
b = [1 2 3; 4 5 6]

% push it to the GPU and pull back to see if its fine
A = clij2.pushMat(a);
a = clij2.pullMat(A) 
B = clij2.pushMat(b);
b = clij2.pullMat(B) 

% check sizes and content
size_a = size(a)
size_A = clij2.getDimensions(A)
size_b = size(b)
size_B = clij2.getDimensions(B)

% multiply matrices on the GPU
C = clij2.create(3, 3);
clij2.multiplyMatrix(A, B, C);

c = clij2.pullMat(C)

c_ = a * b