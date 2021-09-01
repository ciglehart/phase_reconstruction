clear all;
close all;
clc;

addpath('/Users/charlesiglehart/Desktop/cpd-master/src');
addpath('/Users/charlesiglehart/Desktop/cpd-master/utils');

FOVRatio = 1.0; % FOVz / FOVy
nt = 8;         % # temporal phases
ny = 256;       % y-dimension
nz = 256;        % z-dimension

% create a fully-sampled central region
Areg = zpad(removeCorners(ones(24,24)), [ny nz]); 
% Annular region with 2x1 regular under-sampling
F = removeCorners(ones(ny, nz) - Areg);
F(1:2:end,:) = 0;

%% Example 1: Variable density CPD sampling by region-wise UD-CPD
%%
Ry = sqrt(ny*nz / sum(sum(F/nt)));
Rz = Ry;
R = [Ry Rz];             % Ry = Rz
shapeOpt = 'cross';      % Union of a line along k = 0 and an ellipse at t = 0
distRelaxationOpt = 'k'; % Only relax k-space min. distance constraint
vd_exp = 1;              % 1/kr^1 density
Rmax = 22;               % reduction factor at kr = kmax
verbose = 0;
C = 1;

tic;
M1 = genVDCPD(nt,Rmax,vd_exp,FOVRatio,F,shapeOpt,verbose,C);

ny = 256;
nx = 256;
FOVRatio = 1;
ne = 8; 
ncalib = 24;

%valid = removeCorners(ones(ny,nx));
valid = ones(ny,nx);
valid(117:141,117:141) = 0;
masks = genUDCPD(ne,FOVRatio,valid,'cones');
mask = masks(:,:,1);
mask(117:141,117:141) = 1;
save('mask_cpd_acc_8.mat','mask');