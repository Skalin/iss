%Pro jistotu vse vycistime pred provadenim programu
clear all;

% 1) Nacteni signalu a zakladni prace nad nim
[Signal, Fs] = audioread('xskala11.wav');

%signal musi byt radkovy vektor, pomoci fce whos zjisteno, ze je sloupcovy, proto inverze na radkovy
Signal = Signal';

%zobrazime hodnoty vzorkovaci frekvence
fprintf('Vzorkovaci frekvence signalu xskala11.wav je: %d\n', Fs);

%delka signálu
siglen = length(Signal);
fprintf('Delka signalu xskala11.wav je: %d v S/s nebo %d sekunda\n', siglen, (siglen/Fs));

%2) FFT a spektrum
spectrum = fft(Signal);
f = (0:(Fs-1))/Fs*Fs/2;
plot(f,abs(spectrum));
print('Spectrum','-dpng');

%3) Hodnota spektra v maximu
[~, maxindex] = max(abs(spectrum));
max = maxindex/Fs * Fs;
fprintf('Maximum modulu spektra ma: %d Hz\n', max);


%4) Inicializace filtru
%implementujeme filtr za pomoci fce zplane, aby se nam lepe videlo, zda-li je filtr stabilni
%definice vstupu, pro pozdeji pouziti
a = [1 0.2289 0.4662]; % 1 na zacatku filtru sice indexove reprezentuje a0, ve skutecnosti je zde ale jen z nutnosti
b = [0.2324 -0.4112 0.2324];
zplane(b,a);
print('IIR_Filtr','-dpng');
%filtr stabilni je, protoze poly jsou uvnitr jednotkove kruznice

%5) Frekvencni charakteristika filtru
H = freqz(b,a, Fs/2);
N = length(H);
plot(abs(H));
print('IIR_Filtr_kmitocet', '-dpng');

%6) Filtrace 
%pro ucely filtru je treba doplnit a0, ackoliv neexistuje
h = filter(b,a,Signal);
result = fft(h);
plot(abs(result(1:Fs/2)));
print('IIR_Filtrace', '-dpng');

%7) Max. hodnota spektra filtrovaneho signalu 
[~,maxindex2] = max(abs(result(1:8000)));
fprintf('Maximum modulu spektra ma: %d Hz\n', maxindex2);

%8) Filtrace strednich hodnot signalu

%9) Autokorelacni koeficient pro hodnoty k = <-50,50>
Rv = xcorr(Signal, 'biased');
plot(-50:50,Rv(Fs-1-50:Fs-1+50));
print('Autokor_koef_signal','-dpng');

%10) Koeficient R[10] autokorelace
coeffr10 = Rv(Fs-1+10);
fprintf('Koeficient R[10] = %d\n', coeffr10);

%11) Casovy odhad struzene fce rozdeleni

%12) Overeni spravne hodnoty rozdeleni

%13) Autokorelacni efekt z fce spravne hodnoty rozdeleni
