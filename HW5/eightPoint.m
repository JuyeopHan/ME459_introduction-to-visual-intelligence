function [F, set_epi_dist1, set_epi_dist2] = eightPoint(image1, image2, feature_1,feature_2, mode)
% mode == 0 : eight point algorithm
% mode == 1 : normalized eight point algorithm

original_feature_1 = feature_1;
original_feature_2 = feature_2;

num_feat = size(feature_1, 2);



%% Fundamental matrix

if (mode == 1)
    % normalization
    [feature_1, T1] = normalise2dpts(feature_1);
    [feature_2, T2] = normalise2dpts(feature_2);
end

% contraint matrix
A = [feature_2(1,:)'.*feature_1(1,:)', feature_2(1,:)'.*feature_1(2,:)' feature_2(1,:)' ...
    feature_2(2,:)'.*feature_1(1,:)', feature_2(2,:)'.*feature_1(2,:)' feature_2(2,:)' ...
    feature_1(1,:)', feature_1(2,:)', ones(num_feat, 1)];

[U, D, V] = svd(A);

% fundamental matrix from the last commum of V corresponding the smallest
% eig.val.
F = reshape(V(:,9), 3, 3)';

% rank 2 constraint
[U, D, V] = svd(F);
F = U * diag([D(1,1), D(2,2), 0])*V';


if (mode == 1)
    % denormalization
    F = T2'*F*T1;
end

%%

% epiplar point
e1 = null(F); e1 = e1/e1(3);
e2 = null(F'); e2 = e2/e2(3);

% initialize estimated point epipolar distance
set_p1_est = [];
set_p2_est = [];

set_epi_dist1 = [];
set_epi_dist2 = [];


for i = 1:num_feat
    
    p1 = original_feature_1(:, i);
    p2 = original_feature_2(:, i);
    
    % epipolar line
    l1 = F'*p2; l2 = F*p1;
    
    % epipolar distance
    epi_dist1 = abs(dot(l1, p1))/sqrt(l1(1)^2 + l1(2)^2);
    epi_dist2 = abs(dot(l2, p2))/sqrt(l2(1)^2 + l2(2)^2);
    
    % estimated pixel point
    p1_est = [p1(1), -(l1(1)*p1(1) + l1(3))/l1(2), 1];
    p2_est = [p2(1), -(l2(1)*p2(1) + l2(3))/l2(2), 1];
    
    set_p1_est = [set_p1_est; p1_est];
    set_p2_est = [set_p2_est; p2_est];
    
    set_epi_dist1 = [set_epi_dist1 epi_dist1];
    set_epi_dist2 = [set_epi_dist2 epi_dist2];
end

%% Visualization

figure(2*mode + 1);
imshow(image1);
hold on;
for i = 1:num_feat
    plot(original_feature_1(1, i),original_feature_1(2, i), 'r+', 'MarkerSize', 3, 'LineWidth', 2);
    % visualize epipolar line
    line([e1(1), set_p1_est(i, 1)], [e1(2), set_p1_est(i, 2)] , 'Color', 'g');
end

pause(0.5);

figure(2*mode + 2);
imshow(image2);
hold on;
for i = 1:num_feat
    plot(original_feature_2(1, i),original_feature_2(2, i), 'r+', 'MarkerSize', 3, 'LineWidth', 2);
    % visualize epipolar line
    line([e2(1), set_p2_est(i, 1)], [e2(2), set_p2_est(i, 2)], 'Color', 'g');
end

pause(0.5);

end

