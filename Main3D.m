clc
clear
database_list = {"iris", "golub_cleaned"};


for i = 1:numel(database_list)
    database = database_list{i};
    tic
    % disp("procesando base de datos " + database + " caso 2D")
    % genetic_algorithm_2D(database)
    
    disp("procesando base de datos " + database + " caso 3D")
    genetic_algorithm_3D(database)   
    toc
end


