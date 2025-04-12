clc
clear
tic

name = 'wine';
filename = name + ".csv";
data = readmatrix(filename);

X = data(:, 1:end-1);
y = data(:, end);

% División 70/30 de los datos
total_samples = size(X, 1);
idx = randperm(total_samples);
train_size = round(0.7 * total_samples);

X_train = X(idx(1:train_size), :);
y_train = y(idx(1:train_size), :);
X_test = X(idx(train_size+1:end), :);
y_test = y(idx(train_size+1:end), :);

% Combinación para aplicar transformación al 100%
X_full = [X_train; X_test];
y_full = [y_train; y_test];

k = 3;
dim = string(k);
fprintf('Calculando el rango de la matriz de covarianza intra-clase...\n');

classes = unique(y_train);
num_classes = length(classes);
[n, d] = size(X_train);

% Centrar los datos
X_mean = mean(X_train, 1);
X_centered = X_train - X_mean;

% Matriz de dispersión intra-clase (Sw)
Sw = zeros(d, d);
for i = 1:num_classes
    class_data = X_train(y_train == classes(i), :);
    class_mean = mean(class_data, 1);
    Sw = Sw + (class_data - class_mean)' * (class_data - class_mean);
end

rank_Sw = rank(Sw);
fprintf('El rango de la matriz de covarianza intra-clase es: %d\n', rank_Sw);

h = rank_Sw;
fprintf('Aplicando PCA para reducir de %d a %d dimensiones...\n', d, h);

cov_matrix = cov(X_centered);
[eig_vectors, eig_values] = eig(cov_matrix);
[eig_values_sorted, idx] = sort(diag(eig_values), 'descend');
eig_vectors_sorted = eig_vectors(:, idx);
W_pca = eig_vectors_sorted(:, 1:h);
X_pca_train = X_centered * W_pca;

% Aplicar PCA a todo el conjunto
X_full_centered = X_full - X_mean;
X_pca_full = X_full_centered * W_pca;

% LDA
fprintf('Aplicando LDA para reducir de %d a %d dimensiones...\n', h, k);
mean_total = mean(X_pca_train, 1);
Sb = zeros(h, h);
Sw_lda = zeros(h, h);
for i = 1:num_classes
    class_data = X_pca_train(y_train == classes(i), :);
    class_mean = mean(class_data, 1);
    Sw_lda = Sw_lda + (class_data - class_mean)' * (class_data - class_mean);
    class_size = size(class_data, 1);
    mean_diff = (class_mean - mean_total)';
    Sb = Sb + class_size * (mean_diff * mean_diff');
end

[eig_vectors_lda, eig_values_lda] = eig(Sb, Sw_lda);
[eig_values_sorted_lda, idx_lda] = sort(diag(eig_values_lda), 'descend');
eig_vectors_sorted_lda = eig_vectors_lda(:, idx_lda);
W_lda = eig_vectors_sorted_lda(:, 1:k);
X_lda_full = X_pca_full * W_lda;
X_final = [X_lda_full y_full];
% writematrix(X_final, "PCA+LDA_" + name + "_" + dim + "-dimension.csv");

fprintf('Dimensiones finales: %d\n', k);

% === Visualization (2D and 3D subplots with class colors/markers) ===
classColors = {'r', 'g', 'b', 'c', 'm', 'y', 'k'};  % Add more if needed
classMarkers = {'o', 's', '^', 'd', 'v', 'x', '+'};
classes = unique(y_full);
numClasses = length(classes);

dims = [2, 3];
figure;

for i = 1:2
    dim = dims(i);
    if k < dim
        continue;
    end

    subplot(1, 2, i);
    hold on;

    for j = 1:numClasses
        idx = y_full == classes(j);
        if dim == 2
            scatter(X_lda_full(idx, 1), X_lda_full(idx, 2), 50, ...
                classColors{mod(j-1, length(classColors))+1}, ...
                classMarkers{mod(j-1, length(classMarkers))+1});
        else
            scatter3(X_lda_full(idx, 1), X_lda_full(idx, 2), X_lda_full(idx, 3), 50, ...
                classColors{mod(j-1, length(classColors))+1}, ...
                classMarkers{mod(j-1, length(classMarkers))+1});
        end
    end

    title(sprintf('PCA + LDA Projection (%dD)', dim));
    xlabel('Component 1'); ylabel('Component 2');
    if dim == 3, zlabel('Component 3'); end
    legend("Class " + string(classes), 'Location', 'best');
    grid on; axis tight;
    hold off;
end

toc
