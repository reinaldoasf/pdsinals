load pds_fir.mp3
[y,Fs] = audioread('pds_fir.mp3');

s=length(y);

%frequencias normalizadas (w)
fs1=1700/(Fs/2);
fp1=1850/(Fs/2);
fp2=2150/(Fs/2);
fs2=2300/(Fs/2);

f0=Fs/s;
f1=f0:f0:Fs/2;
f2=-Fs/2:f0:-f0;
f=[f2,f1];
t0=1/Fs;
t= t0:t0:s/Fs;


white = randn(s,1);
white = max(y)*white/max(white);
b = firpm(1000,[0 fs1 fp1 fp2 fs2 1],[0 0 1 1 0 0]);
colornoise = filter(b,1,white);

sujo = colornoise+y;

M = ceil(32/(2.285*pi*100/(Fs/2)));
M=M+mod(M,2);
w = kaiser(M+1,3.329);
n=[1:M+1];

fc1=(fp1+fs1)/2;
fc2=(fp2+fs2)/2;


hd = ((sinc((fc1)*(n-M/2))*fc1)-(sinc(fc2*(n-M/2))*fc2));



hd(M/2)=hd(M/2)+1;

h=(hd'.*w);

out = filter(h,1,sujo);


%OUT = fftshift(fft(out));
%out = ifft(OUT1);
%plot(freq,abs(SfUJO));
figure

fig1=plot(f,abs(fftshift(fft(y)))), title("sinal de audio na frequencia"), xlabel("frequencia (Hz)"); 
saveas(fig1,"audio_freq","jpeg");
figure
fig2=plot(f,abs(fftshift(fft(sujo)))), title("sinal corrompido na frequencia");
xlabel("frequencia (Hz)"); 
saveas(fig2,"corromp_freq","jpeg");
figure
fig3=plot(t,sujo), title("sinal corrompido no tempo");xlabel("tempo (s)"); 
saveas(fig3,"corromp_time","jpeg");
figure
fig4=plot(abs(fftshift(fft(out)))), title("saida do sinal na frequencia");xlabel("frequencia (Hz)"); 
saveas(fig4,"out_freq","jpeg");

figure
fig5=plot(f,abs(fftshift(fft(colornoise)))), title("ruido na frequencia");
xlabel("frequencia (Hz)"); 
saveas(fig5,"colorido_freq","jpeg");
figure
fig6=plot(t,colornoise), title("ruido no tempo");
xlabel("tempo(s)"); 
saveas(fig6,"color_time","jpeg");
figure
fig7=plot(abs(fftshift(fft(h)))), title("filtro com janela de kaiser na frequencia");
xlabel("frequencia (Hz)"); 
saveas(fig7,"kaiser_freq","jpeg");
%sound(out,Fs)

figure

fig8=plot(t,y), title("sinal de audio no tempo");
xlabel("audio (s)"); 
saveas(fig8,"audio_time","jpeg");

%plot(n,sujo);
figure
plot(t,out), title("saida do sinal no tempo");
xlabel("tempo (s)"); 
saveas(fig7,"out_time","jpeg");

        