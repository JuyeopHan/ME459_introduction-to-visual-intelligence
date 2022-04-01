clc; clear all; close all;

% load image
c3 = imread('c3.jpg');
c3 = imrotate(c3, -90, 'nearest');
imshow(c3)

load('features.mat');

image = c3;
former = points_c3;
latter = points_c2_3;

% Get homography matrix H
H = Homography(former,latter);
H_inv = inv(H);
%% Image transformation and Interpolation


[n_y, n_x, ~] = size(image);


% % find (min, max)_(x,y)

min_x = 1e6; max_x = -1e6;
min_y = 1e6; max_y = -1e6;

for i = 1:n_y
    for j = 1:n_x
        v = H * [j; i; 1];
        v = v / v(3);
        [min_x, max_x, min_y, max_y] = FindRange(v, min_x, max_x, min_y, max_y);
    end
end

dx = round(max_x - min_x) +1; dy = round(max_y - min_y) + 1;

% initialize warped image
image_warp = uint8(ones(dy, dx, 3));

for i = 1:dy
    for j = 1:dx
        % inverse transformation corresponding to each pixel
        v = [j+round(min_x), i+round(min_y), 1]';
        v_inv = H_inv * v;
        v_inv = v_inv / v_inv(3);
        x = v_inv(1); y = v_inv(2);
        
        x_r = round(x); y_r = round(y);
        
        if (x_r < 2 || y_r < 2 || x > n_x - 1 || y > n_y - 1)
            continue;
        else
            a = x - x_r; b = y - y_r;
            % color value
            c11 = image(y_r, x_r, :);
            c21 = image(y_r, x_r + 1, :);
            c12 = image(y_r + 1, x_r, :);
            c22 = image(y_r + 1, x_r + 1, :);
            % interporation
            color = (1 - a)*(1 - b)*c11 + a*(1-b)*c21 + a*b*c22 + (1-a)*b*c12;

            image_warp(i, j, :) = color;
        end
    end
end

imshow(image_warp)
