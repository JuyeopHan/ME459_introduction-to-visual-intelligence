function H = Homography(former,latter)
[n_p, d_p] = size(former);

% initialize A
A = zeros(2*n_p, 3*d_p);

for i = 1:n_p
    A(2*(i-1) + 1, :) = [zeros(1,3), -former(i,:), latter(i,2)*former(i,:)];
    A(2*(i-1) + 2, :) = [former(i,:) ,zeros(1,3), -latter(i,1)*former(i,:)];
end

[U, D, V] = svd(A);

% translation vector expressed in the camera frame
H = reshape(V(:, 3*d_p), [3, 3])';
end

