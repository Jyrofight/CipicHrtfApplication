%% ����������30 100����65������������Դ
clc;
clear all;
virtual_sound_azimuth=65;%������Դ�Ƕ�
%�����������Ƕ�   �������Ƕ�����ϵ����ͷ��ǰ��Ϊ0�ȣ�˳ʱ����ת��360��
loudspeaker_l=30;
loudspeaker_r=100;

azimuth_cipic = [-80 -65 -55 -45:5:45 55 65 80];%azimuth(13)==0 
%�����������Ƕ� ��cipic������ϵ�µ�  ��λ�ǽǶ� 30����ǰ�� 80���ں�  
%���azimuth������ֵ
azimuth=[30 80];
azimuth_index=zeros(1,length(azimuth));
for i=1:length(azimuth)
    azimuth_index(i)=find(azimuth_cipic==azimuth(i));
end

%�����������Ƕ� ��cipic������ϵ�µ�  ��λ�ǽǶ�   0������ǰ�� 180��������  
%���elevation������ֵ
elevation_cipic=-45:360/64:235;
elevation=[0 180];
elevation_index=zeros(1,length(elevation));
for i=1:length(elevation)
    elevation_index(i)=find(elevation_cipic==elevation(i));
end  

subject_index=1;

%��ȡ�������Ƶ�ļ�
wav_file_name='E:\Matlab\CipicHrtfApplication\InputWav\es01.wav';
[wav_data fs nbits]=wavread(wav_file_name);
framesize=1024;
framenumber = floor(length(wav_data) / framesize);

%gl grΪ�����������źŵ�����
gl = zeros(size(virtual_sound_azimuth,1),1);
gr = gl;

%�����ж��� ��gl gr
theta = (loudspeaker_r - loudspeaker_l) / 2;  %ƫ�ƽǶ�
azi =virtual_sound_azimuth- 0.5 * (loudspeaker_r+ loudspeaker_l);
temp1=tan(theta*pi/180);  %tan(theta)
temp2=tan(azi*pi/180); %tan(phi)
gl = (temp1 - temp2) / sqrt(2*temp1.^2 + 2*temp2.^2);
gr= (temp1 + temp2) / sqrt(2*temp1.^2 + 2*temp2.^2);          

%%����HRTF����
hrtf_loudspeaker_ll= readCipicHrtf(subject_index,azimuth_index(1),elevation_index(1),'l');%�����������hrir����
hrtf_loudspeaker_lr=  readCipicHrtf(subject_index,azimuth_index(1),elevation_index(1),'r');%���������Ҷ�hrir����
hrtf_loudspeaker_rl= readCipicHrtf(subject_index,azimuth_index(2),elevation_index(2),'l');%�����������hrir����
hrtf_loudspeaker_rr=  readCipicHrtf(subject_index,azimuth_index(2),elevation_index(2),'r');  %���������Ҷ�hrir����  
%%�����������ź� ���Զ�Ӧ������
dataL = wav_data * gl;
dataR = wav_data * gr;

%%�������������γɵ�˫���ź�
outLL = zeros(length(wav_data),1); %% LL��������������������ź�
outLR = zeros(length(wav_data),1); %% LR���������������Ҷ����ź�
outRL = zeros(length(wav_data),1);
outRR = zeros(length(wav_data),1);
%�������˫���ź�
outLL= filter(hrtf_loudspeaker_ll,1,dataL);
outLR= filter(hrtf_loudspeaker_lr,1,dataL);
outRL= filter(hrtf_loudspeaker_rl,1,dataR);
outRR= filter(hrtf_loudspeaker_rr,1,dataR);
%�任��Ƶ����� Ȼ�󷴱任��ʱ��
for j = 1:framenumber
            outL(((j-1)*framesize+1):j*framesize) = ifft(fft( outLL( ((j-1)*framesize+1):j*framesize) ) +...
                fft( outRL( ((j-1)*framesize+1):j*framesize) )); % ������������ź�    %fft�任Ҫ1024��
            outR(((j-1)*framesize+1):j*framesize) = ifft(fft( outLR( ((j-1)*framesize+1):j*framesize) ) +...
                fft( outRR( ((j-1)*framesize+1):j*framesize) )); % ���������Ҷ��ź�    
end
out_data=[outL' outR'];

output_wav_file='E:\Matlab\CipicHrtfApplication\OutputWav\es01_phantom_binarual.wav';
wavwrite(out_data ,fs,nbits,output_wav_file);

