clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PART 2:

T=100/1000; %the 100ms period
Tg=20/1000; %the 20ms gap time 

%Promt to enter the number 
%mynum=input('Input your number: ','s'); 

mynum='01062367332';

%Given the number of samples, to find the sampling frequency we need to
%divide the number of samples by our time frame, we first need to calculate
%the time frame=(number of characters)*100ms+(number of characters-1)*20ms
numb=length(mynum); 
tmax=numb*T+(numb-1)*Tg;
numbofsampl=2^14;
Fs=floor(numbofsampl/tmax);
Ts=1/Fs;
t=0:Ts:T;
tfull=0:Ts:tmax;       %Full timescale 

tg=0:Ts:20/1000;       %Gap time scale
xg=0*tg;               %definition of the guard band and 
xg=xg(:,2:end-1);      %removal of its end so we can concatenate 
                       %to our original signal

x_t=0;           %Recursive concatenation of the time-domain signal
for i=1:numb   %with the DTMF signals
    x_t=[x_t sym2TT(mynum(i),Fs) xg];
end
x_t=x_t(1,2:length(x_t)-length(xg)); %removal of the unwanted first row 
                               %and the last gap

%Since the Fs is a random number we get the time domain signal
%not same as the timescale we defined earlier due to the approximations
%done in the program, so we zero pad the rest of the time domain signal
%until matching
missing=abs(length(tfull)-length(x_t));
missing=zeros(1,missing);
x_t=[x_t missing];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PART 3:

noise = sqrt(0.1)*randn(size(x_t));
y_t=x_t+noise;     %Gaussian noise addition

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PART 4:

%filename = 'mynumber.wav';   %Storing of the file as .wav
%audiowrite(filename,y./max(y),floor(Fs));
%sound(y./max(y),Fs);  %To hear sound now

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PART 5:

figure(1)
subplot(2,2,[1,2])
plot(tfull,y_t) %Plot of time domain signal
title('Time domain of the number signal after noise');
xlabel('Time (sec)');
ylabel('Amplitude ');  

subplot(2,2,[3,4])
plot(tfull,x_t) %Plot of time domain signal
title('Time domain of the number signal before noise');
xlabel('Time (sec)');
ylabel('Amplitude ');  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PART 6:

fy=Fs*(-numbofsampl/2:numbofsampl/2-1)/numbofsampl;  %Defining of the frequency scale 
fspec=fft(y_t,numbofsampl);                          %Fourier transform
fspec=fftshift(abs(fspec));
fspecdB=20*log10(fspec./max(fspec));
%the max magnitude is the refrence to as the 0dB

figure(2)
subplot(2,2,[1 2])
stem(fy,abs(fspec));  %Plot of the frequency domain from 600 1700 Hz magnitude
xlim([600 1700]);
title('Frequency domain of the number signal');
xlabel('Frequency (Hz) [600 1700]');
ylabel('Magnitude ');

