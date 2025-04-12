clc
clear
% F1 scores obtenidos con dos métodos (color y median)
iris2D = readmatrix("diabetes_best_fitnesses_2D.txt"); 
irisGLDA = readmatrix("diabetes_glda_silueta.csv");
iris3D = readmatrix("diabetes_best_fitnes_3D.txt");
%Prueba Shapiro-Wilk 
[H_c, pValue_c, W_c] = swtest(iris2D, 0.05);
[H_m, pValue_m, W_m] = swtest(irisGLDA, 0.05);
[H_k, pValue_k, W_k] = swtest(iris3D, 0.05);

% Como hay distribuciones no normales se aplica Krukall-Wallis para comparar los métodos en el mismo conjunto de resultados

% Prueba Kruskall-wallis
[p,tbl,stats] = kruskalwallis([irisGLDA' iris2D' iris3D' ])
grid on
figure


% Prueba de comparación mútiple 
c = multcompare(stats);

grid on