%importdata_北汽数据
%2016-2-26 by echoc
clear;
clc;
close all;
%将每辆车的数据连缀在一起
FILENAME='E:\Users\SZY\Desktop\DATA';
FILE1=dir(FILENAME);
for order=3:length(FILE1)
    filename='E:\Users\SZY\Desktop\DATA\dbc_4025';
    file1=dir(filename);


M=[];
total_1=zeros(1,19);% 目前数据一共有24列0
tt=1;
s=[];
for NUM=3:3
    str=strcat(filename,'\',file1(NUM).name);
    file=fopen(str);
    title=textscan(file,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'delimiter', ',');  % 读取第一行表头文本
    data=textscan(file,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %s %f %f ','delimiter', ',');     % 读取第二行开始的文本
    temp=zeros(length(data{1,17}),1);
    for i=1:length(data{1,17});
        temp(i,1)=datenum(datestr(data{1,17}(i,1),0));
    end
    data{1,17}=temp;
    data_num=cell2mat(data);
    total_1=[total_1;data_num];
end
tic
total_1=sortrows(total_1,17);%按照真实的时间顺序倒序排列
total_1=flipud(total_1);%这次是真实的时间顺序，在最后一列标号上是反着的
toc

 %%划分单次出行
TRIP=[];
j=1;
ii=1;
k=2;
total_1(any(total_1(:,12),2)==0,:)=[];%删去时间or里程为0的点；%这里要思考一下是否有线性插值的必要性
total_1(any(total_1(:,16),2)==0,:)=[];

tmp_matrix = zeros(length(total_1(:,1)),24);
tmp_matrix(:,1) = total_1(:, 1);
tmp_matrix(:,2) = total_1(:, 2);
tmp_matrix(:,3) = total_1(:, 15);
tmp_matrix(:,4) = total_1(:, 5);
tmp_matrix(:,9) = total_1(:, 3);
tmp_matrix(:,10) = total_1(:, 7);
tmp_matrix(:,11) = total_1(:, 8);
tmp_matrix(:,12) = total_1(:, 9);
tmp_matrix(:,13) = total_1(:, 10);
tmp_matrix(:,14) = total_1(:, 11);
tmp_matrix(:,16) = total_1(:, 12);
tmp_matrix(:,18) = total_1(:, 13);
tmp_matrix(:,19) = total_1(:, 14);
tmp_matrix(:,20) = total_1(:, 15);
tmp_matrix(:,21) = total_1(:, 16);
tmp_matrix(:,22) = total_1(:, 17);
tmp_matrix(:,23) = total_1(:, 18);
tmp_matrix(:,24) = total_1(:, 19);

total_10=tmp_matrix;%total_10包括停车时刻
total_1(any(total_1(:,13),2)==0,:)=[];%total_1把停车的时刻刨除在外 速度为零代表停车
TRIP{1}(1,:)=total_1(1,:);
 for j=1:length(total_1(:,1))-1
     if (abs(total_1(j+1,16)-total_1(j,16)))<=30%貌似在求以月为单位的分钟的表示
        TRIP{ii}(k,:)=total_1(j+1,:);
         k=k+1;
     else
         ii=ii+1;
         k=1;
         TRIP{ii}(k,:)=total_1(j+1,:);
     end 
 end
 %%%清除不合理数据
t=1;
r=length(TRIP);
for t=1:r
    if isempty(TRIP{t})==0
        if abs(TRIP{t}(length(TRIP{t}(:,16)),16)-TRIP{t}(1,16))<5  %%少于5min的出行记为无效 原单位为天
            TRIP{t}=[];
        end
    end
    if isempty(TRIP{t})==0
        if abs(TRIP{t}(length(TRIP{t}(:,12)),12)-TRIP{t}(1,12))<1 %里程小于1km记为无效
            TRIP{1,t}=[];
        end
      end
end
TRIP(cellfun(@isempty,TRIP))=[];%删除其中的空数组%得到的是行车的每次出行的特征
TRIP2 = [];
for t=1:length(TRIP)
    tmp_matrix = zeros(length(TRIP{t}(:,1)),24);
    tmp_matrix(:,1) = TRIP{t}(:, 1);
    tmp_matrix(:,2) = TRIP{t}(:, 2);
    tmp_matrix(:,3) = TRIP{t}(:, 15);
    tmp_matrix(:,4) = TRIP{t}(:, 5);
    tmp_matrix(:,9) = TRIP{t}(:, 3);
    tmp_matrix(:,10) = TRIP{t}(:, 7);
    tmp_matrix(:,11) = TRIP{t}(:, 8);
    tmp_matrix(:,12) = TRIP{t}(:, 9);
    tmp_matrix(:,13) = TRIP{t}(:, 10);
    tmp_matrix(:,14) = TRIP{t}(:, 11);
    tmp_matrix(:,16) = TRIP{t}(:, 12);
    tmp_matrix(:,18) = TRIP{t}(:, 13);
    tmp_matrix(:,19) = TRIP{t}(:, 14);
    tmp_matrix(:,20) = TRIP{t}(:, 15);
    tmp_matrix(:,21) = TRIP{t}(:, 16);
    tmp_matrix(:,22) = TRIP{t}(:, 17);
    tmp_matrix(:,23) = TRIP{t}(:, 18);
    tmp_matrix(:,24) = TRIP{t}(:, 19);
    TRIP2{t} = tmp_matrix;
end
 toc 
 file2=strcat('E:\Users\SZY\Desktop\DATA\result.mat');
 save(file2,'TRIP2','total_10');
end