function date_str = get_date_string

fix(clock); 

c = fix(clock); 
    
%[year month day hour minute seconds]
date_str = sprintf('%04d-%02d-%02d %02d%02d%02d', c(1), c(2), c(3), c(4), c(5), c(6));   

end