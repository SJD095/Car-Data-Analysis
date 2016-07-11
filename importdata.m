%importdata_��������
%2016-2-26 by echoc
clear;
clc;
close all;
%��ÿ������������׺��һ��
FILENAME='E:\Users\SZY\Desktop\DATA';
FILE1=dir(FILENAME);
for order=3:length(FILE1)
    filename='E:\Users\SZY\Desktop\DATA\dbc_4025';
    file1=dir(filename);


M=[];
total_1=zeros(1,19);% Ŀǰ����һ����24��0
tt=1;
s=[];
for NUM=3:3
    str=strcat(filename,'\',file1(NUM).name);
    file=fopen(str);
    title=textscan(file,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'delimiter', ',');  % ��ȡ��һ�б�ͷ�ı�
    data=textscan(file,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %s %f %f ','delimiter', ',');     % ��ȡ�ڶ��п�ʼ���ı�
    temp=zeros(length(data{1,17}),1);
    for i=1:length(data{1,17});
        temp(i,1)=datenum(datestr(data{1,17}(i,1),0));
    end
    data{1,17}=temp;
    data_num=cell2mat(data);
    total_1=[total_1;data_num];
end
tic
total_1=sortrows(total_1,17);%������ʵ��ʱ��˳��������
total_1=flipud(total_1);%�������ʵ��ʱ��˳�������һ�б�����Ƿ��ŵ�
toc

 %%���ֵ��γ���
TRIP=[];
j=1;
ii=1;
k=2;
total_1(any(total_1(:,12),2)==0,:)=[];%ɾȥʱ��or���Ϊ0�ĵ㣻%����Ҫ˼��һ���Ƿ������Բ�ֵ�ı�Ҫ��
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

total_10=tmp_matrix;%total_10����ͣ��ʱ��
total_1(any(total_1(:,13),2)==0,:)=[];%total_1��ͣ����ʱ���ٳ����� �ٶ�Ϊ�����ͣ��
TRIP{1}(1,:)=total_1(1,:);
 for j=1:length(total_1(:,1))-1
     if (abs(total_1(j+1,16)-total_1(j,16)))<=30%ò����������Ϊ��λ�ķ��ӵı�ʾ
        TRIP{ii}(k,:)=total_1(j+1,:);
         k=k+1;
     else
         ii=ii+1;
         k=1;
         TRIP{ii}(k,:)=total_1(j+1,:);
     end 
 end
 %%%�������������
t=1;
r=length(TRIP);
for t=1:r
    if isempty(TRIP{t})==0
        if abs(TRIP{t}(length(TRIP{t}(:,16)),16)-TRIP{t}(1,16))<5  %%����5min�ĳ��м�Ϊ��Ч ԭ��λΪ��
            TRIP{t}=[];
        end
    end
    if isempty(TRIP{t})==0
        if abs(TRIP{t}(length(TRIP{t}(:,12)),12)-TRIP{t}(1,12))<1 %���С��1km��Ϊ��Ч
            TRIP{1,t}=[];
        end
      end
end
TRIP(cellfun(@isempty,TRIP))=[];%ɾ�����еĿ�����%�õ������г���ÿ�γ��е�����
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