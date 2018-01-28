%% matlab ����CIPIC��ķ�λ�� �ֲ�ͼ
clc;
clear all;

r=10;%�뾶
seta=0:0.001:2*pi;
xx=r*cos(seta);
yy=r*sin(seta);
plot(xx,yy);%��Բ
axis([-12 12 -12 12]) ;
hold on;

azimuth_cipic = [-80 -65 -55 -45:5:45 55 65 80];
azimuth=zeros(1,length(azimuth_cipic));
%����ϵת��
for i=1:length(azimuth_cipic)
    if azimuth_cipic(i)>=0
        azimuth(i)=90-azimuth_cipic(i);%�Ƕ�
    else
        azimuth(i)=90+abs(azimuth_cipic(i));        
    end
end

azimuth_xx=zeros(1,length(azimuth_cipic));
azimuth_yy=zeros(1,length(azimuth_cipic));
for  i=1:length(azimuth)
    azimuth_xx(i)=r*cos(azimuth(i)*pi/180);
    azimuth_yy(i)=r*sin(azimuth(i)*pi/180);
end

plot([-12 12],[0 0],'g-');
hold on;
plot([0 0],[-12 12],'g-');
hold on;

%ǰ����λ�Ƿֲ�
for i=1:length(azimuth)
  plot([0,azimuth_xx(i)],[0,azimuth_yy(i)],'r-');
  hold on;
end

%�󷽷�λ�Ƿֲ�
for i=1:length(azimuth)
  plot([0,azimuth_xx(i)],[0,-azimuth_yy(i)],'r-');
  hold on;
end