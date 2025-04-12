import numpy as np
import scipy.stats as stats
import os
import pandas as pd

# Lista de archivos (asegúrate de que los nombres coincidan)
archivos = [
    'datos8_best_fitnes_3D.csv',
    'datos8_best_fitnesses_2D.csv',
    'golub_cleaned_best_fitnes_3D.csv',
    'golub_cleaned_best_fitnesses_2D.csv',
    'diabetes_best_fitnes_3D.csv',
    'diabetes_best_fitnesses_2D.csv',
    'diabetes_glda_silueta.csv',
    'iris_best_fitnes_3D.txt',
    'iris_best_fitnesses_2D.txt',
    'iris_glda_silueta.csv'
]

print("Prueba de Normalidad (Shapiro-Wilk)\n")
for archivo in archivos:
    if os.path.exists(archivo):
        datos = pd.read_csv(archivo, header=None).squeeze()


        shapiro_test = stats.shapiro(datos)

        # Mostrar resultados

        print(f"Archivo: {archivo}")
        print(f"  Estadístico: {shapiro_test.statistic}")
        print(f"    Media: {np.mean(datos):.4f}")
        print(f"    Desviación estándar: {np.std(datos, ddof=1):.4f}")
        print(f"    Mediana: {np.median(datos):.4f}")
        print(f"    Mínimo: {np.min(datos):.4f}")
        print(f"    Máximo: {np.max(datos):.4f}")
        print(f"  Valor p: {shapiro_test.pvalue}")

        # Verificar si pasa la prueba de normalidad
        if shapiro_test.pvalue > 0.05:
            print("  No se rechaza H0: Los datos parecen normales.\n")
        else:
            print("  Se rechaza H0: Los datos no son normales.\n")
    else:
        print(f"Archivo {archivo} no encontrado.\n")
