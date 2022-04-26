%% load features
clc; clear all; close all;

load('features.mat');

feature_1 = pts_a1';
feature_2 = pts_a2';

image1 = imread('a1.jpg');
image1 = imrotate(image1, -90, 'nearest');
image2 = imread('a2.jpg');
image2 = imrotate(image2, -90, 'nearest');
%% Fundamental matrix

[F, set_epi_dist1, set_epi_dist2] = eightPoint(image1, image2, feature_1,feature_2, 0);
[F_nom, set_epi_dist1_nom, set_epi_dist2_nom] = eightPoint(image1, image2, feature_1,feature_2, 1);

%% Average of epipolar distance

mean(set_epi_dist1)
mean(set_epi_dist2)

mean(set_epi_dist1_nom)
mean(set_epi_dist2_nom)