subplot(2,2,[3 4])
stem(fy,abs(fspecdB)); %Plot of the frequency domain from 600 1700 Hz in dB
xlim([600 1700]);
title('Frequency domain of the number signal in dB');
xlabel('Frequency (Hz) [600 1700]');
ylabel('Power (dB)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PART 7:

windowsize=input('Enter window size: '); %Prompt to choose window size
overlap=windowsize/2;                    %Overlap = 50%
window=0:Ts:tfull(windowsize); %Defining of window in the time domain   
mainz=zeros(numbofsampl,1);    %Spectrogram matrix ,refer how its 
mainz_B=zeros(numbofsampl,1);  %implemeted in the report
%mainz=zeros(length(window),1);    %Spectrogram matrix ,refer how its 
%mainz_B=zeros(length(window),1);  %implemeted in the report
f=Fs*(-numbofsampl/2:numbofsampl/2-1)/numbofsampl; %defining frequency domain
%f=Fs*(-length(window)/2:length(window)/2-1)/length(window);
i=1;                   %Parameter to scan our window across the signal
windowmax=length(y_t); %Parameter to stop the window scan
blackmann=(blackman(length(window)))'; %Blackman window

for j=1:0.01:1000 
    
    if i+windowsize>windowmax 
        break %The j loop keeps looping until we reach the end of the
    end       %time domain signal
    
    xnow_B=y_t(1,i:i+windowsize-1).*blackmann;
    xnow=y_t(1,i:i+windowsize-1);
    
    z=fft(xnow,numbofsampl);   %Fourier transform with rectangular window
    %z=fft(xnow);
    z=fftshift(abs(z));
    z=z';
    mainz=[mainz z]; %Recursive concatenation to fill the spectrogram matrix
    
    z_B=fft(xnow_B,numbofsampl);   %Fourier transform with blackman window
    %z_B=fft(xnow_B);
    z_B=fftshift(abs(z_B));
    z_B=(z_B)';
    mainz_B=[mainz_B z_B]; %Recursive concatenation to fill the spectrogram matrix
    
    i=i+overlap;     %moving the window with the overlap
end

mainz(:,1)=[]; %Removing of the 1st row of the matrix as its only for initializing
mainz_B(:,1)=[]; %Removing of the 1st row of the matrix as its only for initializing


%changing of the spectrogram scale to power/frequency (dB/Hz) from (Watt/Hz)
%the max magnitude is the refrence to as the 0dB
mainz=20*log10(mainz./max(mainz)); 
mainz_B=20*log10(mainz_B./max(mainz_B)); 


figure(3)
subplot(2,2,1)
tnew=linspace(0,tmax,size(mainz,2));   %Adjusting the spectrogram timescale to fit the chosen window
surf(tnew,f,mainz,'EdgeColor','none'); %surf function plots a 3D plot   
axis xy; axis tight; colormap(parula); view(0,90);c=colorbar; %adjusting of surf and looking from a plane POV
c.Label.String = 'Power/frequency (dB/Hz)';
xlabel('Time(Sec)');
ylabel('Frequency(Hz)');
title('My Spectrogram Rectangular window');
ylim([0 Fs/3]);

subplot(2,2,2)
tnew_B=linspace(0,tmax,size(mainz_B,2));   %Adjusting the spectrogram timescale to fit the chosen window
surf(tnew_B,f,mainz_B,'EdgeColor','none'); %surf function plots a 3D plot   
axis xy; axis tight; colormap(parula); view(0,90);c=colorbar; %adjusting of surf and looking from a plane POV
c.Label.String = 'Power/frequency (dB/Hz)';
xlabel('Time(Sec)');
ylabel('Frequency(Hz)');
title('My Spectrogram Blackman window');
ylim([0 Fs/3]);

subplot(2,2,3) %plot of original spectrogram using rectangular window
spectrogram(y_t,(windowsize),overlap,windowsize,Fs,'yaxis');
title('Spectrogram function Rectangular window');

subplot(2,2,4) %plot of original spectrogram using blackman window
spectrogram(y_t,blackman(windowsize),overlap,windowsize,Fs,'yaxis');
title('Spectrogram function Blackman window');

fall = [697 770 852 941 1209 1336 1477 1633];  %needed frequencies for goertzl
dmynum=0; %The detected number (updated later)
i=1;      %Parameter for moving the window for detection

for j=1:0.01:1000
    
    if i>length(y_t)
        break %The j loop keeps looping until we reach the end of the
    end       %time domain signal
    
    %The window now is the 100ms signal 
    %we increment the i by the gap and the next 100ms
    xnow=y_t(1,i:i+length(t)-1);
    i=i+length(t)+length(xg);
    
    %normalizing frequencies for goertzl
    freq_indices = round(fall/Fs*length(xnow)) + 1; 
    dft_data = abs(goertzel(xnow,freq_indices));
    
    %We have 8 frequencied indexed from 1 to 8
    %to detect the number we check where the 2 max frequencies are 
    %and depending on its index we recognized the number using conditional
    %statements 
    [max1,index1]=max(dft_data); %1st maximum
    dft_data(:,index1)=0;        %removing 1st maximum to see 2nd maximum
    [max2,index2]=max(dft_data); %2nd maximum 
    index=[index1 index2];       %depending of the index we see our number
    
    %recursive concatenation of the number  
    if min(index)==1 && max(index)==5
           dmynum=[dmynum '1'];
           
    elseif min(index)==1 && max(index)==6
           dmynum=[dmynum '2'];
           
    elseif min(index)==1 && max(index)==7
           dmynum=[dmynum '3'];
           
    elseif min(index)==1 && max(index)==8
           dmynum=[dmynum 'A'];
           
    elseif min(index)==2 && max(index)==5
           dmynum=[dmynum '4'];
           
    elseif min(index)==2 && max(index)==6
           dmynum=[dmynum '5'];
           
    elseif min(index)==2 && max(index)==7
           dmynum=[dmynum '6'];
           
    elseif min(index)==2 && max(index)==8
           dmynum=[dmynum 'B'];
           
    elseif min(index)==3 && max(index)==5
           dmynum=[dmynum '7'];
           
    elseif min(index)==3 && max(index)==6
           dmynum=[dmynum '8'];
           
    elseif min(index)==3 && max(index)==7
           dmynum=[dmynum '9'];
           
    elseif min(index)==3 && max(index)==8
           dmynum=[dmynum 'C'];
           
    elseif min(index)==4 && max(index)==5
           dmynum=[dmynum '*'];
           
    elseif min(index)==4 && max(index)==6
           dmynum=[dmynum '0'];
           
    elseif min(index)==4 && max(index)==7
           dmynum=[dmynum '#'];
           
    elseif min(index)==4 && max(index)==8
           dmynum=[dmynum 'D'];       
    end
    
end

dmynum(:,1)=[];

disp('The detected number is: ');
dmynum
