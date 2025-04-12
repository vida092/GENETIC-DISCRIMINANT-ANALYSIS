clc
clear
file="wine";
fileName = file +".csv"; % Nombre del archivo CSV
data = readmatrix(fileName);

% Separar características y etiquetas
X = data(:, 1:end-1); % Todas las columnas excepto la última
labels = data(:, end); % Última columna con etiquetas

% Obtener clases únicas
classes = unique(labels);
numClasses = length(classes);
[numSamples, numFeatures] = size(X);

% Inicializar matrices
Sw = zeros(numFeatures); % Matriz de dispersión intra-clase
Sb = zeros(numFeatures); % Matriz de dispersión entre-clases
meanTotal = mean(X, 1); % Media global

% Cálculo de Sw y Sb
for i = 1:numClasses
    % Datos de la clase actual
    classData = X(labels == classes(i), :);
    
    % Media de la clase actual
    meanClass = mean(classData, 1);
    
    % Dispersión intra-clase (Sw)
    Sw = Sw + (classData - meanClass)' * (classData - meanClass);
    
    % Dispersión entre-clases (Sb)
    numSamplesClass = size(classData, 1);
    meanDiff = (meanClass - meanTotal)';
    Sb = Sb + numSamplesClass * (meanDiff * meanDiff');
end

% Resolver el problema de valores propios: Sb * w = lambda * Sw * w
[eigVecs, eigVals] = eig(Sb, Sw);

% Ordenar los valores propios y vectores propios (de mayor a menor)
[eigValsSorted, sortIdx] = sort(diag(eigVals), 'descend');
eigVecsSorted = eigVecs(:, sortIdx);

% Selección de dimensiones (proyección)
disp('Autovalores ordenados:');
disp(eigValsSorted'); % Mostrar autovalores

numDimensions = 2;

if numDimensions > size(eigVecsSorted, 2)
    error('La dimensión seleccionada supera el número total de dimensiones posibles.');
end

% Proyección de los datos al subespacio LDA
W = eigVecsSorted(:, 1:numDimensions); % Selección de las primeras dimensiones
X_LDA = X * W; % Datos proyectados
writematrix(X_LDA, "LDA_" + fileName)
% Visualización (si la dimensión es 1 o 2)
if numDimensions == 1
    scatter(X_LDA, zeros(size(X_LDA)), 50, labels, 'filled');
    xlabel('LDA Dim 1');
    title('Proyección LDA en 1D');
elseif numDimensions == 2
    scatter(X_LDA(:, 1), X_LDA(:, 2), 50, labels, 'filled');
    xlabel('LDA Dim 1');
    ylabel('LDA Dim 2');
    title('Proyección LDA en 2D');
else
    disp('Proyección completada, pero no se puede visualizar en más de 2 dimensiones.');
end


