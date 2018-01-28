clear all;
clc;
subject=9;
framesize=1024;
azimuth_cipic = [-80 -65 -55 -45:5:45 55 65 80];%��cipic���е�index 1:25
elevation_cipic=-45:360/64:235; %��cipic���е�����1:50
%azimuth elevation ���߳���һ����
azimuth=[0 -45 -80 -65 -30 0 30 65 80 45 ];%22.2 ϵͳ�м��������λ�÷ֲ�   azimuth�е�ÿ��Ԫ�ر���������azimuth_cipic
elevation=[180 180 180 0 0 0 0 0 180 180];%ǰ�� �߶Ƚ�Ϊ0  �󷽸߶Ƚ�Ϊ180    elevation�е�ÿ��Ԫ�ر���������elevation_cipic
azimuth_length=length(azimuth);
azimuth_index=zeros(1,length(azimuth));
elevation_index=zeros(1,length(elevation));

for i=1:length(azimuth)
    azimuth_index(i)=find(azimuth_cipic==azimuth(i));
   elevation_index(i)=find(elevation_cipic==elevation(i));
end

input_file_path='E:\Matlab\CipicHrtfApplication\InputWav\';
output_file_path='E:\Matlab\CipicHrtfApplication\OutputWav\';
%input_wav_files_L �ļ�������
for i=1:10
    if (i>=10)
        input_wav_files_L{i}=strcat(input_file_path,'es01_L_', int2str(i), '.wav');
        break;
    end
    input_wav_files_L{i}=strcat(input_file_path,'es01_L_0', int2str(i),'.wav');
end

for i=1:10
    if (i>=10)
        input_wav_files_R{i}=strcat(input_file_path,'es01_R_', int2str(i), '.wav');
        break;
    end
       input_wav_files_R{i}=strcat(input_file_path,'es01_R_0', int2str(i),'.wav');
end

for i=1:azimuth_length
    %��ȡ������������Ӧ��wav�ļ�
    [wav_data_l fs nbits]=wavread(input_wav_files_L{i});
    [wav_data_r fs nbits]=wavread(input_wav_files_R{i});          

    wav_data_length=length(wav_data_l);
    framenumber = floor(length(wav_data_l) / framesize);
    
    %��ȡ�������������ڽǶȶ�Ӧ�����Ҷ�hrir����    
    hrir_data_ll=readCipicHrtf(subject,azimuth_index(i), elevation_index(i),'l');%�������� ��� Hrir ����
    hrir_data_lr=readCipicHrtf(subject,azimuth_index(i), elevation_index(i),'r');%�������� �Ҷ� Hrir ����   
    
    if i==azimuth_length
            hrir_data_rl=readCipicHrtf(subject,azimuth_index(1), elevation_index(1),'l');%�������� ��� Hrir ����    
            hrir_data_rr=readCipicHrtf(subject,azimuth_index(1), elevation_index(1),'r'); %�������� �Ҷ� Hrir ����   
    else
            hrir_data_rl=readCipicHrtf(subject,azimuth_index(i+1), elevation_index(i+1),'l');%�������� ��� Hrir ����    
            hrir_data_rr=readCipicHrtf(subject,azimuth_index(i+1), elevation_index(i+1),'r'); %�������� �Ҷ� Hrir ����   
    end

    %�������˫���ź�
    binaural_data_ll=filter(hrir_data_ll, 1,wav_data_l);%������������������ź�
    binaural_data_lr=filter(hrir_data_lr, 1,wav_data_l);% ���������������Ҷ��ź�   
    binaural_data_rl=filter(hrir_data_rl, 1,wav_data_r); %������������������ź�  
    binaural_data_rr=filter(hrir_data_rr, 1,wav_data_r); %���������������Ҷ��ź�    
    
    %%ÿ��ѭ�� ���������������������� 
    binaural_data_l=zeros(length(wav_data_l),1);
    binaural_data_r=zeros(length(wav_data_l),1);
    %Ƶ�����  ���任�õ�ʱ�� 
    for j = 1:framenumber
            binaural_data_l(((j-1)*framesize+1):j*framesize) = ifft(fft( binaural_data_ll( ((j-1)*framesize+1):j*framesize) ) +...
                fft( binaural_data_rl( ((j-1)*framesize+1):j*framesize) )); % ������������źŵ���    
            
            binaural_data_r(((j-1)*framesize+1):j*framesize) = ifft(fft( binaural_data_lr( ((j-1)*framesize+1):j*framesize) ) +...
                fft( binaural_data_rr( ((j-1)*framesize+1):j*framesize) )); % ���������Ҷ��ź� ����   
    end

    %���� �����һ֡�� β������
                binaural_data_l(framenumber*framesize+1:wav_data_length) = ifft(   fft( binaural_data_ll( framenumber*framesize+1:wav_data_length)) +...
                fft( binaural_data_rl( framenumber*framesize+1:wav_data_length))   ); % ������������ź� ����     
            
                binaural_data_r(framenumber*framesize+1:wav_data_length) = ifft(    fft( binaural_data_lr( framenumber*framesize+1:wav_data_length )) +...
                fft( binaural_data_rr( framenumber*framesize+1:wav_data_length))   ); % ���������Ҷ��ź�  ����  

   %����˫���ź�
   if i==1
       output_wav_data( (wav_data_length*(i-1)+1):wav_data_length*i,   1)=binaural_data_l;
       output_wav_data( (wav_data_length*(i-1)+1):wav_data_length*i,   2)=binaural_data_r;   
   else
       output_wav_data=vertcat(output_wav_data, [binaural_data_l,binaural_data_r]);
   end  
   
end   

% ����ļ�
output_file_name=[output_file_path 'es01_binaural.wav'];
wavwrite(output_wav_data,fs,nbits,output_file_name);









