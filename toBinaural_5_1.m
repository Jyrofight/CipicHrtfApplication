clear all;
clc;
subject=1;
framesize=1024;
azimuth_cipic = [-80 -65 -55 -45:5:45 55 65 80];%��cipic���е�index 1:25
elevation_cipic=-45:360/64:235; %��cipic���е�����1:50
%azimuth elevation ���߳���һ��
azimuth_front=[-30 30 0 0];%5.1ϵͳǰ��4����������cipic���µķ�λ��
elevation_front=[0 0 0 0];%5.1ϵͳǰ��4����������cipic���µĸ߶Ƚ�

azimuth_front_index=zeros(1,4);
elevation_front_index=zeros(1,4);
%ǰ��4���������� azimuth elevation ��index ��4����������Ӧ��HRIR���ݴ�CIPIC���ж�����
%��������������HRIR����Ҫ�Ӳ�ֵ��excel���ж��� 
for i=1:length(azimuth_front)
    azimuth_front_index(i)=find(azimuth_cipic==azimuth_front(i));
   elevation_front_index(i)=find(elevation_cipic==elevation_front(i));
end
%6������������λ�ö�Ӧ�����Ҷ� hrir����
hrir_data_l=zeros(200,6);
hrir_data_r=zeros(200,6);
%ǰ��4���������� hrir���� ֱ�Ӵ�cipic����ȡ��
for i=1:4
    hrir_data_l(:,i)=readCipicHrtf(subject,azimuth_front_index(i), elevation_front_index(i), 'l');
    hrir_data_r(:,i)=readCipicHrtf(subject,azimuth_front_index(i), elevation_front_index(i), 'r');
end

%��������������hrir���ݴ�excel��Ĳ�ֵ���� ��ȡ��
xls_file_name='.\ˮƽ��λ(0~360��1�ȼ��)Hrtf_L��ֵ���.xls';
sheet_name='subject1singleHrtf_L_C';
rangle_left_back='L205:L404';        %��λ ��� -70�� hrir���� ��excel���е�λ��   ���
rangle_right_back='EV205:EV404';        %��λ �Һ� 70�� hrir���� ��excel���е�λ��  ���
hrir_data_l(:,5)=xlsread(xls_file_name,sheet_name,rangle_left_back);
hrir_data_l(:,6)=xlsread(xls_file_name,sheet_name,rangle_right_back);

xls_file_name='.\ˮƽ��λ(0~360��1�ȼ��)Hrtf_R��ֵ���.xls';
sheet_name='subject1singleHrtf_R_C';
rangle_left_back='L205:L404';           %��λ ��� -70�� hrir���� ��excel���е�λ��   �Ҷ�
rangle_right_back='EV205:EV404';            %��λ �Һ� 70�� hrir���� ��excel���е�λ��   �Ҷ�
hrir_data_r(:,5)=xlsread(xls_file_name,sheet_name,rangle_left_back);
hrir_data_r(:,6)=xlsread(xls_file_name,sheet_name,rangle_right_back);

%��������ļ�·��
input_file_path='.\InputWav\';
output_file_path='.\OutputWav\';
%input_wav_files_L �ļ�������  6���ļ� ���δ��
for i=1:6
     input_wav_files_L{i}=strcat(input_file_path,'pcm_mps_44khz_HQ_', int2str(i), '.wav');
end

wav_data_length=0;
framenumber=0;
for i=1:6
    %��ȡ������������Ӧ��wav�ļ�
    [wav_data fs nbits]=wavread(input_wav_files_L{i});   
    %ֻ�ڵ�һ��ȡwav�ļ���ʱ�����wav_data�ĳ��Ⱥ�֡��
    if i==1
        wav_data_length=length(wav_data);
        framenumber = floor(length(wav_data) / framesize);
    end  
    %�������˫���ź�
    binaural_data_l(:,i)=filter(hrir_data_l(:,i), 1,wav_data);%6������������������ź�
    binaural_data_r(:,i)=filter(hrir_data_r(:,i), 1,wav_data);% 6���������������Ҷ��ź�       
end   
 

    % 6�� ������������˫���ź� ��Ƶ�����  ���任�õ�ʱ�� 
    for j = 1:framenumber
            out_data_l(((j-1)*framesize+1):j*framesize) = ifft( +...
                fft( binaural_data_l( ((j-1)*framesize+1):j*framesize,1) ) +...
                fft( binaural_data_l( ((j-1)*framesize+1):j*framesize,2)) +...         
                fft( binaural_data_l( ((j-1)*framesize+1):j*framesize,3)) +...
                fft( binaural_data_l( ((j-1)*framesize+1):j*framesize,4)) +...
                fft( binaural_data_l( ((j-1)*framesize+1):j*framesize,5)) +...
                fft( binaural_data_l( ((j-1)*framesize+1):j*framesize,6)) ); % 6����������źŵ���    
            
               out_data_r(((j-1)*framesize+1):j*framesize) = ifft( +...
                fft( binaural_data_r( ((j-1)*framesize+1):j*framesize,1)) +...
                fft( binaural_data_r( ((j-1)*framesize+1):j*framesize,2)) +...         
                fft( binaural_data_r( ((j-1)*framesize+1):j*framesize,3)) +...
                fft( binaural_data_r( ((j-1)*framesize+1):j*framesize,4)) +...
                fft( binaural_data_r( ((j-1)*framesize+1):j*framesize,5)) +...
                fft( binaural_data_r( ((j-1)*framesize+1):j*framesize,6)) ); % 6�������Ҷ��źŵ���    
            
    end

out_data=[out_data_l' out_data_r'];
% ����ļ�
output_file_name=[output_file_path 'pcm_mps_44khz_HQ_binaural.wav'];
wavwrite(out_data,fs,nbits,output_file_name);









