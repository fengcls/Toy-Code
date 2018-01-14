%%
clear;close all;clc;
Input=rgb2gray(imread('retina.jpg')); % convert to gray scale image
figure;imshow(Input);

% Bottom hat, the highlighted structure is line structure
SE=strel('line',100,30);
Binary_Input=imbothat(Input,SE);
Binary_AD=imadjust(Binary_Input);
[x,y]=size(Binary_AD);

% region outside eye and in the middle of the eye
% where there is no vessel, is defined as 0
for i=1:x
    for j=1:y
        if (x/2-i)^2+(y/2-j)^2>(x/2-30)^2
            Binary_AD(i,j)=0;
        end
        if (x/2-i)^2+(y/2-j)^2<100^2
            Binary_AD(i,j)=0;
        end
    end
end

% convert to binary image
Threshold=30;
Binary_ADD=zeros(size(Binary_AD));
Binary_ADD(Binary_AD>Threshold)=1;
Binary_ADD=bwareaopen(Binary_ADD,30);

figure;imshow(Binary_ADD);

% pre-process of the binary image
SE1=ones(3,3);
SE2=ones(5,5);

BW0=imdilate(Binary_ADD,SE2);
BW1=imclose(BW0,SE2);
BW2=bwareaopen(BW1,50);
BW3=imclose(BW2,SE2);
BW4=bwareaopen(BW3,100);

% extract the skeleton and then prune it
BW5=bwmorph(BW4,'skel',Inf);
figure;imshow(BW5);title('skeleton')

BW6 = BW5;
for k = 1:50
    BW6=BW6 &~(endpoints(BW6));
end;
figure;imshow(BW6);title('Pruning')

%%
BW5 = BW6;
resizescale = 0.5;

resizethresh = 0.125;
BW5 = imresize(double(BW5),resizescale,'bicubic')>resizethresh;
% BW5_avg = imfilter(double(BW5),fspecial('average'));
% BW5 = BW5_avg>0.12;
figure;imshow(BW5);title('resize')

% Y
SE_Y=[1 0 0 0 0;0 1 0 0 0;0 0 1 1 1;0 0 1 0 0; 0 0 1 0 0];

for k = 1:8
    SE_Y_1(:,:,k)=imrotate(SE_Y,45*k,'crop');
end;
SE_Y_2=zeros(size(SE_Y_1));
SE_Y_2(3,5,1)=-1;
SE_Y_2(1,5,2)=-1;
SE_Y_2(1,3,3)=-1;
SE_Y_2(1,1,4)=-1;
SE_Y_2(3,1,5)=-1;
SE_Y_2(5,1,6)=-1;
SE_Y_2(5,3,7)=-1;
SE_Y_2(5,5,8)=-1;

SE_Y_1([1,5],5,1)=1;
SE_Y_1(1,[1,5],3)=1;
SE_Y_1([1,5],1,5)=1;
SE_Y_1(5,[1,5],7)=1;


% T
SE_T=[0 1 0,1 1 1,0 0 0];

SE_T=[0 0 0 0 0;0 0 0 0 0;1 1 1 1 1;0 0 1 0 0; 0 0 1 0 0];

for k = 1:8
    SE_T_1(:,:,k)=imrotate(SE_T,45*k,'crop');
end;

SE_T_1([1,5],5,1)=1;SE_T_1(5,1,1)=1;
SE_T_1(1,[1,5],3)=1;SE_T_1(5,5,3)=1;
SE_T_1([1,5],1,5)=1;SE_T_1(1,5,5)=1;
SE_T_1(5,[1,5],7)=1;SE_T_1(1,1,7)=1;

% X
% SE03=[0 0 1 0 0;0 0 1 0 0;1 1 1 1 1;0 0 1 0 0; 0 0 1 0 0];
SE_X=[0 1 0;1 1 1;0 1 0];

for k = 1:2
    SE_X_1(:,:,k)=imrotate(SE_X,45*k,'crop');
end;
SE_X_2(:,:,2)=[-1 0 -1;0 0 0;-1 0 -1];
SE_X_2(:,:,1)=[0 -1 0;-1 0 -1;0 -1 0];

% SE_X_1([1,5],[1,5],1)=1;
SE_X_1([1,3],[1,3],1)=1;

