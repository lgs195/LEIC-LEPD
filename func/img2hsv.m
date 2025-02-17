function img_fusion = img2hsv(s0, dolp, aop)

    k_max = 0.15;
    k_min = 0.10;

    % 0-1
    S0 = Normalize(s0);
    AoP = Normalize(aop);
    DoLP = Normalize(dolp);
    % dolp(dolp>k_max) = k_max;
    % dolp(dolp<k_min) = k_min; 

    % hsv
    h = AoP;
    % s = DoLP;
    s = ones(size(dolp));
    % v = s0;
    % v = 0.7 * s0 + 0.3 * dolp;
    % v = 0.3 * (1 - s0) + 0.7 * dolp;
    % v = S0;
    v = ones(size(s0));
    % v(k_min<dolp<k_max) = DoLP(k_min<dolp<k_max);
    img_hsv = cat(3, h, s, v);
    img_fusion = hsv2rgb(img_hsv);
end


