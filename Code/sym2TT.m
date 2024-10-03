%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PART 1:

function [x] = sym2TT(S,Fs)

%The function takes arguments of the DTMF symbol and 
%the sampling frequency for ease of use so we can calculate our sampling
%frequency depending of the number provided given a specific number of
%samples

T=100/1000; %100ms
Ts=1/Fs;    %Sampling time 
t=0:Ts:T;   %The time period we want our signal in

%Below is a switch case for each DTMF number 
%provided the default DTMF frequencies from the grid

switch S
    case '1'
        x=sin(2*pi*697*t)+sin(2*pi*1209*t);
        
    case '2'
        x=sin(2*pi*697*t)+sin(2*pi*1336*t);
        
    case '3'
        x=sin(2*pi*697*t)+sin(2*pi*1477*t);
        
    case 'A'
        x=sin(2*pi*697*t)+sin(2*pi*1633*t);
        
    case '4'
        x=sin(2*pi*770*t)+sin(2*pi*1209*t);
        
    case '5'
        x=sin(2*pi*770*t)+sin(2*pi*1336*t);
        
    case '6'
        x=sin(2*pi*770*t)+sin(2*pi*1477*t);
        
    case 'B'
        x=sin(2*pi*770*t)+sin(2*pi*1633*t);
        
    case '7'
        x=sin(2*pi*852*t)+sin(2*pi*1209*t);
        
    case '8'
        x=sin(2*pi*852*t)+sin(2*pi*1336*t);
        
    case '9'
        x=sin(2*pi*852*t)+sin(2*pi*1477*t);
        
    case 'C'
        x=sin(2*pi*852*t)+sin(2*pi*1633*t);
        
    case '*'
        x=sin(2*pi*941*t)+sin(2*pi*1209*t);
        
    case '0'
        x=sin(2*pi*941*t)+sin(2*pi*1336*t);
        
    case '#'
        x=sin(2*pi*941*t)+sin(2*pi*1477*t);
        
    case 'D'
        x=sin(2*pi*941*t)+sin(2*pi*1633*t);
        
end
end

