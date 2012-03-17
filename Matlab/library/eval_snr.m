%Calculate overall signal to noise ratio. 
%
%signal       - original signal uncorrupted by noise
%noisy_signal - original signal corrupted by noise
%
%Signals are considered equal in size.
function ston = eval_snr(signal, noisy_signal)

	noise  = noisy_signal - signal; 
    
	signal = signal.^2; 
	noise  = noise.^2; 

	ston = 10 * log10(sum(signal(:)/sum(noise(:))));  

end