%% X
CrossType3 = bwhitmiss(BW5,SE_X_1(:,:,1))|bwhitmiss(BW5,SE_X_1(:,:,2));
% CrossType3 = bwhitmiss(BW5,SE_X_1(:,:,1)+SE_X_2(:,:,1))|bwhitmiss(BW5,SE_X_1(:,:,2)+SE_X_2(:,:,2));
CrossTypeS = bwhitmiss(BW5,ones(3));


SE_C = ones(3);SE_C(1)=0;SE_C(end)=0;
CrossTypeC = zeros(size(BW5));
for k = 1:8
    imrotate(SE_C,45*k,'crop')
    CrossTypeC = CrossTypeC | bwhitmiss(BW5,imrotate(SE_C,45*k,'crop'));
end;


% CrossType1=bwhitmiss(BW5,SE_Y);
%% Y
CrossType1 = zeros(size(BW5));
for k = 1:8
%     temp=bwhitmiss(BW5,SE_Y_1(:,:,k),1-SE_Y_1(:,:,k));
    temp=bwhitmiss(BW5,SE_Y_1(:,:,k)+SE_Y_2(:,:,k));
%      temp=bwhitmiss(BW5,SE_Y_1(:,:,k));
    CrossType1 = CrossType1|temp;
end;
CrossType1 = CrossType1-CrossType3;

% CrossType2=bwhitmiss(BW5,SE_T);
%% T
CrossType2 = zeros(size(BW5));
for k = 1:8
    temp=bwhitmiss(BW5,SE_T_1(:,:,k));%,1-SE_T_1(:,:,k));
    CrossType2 = CrossType2|temp;
end;
CrossType2=CrossType2-CrossType3;

%% +
CrossType3 = CrossType3-CrossTypeS-CrossTypeC;

% figure;imshow(CrossType1);
% figure;imshow(CrossType2);


%% plot
pmax=sum(sum(CrossType1));
qmax=sum(sum(CrossType2));
rmax=sum(sum(CrossType3));
CrossScatter1=zeros(pmax,2);
CrossScatter2=zeros(qmax,2);
CrossScatter3=zeros(rmax,2);
p=1;
q=1;
r=1;
for i=1:size(BW5,1)
    for j=1:size(BW5,2)
        if CrossType1(i,j)==1
            CrossScatter1(p,1)=i;
            CrossScatter1(p,2)=j;
            p=p+1;
        end
        if CrossType2(i,j)==1
            CrossScatter2(q,1)=i;
            CrossScatter2(q,2)=j;
            q=q+1;
        end
        if CrossType3(i,j)==1
            CrossScatter3(q,1)=i;
            CrossScatter3(q,2)=j;
            q=q+1;
        end
    end
end

absdiffScatter1 = abs(diff(CrossScatter1));
absdiffScatter2 = abs(diff(CrossScatter2));
absdiffScatter3 = abs(diff(CrossScatter3));

% same point threshold
spth = 10;

CrossScatter1((absdiffScatter1(:,1)<spth & absdiffScatter1(:,2)<spth),:)=[];
CrossScatter2((absdiffScatter2(:,1)<spth & absdiffScatter2(:,2)<spth),:)=[];
CrossScatter3((absdiffScatter3(:,1)<spth & absdiffScatter3(:,2)<spth),:)=[];

Input_r = imresize(Input,resizescale);
figure;imshow(Input_r);title('Y')
hold on;
scatter(CrossScatter1(:,2),CrossScatter1(:,1));

figure;imshow(Input_r);title('T')
hold on;
scatter(CrossScatter2(:,2),CrossScatter2(:,1));

figure;imshow(Input_r);title('X')
hold on;
scatter(CrossScatter3(:,2),CrossScatter3(:,1));

figure;subplot(131);imshow(Input_r);title('Y')
hold on;
scatter(CrossScatter1(:,2),CrossScatter1(:,1));

subplot(132);imshow(Input_r);title('T')
hold on;
scatter(CrossScatter2(:,2),CrossScatter2(:,1));

subplot(133);imshow(Input_r);title('X')
hold on;
scatter(CrossScatter3(:,2),CrossScatter3(:,1));

