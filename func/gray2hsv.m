% 灰度图映射到Parula进行伪彩色显示
function coloredImage = gray2hsv(grayImage)
    
    % 假设grayImage是你已经创建或读取的灰度图像数据
    % grayImage = rgb2gray(grayImage); % 确保图像是灰度格式

    % 生成颜色映射矩阵
    colorMap = hsv(256); % parula颜色图的256级
    
    % 应用颜色映射
    coloredImage = zeros(size(grayImage, 1), size(grayImage, 2), 3);
    red = colorMap(:, 1);
    green = colorMap(:, 2);
    blue = colorMap(:, 3);
    for i = 1:size(grayImage, 1)
        for j = 1:size(grayImage, 2)
            if grayImage(i, j) == 0
                coloredImage(i, j, 1) = red(1);
                coloredImage(i, j, 2) = green(1);
                coloredImage(i, j, 3) = blue(1);
            else
                coloredImage(i, j, 1) = red(grayImage(i, j));
                coloredImage(i, j, 2) = green(grayImage(i, j));
                coloredImage(i, j, 3) = blue(grayImage(i, j));
            end
        end
    end

    % 将彩色图像数据类型转换为可接受的格式
    coloredImage = im2uint8(coloredImage);

    % % 保存彩色图像
    % imwrite(coloredImage, 'parula_colored_image.png');
        
