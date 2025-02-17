%% 把图片序列转换为GIF
clear;clc;
dir='G:\技物所\数据集\三甲港/ship\白天\晴朗/avi3/example1\';%图片所在文件夹，注意别忘了最后的\
framesPath = dir;%图像序列所在路径，同时要保证图像大小相同

fps = 50; %帧率
startFrame = 150; %从哪一帧开始
endFrame = 899; %哪一帧结束
a = 1;
b = 1;

%% hsv
read_file = [framesPath, 'hsv\'];
gifName =[read_file,'GIF_1.gif'];%默认GIF文件名为GIF.gif,位置为图片序列所在位置
for i = startFrame:endFrame
    n = a*(i-1)+b;
    %%
    % 绘制图像或者读取图像
    path = strcat(read_file, num2str(n),'.png');
%     im=imread(path);
    im_1=imread(path);
    % im = im_1(46:1014, 592:1357, :);
    im = im_1;
    %%
    % 写入gif过程
    [A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
    if i == startFrame
        imwrite(A,map,gifName,'gif','LoopCount',Inf,'DelayTime',1.0/fps);  % DelayTime表示写入的时间间隔
    else
        imwrite(A,map,gifName,'gif','WriteMode','append','DelayTime',1.0/fps);
    end
end

%% S0
read_file = [framesPath, 'S0_HDR\'];
gifName =[read_file,'GIF_1.gif'];%默认GIF文件名为GIF.gif,位置为图片序列所在位置
for i = startFrame:endFrame
    n = a*(i-1)+b;
    %%
    % 绘制图像或者读取图像
    path = strcat(read_file, num2str(n),'.png');
%     im=imread(path);
    im_1=imread(path);
    % im = im_1(46:1014, 592:1357, :);
    im = im_1;
    %%
    % 写入gif过程
    [A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
    if i == startFrame
        imwrite(A,map,gifName,'gif','LoopCount',Inf,'DelayTime',1.0/fps);  % DelayTime表示写入的时间间隔
    else
        imwrite(A,map,gifName,'gif','WriteMode','append','DelayTime',1.0/fps);
    end
end

%% DoLP
read_file = [framesPath, 'DoLP\'];
gifName =[read_file,'GIF_1.gif'];%默认GIF文件名为GIF.gif,位置为图片序列所在位置
for i = startFrame:endFrame
    n = a*(i-1)+b;
    %%
    % 绘制图像或者读取图像
    path = strcat(read_file, num2str(n),'.png');
%     im=imread(path);
    im_1=imread(path);
    % im = im_1(46:1014, 592:1357, :);
    im = im_1;
    %%
    % 写入gif过程
    [A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
    if i == startFrame
        imwrite(A,map,gifName,'gif','LoopCount',Inf,'DelayTime',1.0/fps);  % DelayTime表示写入的时间间隔
    else
        imwrite(A,map,gifName,'gif','WriteMode','append','DelayTime',1.0/fps);
    end
end

%% DoLP_color
% read_file = [framesPath, 'DoLP_color\'];
% gifName =[read_file,'GIF_1.gif'];%默认GIF文件名为GIF.gif,位置为图片序列所在位置
% for i = startFrame:endFrame
%     n = a*(i-1)+b;
%     %%
%     % 绘制图像或者读取图像
%     path = strcat(read_file, num2str(n),'.png');
% %     im=imread(path);
%     im_1=imread(path);
%     % im = im_1(46:1014, 592:1357, :);
%     im = im_1;
%     %%
%     % 写入gif过程
%     [A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%     if i == startFrame
%         imwrite(A,map,gifName,'gif','LoopCount',Inf,'DelayTime',1.0/fps);  % DelayTime表示写入的时间间隔
%     else
%         imwrite(A,map,gifName,'gif','WriteMode','append','DelayTime',1.0/fps);
%     end
% end

%% AoLP
read_file = [framesPath, 'AoLP\'];
gifName =[read_file,'GIF_1.gif'];%默认GIF文件名为GIF.gif,位置为图片序列所在位置
for i = startFrame:endFrame
    n = a*(i-1)+b;
    %%
    % 绘制图像或者读取图像
    path = strcat(read_file, num2str(n),'.png');
%     im=imread(path);
    im_1=imread(path);
    % im = im_1(46:1014, 592:1357, :);
    im = im_1;
    %%
    % 写入gif过程
    [A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
    if i == startFrame
        imwrite(A,map,gifName,'gif','LoopCount',Inf,'DelayTime',1.0/fps);  % DelayTime表示写入的时间间隔
    else
        imwrite(A,map,gifName,'gif','WriteMode','append','DelayTime',1.0/fps);
    end
end
