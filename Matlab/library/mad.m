%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate median absolute deviation %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% sig     - input signal 
%%% mad_res - MAD value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function mad_res = mad(sig)
    % reshape signal into a 1 by N vector
    res_sig = reshape(signal, 1, []); 
    % median of the reshaped signal
    res_med = median(res_sig);
    % final value
    mad_res = median(abs(res_sig - res_med));       
end

