function [i_led, wd, wa, wh, wv] = lepd2(MPFA, kLogistic)
    
    %% size
    rows = size(MPFA, 1);
    cols = size(MPFA, 2);

    %% 1. HA方法计算对角通道平面:(对角方向梯度计算)(对角方向权重计算)(对角通道平面计算)
    %% Step1. d&a neighbor channel interpolation
    % Edge intensity
    vd = zeros(rows, cols);
    va = zeros(rows, cols);
    % Estimation value
    ed = zeros(rows, cols);
    ea = zeros(rows, cols);

    i_da = zeros(rows, cols);
    i_residual = zeros(rows, cols);
    % factor
    kweight1 = 1;
    % kweight2 = 1;
    for i=3:rows-2
        for j=3:cols-2
            % d direction HA 
            d1d = 1/(2^1.5)*(MPFA(i-1, j+1) - MPFA(i+1, j-1));              % 45°一阶偏导
            d2d = (1/8)*(2.*MPFA(i, j) - MPFA(i-2, j+2) - MPFA(i+2, j-2));  % 45°二阶偏导
            gd = 0.5*(MPFA(i-1, j+1) + MPFA(i+1, j-1));                     % 45°一阶估计
            vd(i, j) = abs(d1d) + (2^1.5)*abs(d2d);                         % 45°梯度
            ed(i, j) = gd + kweight1*d2d;
            % a direction HA
            d1a = 1/(2^1.5)*(MPFA(i+1, j+1) - MPFA(i-1, j-1));              % -45°一阶偏导
            d2a = (1/8)*(2.*MPFA(i, j) - MPFA(i-2, j-2) - MPFA(i+2, j+2));  % -45°二阶偏导
            ga = 0.5*(MPFA(i-1, j-1) + MPFA(i+1, j+1));                     % -45°一阶估计
            va(i, j) = abs(d1a) + (2^1.5)*abs(d2a);                         % -45°梯度
            ea(i, j) = ga + kweight1*d2a;
            d1d = 0;
            d2d = 0;
            d1a = 0;
            d2a = 0;
            gd = 0;
            ga = 0;
        end
    end

    %% Step2. Logistic Edge Sensing
    % kLogistic1 = 0.5;
    ddv1 = vd - va;
    [wd,wa] = Logistic_e(ddv1, kLogistic);

    %% Step3. Weight fusion
    i_da = wd .* ed + wa .* ea;

    %% 2. 计算对角与原始通道残差平面
    i_residual = MPFA - i_da;

    %% 3. 在残差平面计算h和v方向的残差梯度 & 方向权重
    %% Step1. d&a neighbor channel interpolation
    % Edge intensity
    vh = zeros(rows, cols);
    vv = zeros(rows, cols);

    for i=3:rows-2
        for j=3:cols-2
            % d direction HA 
            d1h = 0.5 * (i_residual(i, j+1) - i_residual(i, j-1));                 % 水平一阶偏导
            d2h = 0.25 * (2.*i_residual(i, j) - i_residual(i, j+2) - i_residual(i, j-2));  % 水平二阶偏导
            vh(i, j) = abs(d1h) + 2 * abs(d2h);                  % 水平残差梯度
            % a direction HA
            d1v = 0.5 * (i_residual(i+1, j) - i_residual(i-1, j));                 % 垂直一阶偏导
            d2v = 0.25 * (2.*i_residual(i, j) - i_residual(i+2, j) - i_residual(i-2, j));  % 垂直二阶偏导
            vv(i, j) = abs(d1v) + 2 * abs(d2v);                  % 垂直残差梯度
            d1h = 0;
            d2h = 0;
            d1v = 0;
            d2v = 0;
        end
    end

    %% Step2. Logistic Edge Sensing
    % kLogistic2 = 0.5;
    ddv2 = vh - vv;
    [wh,wv] = Logistic_e(ddv2, kLogistic);

    %% 4. 恢复水平和垂直通道值:(HA方法粗恢复通道值)(HA方法恢复水平和垂直残差通道值)(残差通道+另一方向粗估计得到最终估计)
    % HA粗估计
    % label the different polarization channels
    O = zeros(rows,cols);
    O(1:2:rows,1:2:cols) = 1;
    O(1:2:rows,2:2:cols) = 2;
    O(2:2:rows,2:2:cols) = 3;
    O(2:2:rows,1:2:cols) = 4;
    %% 这里可以直接简化！！！！%%
    % i_led = zeros(rows,cols,4);
    % for i=4:rows-3
    %     for j=4:cols-3
    %         % rough estimate
    %         i_led_rough(i,j,O(i,j)) = MPFA(i,j);
    %         i_led_rough(i,j,O(i+1,j+1)) = i_da(i,j);
    %         d2h = 2*MPFA(i,j) - MPFA(i,j+2) - MPFA(i,j-2);
    %         d2v = 2*MPFA(i,j) - MPFA(i+2,j) - MPFA(i-2,j);
    %         i_led_rough(i,j,O(i,j+1)) = weight_h(i,j)*(0.5*(MPFA(i,j-1) + MPFA(i,j+1)) + 0.25*d2h) + ...
    %                                     weight_v(i,j)*(0.5*(i_da(i-1,j) + i_da(i+1,j)) + 0.25*d2v);
    %         i_led_rough(i,j,O(i+1,j)) = weight_h(i,j)*(0.5*(i_da(i,j-1) + i_da(i,j+1)) + 0.25*d2h) + ...
    %                                     weight_v(i,j)*(0.5*(MPFA(i-1,j) + MPFA(i+1,j)) + 0.25*d2v);
    %         % res estimate
    %         i_led_res(i,j,O(i,j)) = i_residual(i,j);
    %         i_led_res(i,j,O(i+1,j+1)) = -i_residual(i,j);
    %         d2h = 2*i_residual(i,j) - i_residual(i,j+2) - i_residual(i,j-2);
    %         d2v = 2*i_residual(i,j) - i_residual(i+2,j) - i_residual(i-2,j);
    %         i_led_res(i,j,O(i,j+1)) = weight_h(i,j)*(0.5*(i_residual(i,j-1) + i_residual(i,j+1)) + 0.25*d2h) - ...
    %                                   weight_v(i,j)*(0.5*(i_residual(i-1,j) + i_residual(i+1,j)) + 0.25*d2v);
    %         i_led_res(i,j,O(i+1,j)) = -weight_h(i,j)*(0.5*(i_residual(i,j-1) + i_residual(i,j+1)) + 0.25*d2h) + ...
    %                                   weight_v(i,j)*(0.5*(i_residual(i-1,j) + i_residual(i+1,j)) + 0.25*d2v);

    %         % final estimate
    %         i_led(i,j,O(i,j)) = i_led_rough(i,j,O(i,j));
    %         i_led(i,j,O(i+1,j+1)) = i_led_rough(i,j,O(i+1,j+1));
    %         i_led(i,j,O(i,j+1)) = i_led_rough(i,j,O(i+1,j)) + i_led_res(i,j,O(i,j+1));
    %         i_led(i,j,O(i+1,j)) = i_led_rough(i,j,O(i,j+1)) + i_led_res(i,j,O(i+1,j));
    %     end
    % end
    i_led = zeros(rows,cols,4);
    for i=3:rows-2
        for j=3:cols-2
            % rough estimate
            i_led(i,j,O(i,j)) = MPFA(i,j);
            i_led(i,j,O(i+1,j+1)) = i_da(i,j);
            d2h = 2*MPFA(i,j) - MPFA(i,j+2) - MPFA(i,j-2);
            d2v = 2*MPFA(i,j) - MPFA(i+2,j) - MPFA(i-2,j);
            % i_led_rough_h = wh(i,j)*(0.5*(MPFA(i,j-1) + MPFA(i,j+1))) + ...
            %                 wv(i,j)*(0.5*(i_da(i-1,j) + i_da(i+1,j)));
            % i_led_rough_v = wh(i,j)*(0.5*(i_da(i,j-1) + i_da(i,j+1))) + ...
            %                 wv(i,j)*(0.5*(MPFA(i-1,j) + MPFA(i+1,j)));
            i_led_rough_h = wh(i,j)*(0.5*(MPFA(i,j-1) + MPFA(i,j+1)) + 0.25*d2h) + ...
                            wv(i,j)*(0.5*(i_da(i-1,j) + i_da(i+1,j)) + 0.25*d2v);
            i_led_rough_v = wh(i,j)*(0.5*(i_da(i,j-1) + i_da(i,j+1)) + 0.25*d2h) + ...
                            wv(i,j)*(0.5*(MPFA(i-1,j) + MPFA(i+1,j)) + 0.25*d2v);
            % res estimate
            d2h = 2*i_residual(i,j) - i_residual(i,j+2) - i_residual(i,j-2);
            d2v = 2*i_residual(i,j) - i_residual(i+2,j) - i_residual(i-2,j);
            % i_led_res_h = wh(i,j)*(0.5*(i_residual(i,j-1) + i_residual(i,j+1)) + 0.25*d2h) - ...
            %               wv(i,j)*(0.5*(i_residual(i-1,j) + i_residual(i+1,j)) + 0.25*d2v);
            % i_led_res_v = -wh(i,j)*(0.5*(i_residual(i,j-1) + i_residual(i,j+1)) + 0.25*d2h) + ...
            %               wv(i,j)*(0.5*(i_residual(i-1,j) + i_residual(i+1,j)) + 0.25*d2v);
            i_led_res_h = wh(i,j)*(0.5*(i_residual(i,j-1) + i_residual(i,j+1))) - ...
                          wv(i,j)*(0.5*(i_residual(i-1,j) + i_residual(i+1,j)));
            i_led_res_v = -wh(i,j)*(0.5*(i_residual(i,j-1) + i_residual(i,j+1))) + ...
                          wv(i,j)*(0.5*(i_residual(i-1,j) + i_residual(i+1,j)));

            d_d = 2*i_residual(i,j) - i_residual(i-2,j+2) - i_residual(i+2,j-2);
            d_a = 2*i_residual(i,j) - i_residual(i+2,j+2) - i_residual(i-2,j-2);
            % i_led_res_da = wd(i,j)*(0.5*(i_residual(i+1,j-1) + i_residual(i-1,j+1)) - 0.25 * d_d) + ...
            %                wa(i,j)*(0.5*(i_residual(i-1,j-1) + i_residual(i+1,j+1)) - 0.25 * d_a);
            % i_led_res_da = wd(i,j)*(0.5*(i_residual(i+1,j-1) + i_residual(i-1,j+1))) + ...
            %                wa(i,j)*(0.5*(i_residual(i-1,j-1) + i_residual(i+1,j+1)));

            % final estimate
            % i_led(i,j,O(i+1,j+1)) = MPFA(i,j) + i_led_res_da;
            % i_led(i,j,O(i,j+1)) = i_led_rough_v + i_led_res_h;
            % i_led(i,j,O(i+1,j)) = i_led_rough_h + i_led_res_v;
            i_led(i,j,O(i,j+1)) = i_led_rough_h;
            i_led(i,j,O(i+1,j)) = i_led_rough_v;
        end
    end

    % %% eq(8)
    % weight_orth = 1/(1+2*sqrt(2));
    % weight_no_orth = sqrt(2)/(1+2*sqrt(2));
    
    % %% The convolution kernel for bilinear interpolation in eq(13)
    % conv_kernel = [1, 2, 1;
    %                2, 4, 2;
    %                1, 2, 1]/4;

    % i0   = i_led(:,:,1);
    % i45  = i_led(:,:,2);
    % i90  = i_led(:,:,3);
    % i135 = i_led(:,:,4);

    % bi = cat(3,i0,i45,i90,i135);
    % array = [4,1,2,3,4,1,2];
    % demosaic = zeros(size(bi,1), size(bi,2),4);

    % for k = 1:4
        
    %     %% eq(14)
    %     i_diff_1 = mosaic(:,:,array(k+1)) - bi(:,:,array(k)).*mask(:,:,array(k+1));    
    %     i_diff_2 = mosaic(:,:,array(k+1)) - bi(:,:,array(k+2)).*mask(:,:,array(k+1));
    %     i_diff_3 = mosaic(:,:,array(k+1)) - bi(:,:,array(k+3)).*mask(:,:,array(k+1));

    %     i_1 = conv2(i_diff_1, conv_kernel, "same");
    %     i_2 = conv2(i_diff_2, conv_kernel, "same");
    %     i_3 = conv2(i_diff_3, conv_kernel, "same");
        
    %     %% eq(15)
    %     i_1 = bi(:,:,array(k)) + i_1;
    %     i_2 = bi(:,:,array(k+2)) + i_2;
    %     i_3 = bi(:,:,array(k+3)) + i_3;

    %     demosaic(:,:,array(k+1)) = weight_no_orth*(i_1 + i_2) + weight_orth*i_3;
    %     % demosaic(:,:,array(k+1)) = 0.5*(i_1 + i_2);

    % end

    % i_led(:,:,1) = demosaic(:,:,1);
    % i_led(:,:,2) = demosaic(:,:,2);
    % i_led(:,:,3) = demosaic(:,:,3);
    % i_led(:,:,4) = demosaic(:,:,4);
end