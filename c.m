% fid = fopen('segment.scale','r');
% labels = [];
% data =[];
% row = 1;
% 
% 
% while ~feof(fid)
%     line = fgetl(fid); % Leer una línea
%     tokens = strsplit(line, ' '); % Separar por espacio
% 
%     % La primera entrada es la etiqueta
%     labels(row,1) = str2double(tokens{1});
% 
%     % Procesar pares columna:valor
%     for i = 2:length(tokens)
%         if ~isempty(tokens{i})
%             pair = strsplit(tokens{i}, ':'); % Separar índice y valor
%             col = str2double(pair{1}); % Número de columna
%             value = str2double(pair{2}); % Valor asociado
%             data = [data; row, col, value]; % Guardar en la matriz de datos
%         end
%     end
%     row = row + 1; % Incrementar fila
% end
% 
% 
% fclose(fid);
% 
% % Convertir a matriz dispersa
% num_rows = max(data(:,1)); % Determinar filas
% num_cols = max(data(:,2)); % Determinar columnas
% M = sparse(data(:,1), data(:,2), data(:,3), num_rows, num_cols);
% 
% % Mostrar resultado
% disp('Etiquetas:')
% disp(labels)
% 
% disp('Matriz dispersa:')
% disp(full(M)) % Mostrar como matriz completa (opcional)
% db = [full(M),labels];
% 
% writematrix(db,"segment.csv")

M =readmatrix("GPDA_3D_new_trial_golub_cleaned.csv");

X = M(:, 1);
Y = M(:, 2);
Z = M(:, 3);
A = readmatrix("GPDA_3D_new_trial_golub_cleaned.csv");
labels = A(:, end);

unique_labels = unique(labels);

% Definir colores automáticamente (se puede modificar)
colors = lines(length(unique_labels)); 

Crear figura 3D
figure;
hold on;
grid on;

% Graficar cada clase con un color diferente
for i = 1:length(unique_labels)
    idx = labels == unique_labels(i); % Índices de la clase actual
    scatter3(X(idx), Y(idx), Z(idx), 36, colors(i, :), 'filled');
end


