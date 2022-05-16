function bool = checkBdry(n_x, n_y, x, y)

    if (1 <= x && x <= n_x && 1 <= y && y <= n_y)
        bool = true;
    else
        bool = false;
    end

end
