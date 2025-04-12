% Leer imágenes
img_rgb = imread('input17.png');     % Tamaño: 584x565x3
mask = imread('target17.png');       % Tamaño: 584x565

% Convertir la máscara a lógica si es necesario
if ~islogical(mask)
    mask = mask > 0;
end

% Convertir imagen RGB a doble para análisis
img_rgb = double(img_rgb);

% Obtener dimensiones
[rows, cols, ~] = size(img_rgb);
num_pixels = rows * cols;

% Aplanar la imagen RGB
R = reshape(img_rgb(:,:,1), num_pixels, 1);
G = reshape(img_rgb(:,:,2), num_pixels, 1);
B = reshape(img_rgb(:,:,3), num_pixels, 1);

% Aplanar la máscara binaria
label = reshape(mask, num_pixels, 1);

% Crear base de datos como tabla
pixel_data = table(R, G, B, label, ...
    'VariableNames', {'R', 'G', 'B', 'IsVessel'});

