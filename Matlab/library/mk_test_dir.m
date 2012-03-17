function test_dir = mk_test_dir(dir_path, exper_name)

    dir_path = [dir_path exper_dirname(exper_name)]; 
    mkdir(dir_path); 

    test_dir = dir_path; 
end