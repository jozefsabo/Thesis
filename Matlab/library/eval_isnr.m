%Evaluate iSNR
%orig_sig - original signal
%corr_sig - corrupted signal 
%est_sig  - estimated signal
function isnr_val = eval_isnr(orig_sig, corr_sig, est_sig)

	diff_sig1 = (orig_sig - corr_sig).^2; 
    diff_sig2 = (orig_sig - est_sig ).^2; 
    
    isnr_val  = 10 * log10 ( sum(diff_sig2(:)) / sum(diff_sig1(:))); 
end