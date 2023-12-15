function p_transf = applyTransfToPoints(p, RT)
    if (size(p,1) == 3)
        p = std2hom(p);
    end
    p_transf = RT * p;
    p_transf = p_transf(1:3, :);
end