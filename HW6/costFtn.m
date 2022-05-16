function cost = costFtn(img_left, img_right, size_window, x, y, d, mode)
% img_left      : left image
% img_right     : right image
% size_window  : size of window
% x, y : pixel of the right image
% d : disparity
% mode == 0 : SSD, Sum of Squared Differences
% mode == 1 : SAD, Sum of Absolute Differences
% mode == 2 : NCC, Normalized Cross Correlation

[n_y, n_x, ~] = size(img_left);

    % compute valid window size
    left_x_min = -100; left_x_max = 100;
    right_x_min = -100; right_x_max = 100;
    
    y_min = -100; y_max = 100;
    
    for i =  -(size_window - 1)/2 : 0
            if(checkBdry(n_x, n_y, x + i, y) == true)
                right_x_min = i;
                break;
            end
    end
    for i =  (size_window - 1)/2:-1:0
            if(checkBdry(n_x, n_y, x + i, y) == true)
                right_x_max = i;
                break;
            end
    end
    
    for i =  -(size_window - 1)/2 : 0
            if(checkBdry(n_x, n_y, x + d + i, y) == true)
                left_x_min = i;
                break;
            end
    end
    for i =  (size_window - 1)/2:-1:0
            if(checkBdry(n_x, n_y, x + d + i, y) == true)
                left_x_max = i;
                break;
            end
    end
    
    
    
    for j =  -(size_window - 1)/2 : 0
            if(checkBdry(n_x, n_y, x, y + j) == true)
                y_min = j;
                break;
            end
    end
    for j =  (size_window - 1)/2:-1:0
            if(checkBdry(n_x, n_y, x, y + j) == true)
                y_max = j;
                break;
            end
    end

x_min = max(left_x_min, right_x_min);
x_max = min(left_x_max, right_x_max);




cost = 0;

if (mode == 0)
    for i =  x_min : x_max
        for j =  y_min : y_max
            % calculate cost only if the pixel is in the boundary
            disp = (img_left(y + j, x + d + i) - img_right(y + j, x + i)) * (img_left(y + j, x + d + i) - img_right(y + j, x + i));
            cost = cost + disp;
            %end
        end
    end
end

if (mode == 1)
    for i =  x_min : x_max
        for j =  y_min : y_max
            % calculate cost only if the pixel is in the boundary
            disp = abs(img_left(y + j, x + d + i) - img_right(y + j, x + i));
            cost = cost + disp;
        end
    end
end

if (mode == 2)
    x_len = x_max - x_min + 1;
    y_len = y_max - y_min + 1;
    % compute correlation sum
    mean_right = 0;
    mean_left = 0;
    std_right = 0;
    std_left = 0;
    
    for i =  x_min : x_max
        for j =  y_min : y_max
            mean_right = mean_right + img_right(y + j, x + i);
            mean_left = mean_left + img_left(y + j, x + d + i);
        end
    end
    
    mean_right = double(mean_right) / (x_len * y_len);
    mean_left = double(mean_left) / (x_len * y_len);
    
    for i =  x_min : x_max
        for j =  y_min : y_max
            std_right = std_right + (double(img_right(y + j, x + i)) - mean_right) * (double(img_right(y + j, x + i)) - mean_right);
            std_left = std_left + (double(img_left(y + j, x + d + i)) - mean_left) * (double(img_left(y + j, x + d + i)) - mean_left);
        end
    end
    
    
    std_right = sqrt(double(std_right) / (x_len * y_len));
    std_left = sqrt(double(std_left) / (x_len * y_len));
    
    for i =  x_min : x_max
        for j =  y_min : y_max
            cost = cost + (double(img_right(y + j, x + i)) - mean_right) * (double(img_left(y + j, x + d + i)) - mean_left);
        end
    end
    cost = -cost / (std_right * std_left * x_len * y_len * x_len * y_len);
    
    
end

end

