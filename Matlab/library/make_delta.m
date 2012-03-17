function delta = make_delta(h,w)
	delta = zeros(h,w); 
	delta( floor(h/2) + 1, floor(w/2) + 1) = 1;  
end