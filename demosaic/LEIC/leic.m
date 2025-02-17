function [i0, i45, i90, i135] = leic(mosaic, mask, kLogistic)

    MPFA = mosaic(:, :, 1) + mosaic(:, :, 2) + mosaic(:, :, 3) + mosaic(:, :, 4);

    Imax = max(MPFA(:));
    Imin = min(MPFA(:));

    [i0, i45, i90, i135] = lepd(MPFA, kLogistic);
    i_led = cat(3, i0, i45, i90, i135);

    %% eq(8)
    weight_orth = 1/(1+2*sqrt(2));
    weight_no_orth = sqrt(2)/(1+2*sqrt(2));
    
    %% The convolution kernel for bilinear interpolation in eq(13)
    conv_kernel = [1, 2, 1;
                   2, 4, 2;
                   1, 2, 1]/4;

    array = [4,1,2,3,4,1,2];
    demosaic = zeros(size(i_led,1), size(i_led,2),4);

    for k = 1:4
        
        %% eq(14)
%         mosaic = MPFA .* mask(:,:,array(k+1));
        i_diff_1 = mosaic(:,:,array(k+1)) - i_led(:,:,array(k)).*mask(:,:,array(k+1));    
        i_diff_2 = mosaic(:,:,array(k+1)) - i_led(:,:,array(k+2)).*mask(:,:,array(k+1));
        i_diff_3 = mosaic(:,:,array(k+1)) - i_led(:,:,array(k+3)).*mask(:,:,array(k+1));

        i_1 = conv2(i_diff_1, conv_kernel, "same");
        i_2 = conv2(i_diff_2, conv_kernel, "same");
        i_3 = conv2(i_diff_3, conv_kernel, "same");
        
        %% eq(15)
        i_1 = i_led(:,:,array(k)) + i_1;
        i_2 = i_led(:,:,array(k+2)) + i_2;
        i_3 = i_led(:,:,array(k+3)) + i_3;

        demosaic(:,:,array(k+1)) = weight_no_orth*(i_1 + i_2) + weight_orth*i_3;
        % demosaic(:,:,array(k+1)) = 0.5*(i_1 + i_2);

    end

    % i0   = i_led(:,:,1);
    % i45  = i_led(:,:,2);
    % i90  = i_led(:,:,3);
    % i135 = i_led(:,:,4);

    % % %% clip i_led范围限制在0-255
    % demosaic(demosaic<Imin) = Imin;
    % demosaic(demosaic>Imax) = Imax;

    i0   = demosaic(:,:,1);
    i45  = demosaic(:,:,2);
    i90  = demosaic(:,:,3);
    i135 = demosaic(:,:,4);

    % i0   = i0   ./ 255 .* Imax;
    % i45  = i45  ./ 255 .* Imax;
    % i90  = i90  ./ 255 .* Imax;
    % i135 = i135 ./ 255 .* Imax;

end