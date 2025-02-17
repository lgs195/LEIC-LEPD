function img_fusion = img2hsv_2(s0, dolp, aop)

    k = 0.2;
    % 0-1
    s0 = Normalize(s0);
    aop = Normalize(aop);
    % dolp(dolp>k) = k;
    dolp = Normalize(dolp);

    % hsv
    h = aop;
    s = dolp;
    % v = s0;
    v = 0.7 * s0 + 0.3 * dolp;
    img_hsv = cat(3, h, s, v);
    img_fusion = hsv2rgb(img_hsv);
end