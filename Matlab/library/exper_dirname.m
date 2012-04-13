%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Add timestamp to a directory name %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% exp_name - experiment name
%%% dir_name - resulting directory name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dir_name = exper_dirname(exp_name)

    dir_name = [get_date_string ' ' exp_name];

end