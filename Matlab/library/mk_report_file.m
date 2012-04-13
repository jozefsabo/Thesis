%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Create report file %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% output_path - directory location of file
%%% file_name   - name of the file 
%%% fileID      - returned file descriptor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fileID = mk_report_file(output_path, file_name)

    long_name   = [output_path file_name];   
    fileID      = fopen([output_path file_name], 'w', 'n', 'UTF-8');

end