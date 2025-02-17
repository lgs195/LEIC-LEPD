clc
clear all
close all
%将一串图片转为视频 

file = 'D:\三甲港\ship\夜间\热交叉\avi3\example\';

read_file = [file, 'Raw\'];
%创建视频文件并打开 
vidObj = VideoWriter([read_file,'output']);
open(vidObj);
%将图片写入视频
for n = 10:10:2000
    path = strcat(read_file, num2str(n),'.png'); %路径以及图片名称  
    f = imread(path);                 %读取图片
    writeVideo(vidObj,f);             %写入视频
end
% 关闭视频文件
close(vidObj);

read_file = [file,'S0_HDR\'];
%创建视频文件并打开 
vidObj = VideoWriter([read_file,'output']);
open(vidObj);
%将图片写入视频
for n = 10:10:2000
    path = strcat(read_file, num2str(n),'.png'); %路径以及图片名称  
    f = imread(path);                 %读取图片
    writeVideo(vidObj,f);             %写入视频
end
% 关闭视频文件
close(vidObj);

read_file = [file,'DoLP\'];
%创建视频文件并打开 
vidObj = VideoWriter([read_file,'output']);
open(vidObj);
%将图片写入视频
for n = 10:10:2000
    path = strcat(read_file, num2str(n),'.png'); %路径以及图片名称  
    f = imread(path);                 %读取图片
    writeVideo(vidObj,f);             %写入视频
end
% 关闭视频文件
close(vidObj);

read_file = [file,'AoLP\'];
%创建视频文件并打开 
vidObj = VideoWriter([read_file,'output']);
open(vidObj);
%将图片写入视频
for n = 10:10:2000
    path = strcat(read_file, num2str(n),'.png'); %路径以及图片名称  
    f = imread(path);                 %读取图片
    writeVideo(vidObj,f);             %写入视频
end
% 关闭视频文件
close(vidObj);

read_file = [file,'Denoise\'];
%创建视频文件并打开 
vidObj = VideoWriter([read_file,'output']);
open(vidObj);
%将图片写入视频
for n = 10:10:2000
    path = strcat(read_file, num2str(n),'.png'); %路径以及图片名称  
    f = imread(path);                 %读取图片
    writeVideo(vidObj,f);             %写入视频
end
% 关闭视频文件
close(vidObj);