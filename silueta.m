
clc
clear
close all
% Nombres de los archivos CSV
fileNames = {
    'datos8.csv', 'GPDA_3D_datos8.csv',"GPDA_2D_datos8.csv" , 'PCA+LDA_datos8_2-dimension.csv'
};


% Títulos personalizados para cada gráfico
plotTitles = {'Original', 'GPDA3D', ...
              'GPDA2D', 'PCA+LDA'};

% Leer datos y etiquetas del primer archivo
data = readmatrix(fileNames{1});
X_ref = data(:, 1:end-1); % Características del primer archivo
labels_ref = data(:, end); % Última columna: etiquetas de referencia
classes = unique(labels_ref); % Clases únicas (definidas desde el primer archivo)

% Símbolos para distinguir las clases
symbols = {'o', 's', '^', 'd', 'p', 'h'}; % Figuras (círculo, cuadrado, triángulo, etc.)

% Escala de grises (un nivel de gris por clase)
numClasses = length(classes);
grayscale = linspace(0.1, 0.8, numClasses)'; % Escala de grises (valores entre negro y gris claro)
colors = repmat(grayscale, 1, 3); % Convertir en formato RGB

% Crear figura grande
figure;
tiledlayout(2, 2); % 2 filas x 2 columnas para los gráficos

% Bucle para procesar cada archivo
for i = 1:length(fileNames)
    % Leer datos del archivo CSV
    data = readmatrix(fileNames{i});
    
    % Determinar si el archivo tiene etiquetas (última columna)
    if size(data, 2) == size(X_ref, 2) + 1
        % Archivo con etiquetas: separar características y etiquetas
        X = data(:, 1:end-1);
        labels = data(:, end); % Usar etiquetas propias del archivo
    else
        % Archivo sin etiquetas: usar características y etiquetas de referencia
        X = data;
        labels = labels_ref; % Usar etiquetas de referencia
    end

    % Subplot correspondiente
    nexttile;

    % Validar la cantidad de columnas en los datos
    [numSamples, numFeatures] = size(X); % `numFeatures` es el número de columnas de X

    % 3D para los dos primeros archivos
    if i <= 2 && numFeatures >= 3
        hold on;
        for j = 1:numClasses
            % Filtrar datos por clase
            classData = X(labels == classes(j), :);

            % Graficar en 3D
            scatter3(classData(:, 1), classData(:, 2), classData(:, 3), ...
                50, colors(j, :), symbols{j}, 'filled', 'DisplayName', sprintf('Class %d', classes(j)));
        end
        xlabel('Dim 1'); ylabel('Dim 2'); zlabel('Dim 3');
        title(plotTitles{i}); % Usar título personalizado
        grid on; box on;

    % 2D para los últimos dos archivos
    elseif numFeatures >= 2
        hold on;
        for j = 1:numClasses
            % Filtrar datos por clase
            classData = X(labels == classes(j), :);

            % Graficar en 2D
            scatter(classData(:, 1), classData(:, 2), ...
                50, colors(j, :), symbols{j}, 'filled', 'DisplayName', sprintf('Class %d', classes(j)));
        end
        xlabel('Dim 1'); ylabel('Dim 2');
        title(plotTitles{i}); % Usar título personalizado
        grid on; box on;

    % 1D para datos con solo 1 columna (no esperado aquí, pero manejado por seguridad)
    else
        hold on;
        for j = 1:numClasses
            % Filtrar datos por clase
            classData = X(labels == classes(j), :);

            % Graficar en 1D
            scatter(classData(:, 1), zeros(size(classData, 1), 1), ...
                50, colors(j, :), symbols{j}, 'filled', 'DisplayName', sprintf('Class %d', classes(j)));
        end
        xlabel('Dim 1'); ylabel('Dim 2 (Constante)');
        title(plotTitles{i}); % Usar título personalizado
        grid on; box on;
    end

    % Configurar la leyenda para cada subplot
    legend('show', 'Location', 'best');
    hold off;
end

% Ajustar el diseño de la figura
sgtitle('Scatter plots transformations for Synthetic Data'); % Título general
