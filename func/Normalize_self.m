function OutImg = Normalize_self(InImg, xmin, xmax, ymin, ymax)
    % ymax=255.;ymin=0.;
    % xmax = max(max(InImg)); %求得InImg中的最大值
    % xmin = min(min(InImg)); %求得InImg中的最小值
    InImg(InImg>xmax) = xmax; %限制InImg中的值在xmax和xmin之间
    InImg(InImg<xmin) = xmin;
    OutImg = (ymax-ymin).*(InImg-xmin)./(xmax-xmin) + ymin; %归一化

    % clip
    OutImg(OutImg>ymax) = ymax;
    OutImg(OutImg<ymin) = ymin;
end