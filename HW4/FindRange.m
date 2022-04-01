function [min_x, max_x, min_y, max_y] = FindRange(v, min_x, max_x, min_y, max_y)

x = v(1); y = v(2);

if (x < min_x)
    min_x = x;
end

if (x > max_x)
    max_x = x;
end

if (y < min_y)
    min_y = y;
end

if (y > max_y)
    max_y = y;
end

end

