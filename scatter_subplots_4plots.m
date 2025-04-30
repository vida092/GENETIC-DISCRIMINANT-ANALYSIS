function scatter_subplots_4plots(database)
    % Generar nombres de archivo
    original = database + ".csv"; %3dimensiones primeras 3 coordenadas
    pclda = "PCA+LDA_" + database + "_3-dimension.csv"; %2dimensiones
    glda = "GA-LDA_" + database + ".csv"; %2dimensiones
    gpda2d = "GPDA_2D_" + database + ".csv"; %2 dimensiones
    gpda3d = "GPDA_3D_" + database + ".csv"; %3 dimensiones

    % Colores en escala de grises para distinguir clases
    grayscale_colors = [
    0.00, 0.45, 0.70;  % Azul oscuro 
    0.85, 0.33, 0.10;  % Naranja fuerte
    0.00, 0.60, 0.20;  % Verde oscuro
];  
    markers = {'o', 's', '^', 'd', 'p', 'h', '*'};

    % Crear figura con subplots (2 filas, 2 columnas)
    figure;

    % Original 3D
    data = readmatrix(original);
    labels = data(:, end);
    subplot(2, 2, 1);
    hold on;
    grid on;
    classes = unique(labels);
    legend_entries = cell(1, length(classes));
    for i = 1:length(classes)
        class_data = data(labels == classes(i), 1:3);
        scatter3(class_data(:, 1), class_data(:, 2), class_data(:, 3), 49, grayscale_colors(i,:), markers{i}, 'filled');
        legend_entries{i} = ['Class ' num2str(classes(i))];
    end
    title('Original 3D');
    legend(legend_entries);
    hold off;

    % PCA+LDA 3D
    data = readmatrix(pclda);
    labels = data(:, end);
    subplot(2, 2, 2);
    hold on;
    grid on;
    for i = 1:length(classes)
        class_data = data(labels == classes(i), 1:3);
        scatter3(class_data(:, 1), class_data(:, 2), class_data(:, 3), 50, grayscale_colors(i,:), markers{i}, 'filled');
    end
    title('PCA+LDA 3D');
    legend(legend_entries);
    hold off;

    % GPDA 2D
    data = readmatrix(gpda2d);
    labels = data(:,end);
    subplot(2, 2, 3);
    hold on;
    grid on;
    for i = 1:length(classes)
        class_data = data(labels == classes(i), 1:2);
        scatter(class_data(:, 1), class_data(:, 2), 50, grayscale_colors(i,:), markers{i}, 'filled');
    end
    title('GPDA 2D');
    legend(legend_entries);
    hold off;

    % GPDA 3D
    data = readmatrix(gpda3d);
    labels = data(:, end);
    subplot(2, 2, 4);
    hold on;
    grid on;
    for i = 1:length(classes)
        class_data = data(labels == classes(i), 1:3);
        scatter3(class_data(:, 1), class_data(:, 2), class_data(:, 3), 50, grayscale_colors(i,:), markers{i}, 'filled');
    end
    title('GPDA 3D');
    legend(legend_entries);
    hold off;
end
