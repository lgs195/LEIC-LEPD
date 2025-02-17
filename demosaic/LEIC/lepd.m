function [i0, i45, i90, i135] = lepd(MPFA, kLogistic)

    % Imax = max(MPFA(:));
    % Imin = min(MPFA(:));
    % MPFA = MPFA ./ Imax * 255;

    %% size
    rows = size(MPFA, 1);
    cols = size(MPFA, 2);

    %% 1. HA方法计算对角通道平面:(对角方向梯度计算)(对角方向权重计算)(对角通道平面计算)
    %% Step1. d&a neighbor channel interpolation
    i_da = zeros(rows, cols);
    i_residual = zeros(rows, cols);
    % factor
    for i=3:rows-2
        for j=3:cols-2
            % d direction HA 
            d1d = 1/(2^1.5)*(MPFA(i-1, j+1) - MPFA(i+1, j-1));              % 45°一阶偏导
            d2d = (1/8)*(2.*MPFA(i, j) - MPFA(i-2, j+2) - MPFA(i+2, j-2));  % 45°二阶偏导
            gd = 0.5*(MPFA(i-1, j+1) + MPFA(i+1, j-1));                     % 45°一阶估计
            vd = abs(d1d) + (2^1.5)*abs(d2d);                         % 45°梯度
            ed = gd + d2d;
            % a direction HA
            d1a = 1/(2^1.5)*(MPFA(i+1, j+1) - MPFA(i-1, j-1));              % -45°一阶偏导
            d2a = (1/8)*(2.*MPFA(i, j) - MPFA(i-2, j-2) - MPFA(i+2, j+2));  % -45°二阶偏导
            ga = 0.5*(MPFA(i-1, j-1) + MPFA(i+1, j+1));                     % -45°一阶估计
            va = abs(d1a) + (2^1.5)*abs(d2a);                         % -45°梯度
            ea = ga + d2a;
            ddv1 = vd - va;
            wd = 1/(1+exp(ddv1*kLogistic));
            wa = 1-wd;
            i_da(i,j) = wd * ed + wa * ea;
            i_residual(i,j) = MPFA(i,j) - i_da(i,j);
        end
    end

    %% 4. 恢复水平和垂直通道值:(HA方法粗恢复通道值)(HA方法恢复水平和垂直残差通道值)(残差通道+另一方向粗估计得到最终估计)
    % HA粗估计
    % label the different polarization channels
    O = zeros(rows,cols);
    O(1:2:rows,1:2:cols) = 1;
    O(1:2:rows,2:2:cols) = 2;
    O(2:2:rows,2:2:cols) = 3;
    O(2:2:rows,1:2:cols) = 4;

    i_led = zeros(rows,cols,4);
    for i=3:rows-2
        for j=3:cols-2
            % d direction HA 
            d1h = 0.5 * (i_residual(i, j+1) - i_residual(i, j-1));                 % 水平一阶偏导
            d2h = 0.25 * (2.*i_residual(i, j) - i_residual(i, j+2) - i_residual(i, j-2));  % 水平二阶偏导
            vh = abs(d1h) + 2 * abs(d2h);                  % 水平残差梯度
            % a direction HA
            d1v = 0.5 * (i_residual(i+1, j) - i_residual(i-1, j));                 % 垂直一阶偏导
            d2v = 0.25 * (2.*i_residual(i, j) - i_residual(i+2, j) - i_residual(i-2, j));  % 垂直二阶偏导
            vv = abs(d1v) + 2 * abs(d2v);                  % 垂直残差梯度
            ddv2 = vh - vv;
            wh = 1/(1+exp(ddv2*kLogistic));
            wv = 1-wh;
            % rough estimate
            d2h = 2*MPFA(i,j) - MPFA(i,j+2) - MPFA(i,j-2);
            d2v = 2*MPFA(i,j) - MPFA(i+2,j) - MPFA(i-2,j);
            % final estimate
            i_led(i,j,O(i,j)) = MPFA(i,j);
            i_led(i,j,O(i+1,j+1)) = i_da(i,j);
            i_led(i,j,O(i,j+1)) = wh*(0.5*(MPFA(i,j-1) + MPFA(i,j+1)) + 0.25*d2h) + ...
                                  wv*(0.5*(i_da(i-1,j) + i_da(i+1,j)) + 0.25*d2v);
            i_led(i,j,O(i+1,j)) = wh*(0.5*(i_da(i,j-1) + i_da(i,j+1)) + 0.25*d2h) + ...
                                  wv*(0.5*(MPFA(i-1,j) + MPFA(i+1,j)) + 0.25*d2v);
        end
    end

    % % %% 5. 恢复亮度通道值
    % i_led(:,:,1) = i_led(:,:,1) ./ 255 .* Imax;
    % i_led(:,:,2) = i_led(:,:,2) ./ 255 .* Imax;
    % i_led(:,:,3) = i_led(:,:,3) ./ 255 .* Imax;
    % i_led(:,:,4) = i_led(:,:,4) ./ 255 .* Imax;

    % % %% clip i_led范围限制在0-255
    % i_led(i_led<Imin) = Imin;
    % i_led(i_led>Imax) = Imax;

    i0   = i_led(:,:,1);
    i45  = i_led(:,:,2);
    i90  = i_led(:,:,3);
    i135 = i_led(:,:,4);

end