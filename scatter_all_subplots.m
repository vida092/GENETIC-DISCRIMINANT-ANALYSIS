function scatter_all_subplots(database)
    % Archivos
    original = database + ".csv";
    lda = "LDA_" + database + ".csv";
    glda = "GA-LDA_ " + database + ".csv";
    gpda2d = "GPDA_2D_" + database + ".csv";
    gpda3d = "GPDA_3D_" + database + ".csv";

    % Colores y marcadores
    color_scale = [
        0.00, 0.45, 0.70;
        0.85, 0.33, 0.10;
        0.00, 0.60, 0.20
    ];
    markers = {'o', 's', '^', 'd', 'p', 'h', '*'};

    % Crear figura general
    figure;

    % --- Subplot 1: Original 3D ---
    data = readmatrix(original);
    labels = data(:, end);
    classes = unique(labels);
    subplot(2, 3, 1);
    hold on; grid on;
    for i = 1:length(classes)
        class_data = data(labels == classes(i), 1:3);
        scatter3(class_data(:, 1), class_data(:, 2), class_data(:, 3), 50, color_scale(i, :), markers{i}, 'filled');
    end
    title('Original 3D');
    legend(arrayfun(@(x) ['Class ' num2str(x)], classes, 'UniformOutput', false));
    hold off;

    % --- Subplot 2: LDA 2D ---
    data = readmatrix(lda);
    labels = data(:, end);
    subplot(2, 3, 2);
    hold on; grid on;
    for i = 1:length(classes)
        class_data = data(labels == classes(i), 1:2);
        scatter(class_data(:, 1), class_data(:, 2), 50, color_scale(i, :), markers{i}, 'filled');
    end
    title('LDA 2D');
    legend(arrayfun(@(x) ['Class ' num2str(x)], classes, 'UniformOutput', false));
    hold off;

    % --- Subplot 3: GA-LDA 2D ---
    data = readmatrix(glda);
    labels = data(:, end);
    subplot(2, 3, 3);
    hold on; grid on;
    for i = 1:length(classes)
        class_data = data(labels == classes(i), 1:2);
        scatter(class_data(:, 1), class_data(:, 2), 50, color_scale(i, :), markers{i}, 'filled');
    end
    title('GA-LDA 2D');
    legend(arrayfun(@(x) ['Class ' num2str(x)], classes, 'UniformOutput', false));
    hold off;

    % --- Subplot 4: GPDA 2D ---
    data = readmatrix(gpda2d);
    labels = data(:, end);
    subplot(2, 3, 4);
    hold on; grid on;
    for i = 1:length(classes)
        class_data = data(labels == classes(i), 1:2);
        scatter(class_data(:, 1), class_data(:, 2), 50, color_scale(i, :), markers{i}, 'filled');
    end
    title('GPDA 2D');
    legend(arrayfun(@(x) ['Class ' num2str(x)], classes, 'UniformOutput', false));
    hold off;

    % --- Subplot 5: GPDA 3D ---
    data = readmatrix(gpda3d);
    labels = data(:, end);
    subplot(2, 3, 5);
    hold on; grid on;
    for i = 1:length(classes)
        class_data = data(labels == classes(i), 1:3);
        scatter3(class_data(:, 1), class_data(:, 2), class_data(:, 3), 50, color_scale(i, :), markers{i}, 'filled');
    end
    title('GPDA 3D');
    legend(arrayfun(@(x) ['Class ' num2str(x)], classes, 'UniformOutput', false));
    hold off;
end