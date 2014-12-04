# Random quantization noise
N = 32 # Number of samples
D = 1 # Quantization step ($\Delta$)
q = () -> D*(rand([N])-0.5) # rand $\in$ [0, 1]

# <a href="http://au.mathworks.com/help/signal/ug/psd-estimate-using-fft.html">Welch periodogram</a>. 
 # NB: this is for a <b>two-sided</b> PSD.
 # (i.e., including -ve frequencies)
FFT = (u)-> complex(u,u*0).fft()# Workaround for real u.
fs = 1 # Samples per time unit
periodogram = () -> abs(FFT(q())).pow(2)/N/fs

# Averaging
 # Must average for a good estimate.
 # (Increasing N will not help.)
M = 64 # Number of averages
PSD = (0 for [1..N]) # Initialize
PSD += periodogram()/M for [1..M]

# Theory
dB = (u) -> 10*log(u)/log(10) # ln -> log10
dB(D.pow(2)/12/fs)

 # Note how the computed level in the plot
 # approaches the theoretical level as M is
 # increased (edit, then shift+enter to run).

plot [1..N], dB(PSD),
    xlabel: "bin"
    ylabel: "PSD (dB)"
    height: 220
    series:
        shadowSize: 0
        color: "green"
        lines: {lineWidth: 1, show:true}   
        points: {show: true}

 # Notes:
 #
 # The PSD units depend (of course) on the
 # units of the signal (q) and of the sample
 # rate (fs). E.g., if q is in Volts and fs
 # samples/second then, in a 1 Ohm system the
 # PSD units would be dBW/Hz (dB-Watt-per-Hz).
