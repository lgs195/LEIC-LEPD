clc
clear all;

path = './dataset/VIS/';  % lwir
save_path = './results/VIS/';
files = dir([path, '*.tiff']);
len = length(files);
name = {};

time_cum = zeros(1,len);

for ii = 1 : 12

    % print
    fprintf('%d\n', ii);

    %% 1. read poalrization images
    filename = strcat(path, '/', files(ii).name);
    I0 = imread(filename);
    I = I0;
    I2 = double(rgb2gray(I));

    %% 2. BM3D denoising
    maxI = max(max(I2));
    minI = min(min(I2));
    widthI = maxI - minI;
    I2 = (I2 - minI)/widthI;
    [~, Id] = BM3D(1, I2, 1.2, 'lc', 0);
    Id = Id*widthI + minI;

    %% preparations
    % Id = double(rgb2gray(I));
    mosaic = zeros(size(Id,1), size(Id,2), 4);
    mask = zeros(size(Id,1), size(Id,2), 4); 

    rows1 = 1:2:size(Id, 1);
    rows2 = 2:2:size(Id, 1);
    cols1 = 1:2:size(Id, 2);
    cols2 = 2:2:size(Id, 2);

    mask(rows1, cols1, 1) = 1;
    mask(rows1, cols2, 2) = 1;
    mask(rows2, cols1, 4) = 1;
    mask(rows2, cols2, 3) = 1;

    mask_P0 = mask(:,:,1);
    mask_P45 = mask(:,:,2);
    mask_P90 = mask(:,:,3);
    mask_P135 = mask(:,:,4);

    mosaic(:,:,1) = Id .* mask(:,:,1); 
    mosaic(:,:,2) = Id .* mask(:,:,2);
    mosaic(:,:,3) = Id .* mask(:,:,3);
    mosaic(:,:,4) = Id .* mask(:,:,4);

    MPFA = Id;

    %% 3. demosaicing
    % LEIC
    k = 1;
    time1 = clock;
    [I0_leic,I45_leic,I90_leic,I135_leic] = leic(mosaic,mask, k);
    time2 = clock;
    demosaic_time_leic = etime(time2,time1);
    
    %% 4. Calculate the Stokes parameters, DoLP and AoLP
    [S0_leic,S1_leic,S2_leic,DOLP_leic,AOLP_leic] = calculateStokes_VIS(I0_leic,I45_leic,I90_leic,I135_leic);
    DOLP_leic(isnan(DOLP_leic)) = 0;

    %% 5. visualization
    % window size
    figure('Position', [100, 100, 900, 500]);
    % show
    subplot(1, 2, 1),imshow(DOLP_leic(17:end-16,17:end-16), [0, 0.6]);colormap Parula;colorbar;title('DoLP_{color}')
    subplot(1, 2, 2),imshow(AOLP_leic(17:end-16,17:end-16) + 90, []);colormap Parula;colorbar;title('AoLP_{color}')
    fprintf('over! time = %.4f s\n', demosaic_time_leic);
    
    %% save
    I_show = uint8(Normalize_255(I(17:end-16,17:end-16)/2));
    Id_show = uint8(Normalize_255(Id(17:end-16,17:end-16)));

    
    S0_show_leic = uint8(Normalize_255(S0_leic(17:end-16,17:end-16)));
    
    % xmax = max(max(DOLP_leic(17:end-16,17:end-16))); %求得InImg中的最大值
    % xmin = min(min(DOLP_leic(17:end-16,17:end-16))); %求得InImg中的最小值
    xmin = 0;
    xmax = 0.3;
    DOLP_show_leic = uint8(Normalize_self(DOLP_leic(17:end-16,17:end-16), xmin, xmax, 0, 255));

    DOLP_show_leic(isnan(DOLP_show_leic)) = 0;
    DOLP_show_leic(isinf(DOLP_show_leic)) = 255;

    DOLP_parula_show_leic = gray2parula(DOLP_show_leic);
    AOLP_show_leic = uint8((AOLP_leic(17:end-16,17:end-16)+90)/180*255);

    AOLP_hsv_show_leic = gray2hsv(AOLP_show_leic);

    % fprintf(uint8(ii))

    imname = files(ii).name;
    i_name = find('.'==imname);
     %去除文件后缀，提取单纯的文件名
    imname = imname(1: i_name-1);
    % method_name = 'LEIC';
    save_raw_path = strcat(save_path, '/', imname, '/raw/');
    save_denoise_path = strcat(save_path, '/', imname, '/denoise/');
    save_s0_path = strcat(save_path, '/', imname, '/s0/');
    save_dolp_path = strcat(save_path, '/', imname, '/dolp/');
    save_dolp_parula_path = strcat(save_path, '/', imname, '/dolp_parula/');
    save_aolp_path = strcat(save_path, '/', imname, '/aolp/');
    save_aolp_hsv_path = strcat(save_path, '/', imname, '/aolp_hsv/');
    mkdir(save_raw_path);
    mkdir(save_denoise_path);
    mkdir(save_s0_path);
    mkdir(save_dolp_path);
    mkdir(save_dolp_parula_path);
    mkdir(save_aolp_path);
    mkdir(save_aolp_hsv_path);

    imwrite(I_show, strcat(save_raw_path, 'I.png'));
    imwrite(Id_show, strcat(save_denoise_path, 'Id.png'));
    imwrite(S0_show_leic, strcat(save_s0_path, 'S0_leic.png'));
    imwrite(DOLP_show_leic, strcat(save_dolp_path, 'DOLP_leic.png'));
    imwrite(DOLP_parula_show_leic, strcat(save_dolp_parula_path, 'DOLP_parula_leic.png'));
    imwrite(AOLP_show_leic, strcat(save_aolp_path, 'AOLP_leic.png'));
    imwrite(AOLP_hsv_show_leic, strcat(save_aolp_hsv_path, 'AOLP_hsv_leic.png'));
    
end