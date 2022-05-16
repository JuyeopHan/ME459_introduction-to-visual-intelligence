%% load image
clc; clear all; close all;

im2 = int16(rgb2gray(imread('cones/im2.png'))); % left image
im6 = int16(rgb2gray(imread('cones/im6.png'))); % right image

[n_y, n_x, ~] = size(im2);
size_window = 15;
mode = 2;

%%

% initialize disparity
im2_disp = int16(zeros(n_y, n_x));

tic;
for x = 1:(n_x-64)
    for y = 1:n_y
        disp = 1;
        min_cost = 1e6;
        for d = 1 : 64
            cost = costFtn(im2, im6, size_window, x, y, d, mode);
            if (cost < min_cost)
                min_cost = cost;
                disp = d;
            end
        end
        im2_disp(y, x) = 4*disp;
    end
end
toc;
%%

im2_truth = imread('cones/disp2.png');

im2_error = int16(im2_disp) - int16(im2_truth);

count = 0;

for x = 1:n_x - 64
    for y = 1:n_y
        if (im2_error(y, x) < 3 && im2_error(y, x) > -3)
            count = count + 1;
        end
    end
end

pix_error = count / ((n_x-64) * n_y) % error ratio
rms_element = sum(im2_error(:,1:end-64).^2, 'all');
rms_error = sqrt( real(rms_element) / ((n_x-64) * n_y) ) % rms pixel error [px]

%% visualize
figure(1)
imshow(uint8(im2_disp))
figure(2)
imshow(uint8(abs(im2_error(:,1:end-64))))