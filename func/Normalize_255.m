function OutImg = Normalize_255(InImg)
    ymax=255.;ymin=0.;
    % xmax = max(max(InImg)); %求得InImg中的最大值
    % xmin = min(min(InImg)); %求得InImg中的最小值
    xmax = max(max(InImg(17:end-16,17:end-16))); %求得InImg中的最大值
    xmin = min(min(InImg(17:end-16,17:end-16))); %求得InImg中的最小值
    OutImg = (ymax-ymin).*(InImg-xmin)./(xmax-xmin) + ymin; %归一化
end