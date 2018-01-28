clear all;
clc;

% CIPIC�߶ȽǷֲ� ��50�� ��-45��235    �ֲ�ͼ��ReadMe.doc
% elevation_cipic=-45:360/64:235;  
% elevation(9)==0 ����ǰ���߶Ƚ�    elevation(25)==90�����Ϸ��߶Ƚ�   elevation(41)==180�����󷽸߶Ƚ�
% elevation_index=1:50;   %��Ӧ�߶Ƚ���CIPIC Hrtf���е�����

% CIPIC ��λ�Ƿֲ� ��50��  ǰ�󷽸�25��   �ֲ�ͼ��ReadMe.doc
% azimuth_cipic = [-80 -65 -55 -45:5:45 55 65 80];  
% azimuth(13)==0��ǰ����λ��
% azimuth_index=1:25;

azimuth_cipic = [-80 -65 -55 -45:5:45 55 65 80];%azimuth(13)==0 
azimuth=65;
azimuth_index=find(azimuth_cipic==azimuth);%��ȡ65�ȷ�λ�� ������ֵ

elevation_cipic=-45:360/64:235;
elevation=0;
elevation_index=find(elevation_cipic==elevation);%��ȡ0�ȸ߶Ƚ� ������ֵ

subject_index=1;%cipic subject������

%��ȡazimuth=65��elevation=0�� hrir����
hrtf_l= readCipicHrtf(subject_index,azimuth_index,elevation_index,'l');
hrtf_r= readCipicHrtf(subject_index,azimuth_index,elevation_index,'r');

wav_file_name='E:\Matlab\CipicHrtfApplication\InputWav\es01.wav';
[wav_data fs nbits]=wavread(wav_file_name);
%�������˫���ź�
binarual_l=filter(hrtf_l,1,wav_data);
binarual_r=filter(hrtf_r,1,wav_data);

len=length(binarual_l);



azimuth1=-65;
azimuth_index1=find(azimuth_cipic==azimuth1);%��ȡ65�ȷ�λ�� ������ֵ


elevation1=0;
elevation_index1=find(elevation_cipic==elevation1);%��ȡ0�ȸ߶Ƚ� ������ֵ



%��ȡazimuth=65��elevation=0�� hrir����
hrtf_l1= readCipicHrtf(subject_index,azimuth_index1,elevation_index1,'l');
hrtf_r1= readCipicHrtf(subject_index,azimuth_index1,elevation_index1,'r');

wav_file_name1='E:\Matlab\CipicHrtfApplication\InputWav\es02.wav';
[wav_data1 fs1 nbits1]=wavread(wav_file_name1);
%�������˫���ź�
binarual_l1=filter(hrtf_l1,1,wav_data1);
binarual_r1=filter(hrtf_r1,1,wav_data1);

len1=length(binarual_r1);

if(len>len1)
    binarual_l1(len1+1:len)=0;
    binarual_r1(len1+1:len)=0;
else
    binarual_l(len+1:len1)=0;
    binarual_r(len+1:len1)=0;  
end
   

%binarual_output=[ifft(fft(binarual_l)+fft(binarual_l1))  ifft(fft(binarual_r)+fft(binarual_r1))];
binarual_output=[binarual_l1+binarual_l   binarual_r1+binarual_r ];
output_wav_file='E:\Matlab\CipicHrtfApplication\OutputWav\es01_point_binarual.wav';
wavwrite(binarual_output,fs,nbits,output_wav_file);

