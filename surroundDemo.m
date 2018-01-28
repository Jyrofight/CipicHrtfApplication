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

%azimuth ǰ������  ��-80�ȵ�80��  ����ֵ1:25
azimuth_cipic = [-80 -65 -55 -45:5:45 55 65 80];
azimuth_index=1:25;

elevation_cipic=-45:360/64:235;
elevation=0;
elevation_index_at0=find(elevation_cipic==elevation);%��ȡ0�ȸ߶Ƚ� ������ֵ ��9
elevation_index=elevation_index_at0*ones(1,25);%��azimuth_index����һ�� 25�� 

subject_index=1;%cipic subject������
%��ȡwav�ļ�   ��֡
wav_file_name='E:\Matlab\CipicHrtfApplication\InputWav\es01.wav';
[wav_data fs nbits]=wavread(wav_file_name);

framenumber = 25;%25֡  ��Ӧ25����λ��
framesize=floor(length(wav_data) / framenumber);%ÿ֡�����ݵ�ĸ���

for i=1:length(azimuth_cipic)
    %��ȡazimuth_cipic(i)     elevation==0 subject_index==1 ��Ӧ��hrir
    hrtf_l= readCipicHrtf(subject_index,azimuth_index(i),elevation_index(i),'l');
    hrtf_r= readCipicHrtf(subject_index,azimuth_index(i),elevation_index(i),'r');
    wav_data_temp=wav_data((framesize*(i-1)+1):framesize*i);
    %�������˫���ź�
    binarual_l=filter(hrtf_l,1,wav_data_temp);
    binarual_r=filter(hrtf_r,1,wav_data_temp);
    %���Ӹ�֡���ɵ�˫���ź�
    if i==1
         binarual_output=[binarual_l,binarual_r];
    else
        binarual_output=vertcat(binarual_output,[binarual_l,binarual_r]);
    end
end

%���˫���ź�
output_wav_file='E:\Matlab\CipicHrtfApplication\OutputWav\es01_surround_binarual.wav';
wavwrite(binarual_output,fs,nbits,output_wav_file);

