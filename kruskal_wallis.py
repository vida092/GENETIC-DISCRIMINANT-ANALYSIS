import numpy as np
import scipy.stats as stats
import pandas as pd
import os

# Lista de archivos proporcionada
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

# Diccionario para agrupar los archivos por base de datos
grupos = {
    "datos8": [],
    "golub_cleaned": [],
    "diabetes": [],
    "iris": []
}

# Clasificar los archivos en el diccionario
for archivo in archivos:
    if "datos8" in archivo:
        grupos["datos8"].append(archivo)
    elif "golub_cleaned" in archivo:
        grupos["golub_cleaned"].append(archivo)
    elif "diabetes" in archivo:
        grupos["diabetes"].append(archivo)
    elif "iris" in archivo:
        grupos["iris"].append(archivo)

# Realizar la prueba de Kruskal-Wallis para cada conjunto de datos
resultados = []

print("Resultados de la Prueba de Kruskal-Wallis\n")
for dataset, files in grupos.items():
    grupos_datos = []
    nombres = []

    print(f"\nBase de Datos: {dataset}")

    for file in files:
        # Cargar los datos desde el archivo CSV
        try:
            datos = pd.read_csv(file, header=None).squeeze()
            datos = np.round(datos,3)
            grupos_datos.append(datos)

            # Extraer el nombre del algoritmo a partir del archivo
            if "3D" in file:
                nombres.append("GPDA 3D")
            elif "2D" in file:
                nombres.append("GPDA 2D")
            elif "glda" in file.lower():
                nombres.append("GLDA")

            # Mostrar estadísticas descriptivas
            print(f"  Algoritmo: {nombres[-1]}")
            print(f"    Media: {np.mean(datos):.4f}")
            print(f"    Desviación estándar: {np.std(datos, ddof=1):.4f}")
            print(f"    Mediana: {np.median(datos):.4f}")
            print(f"    Mínimo: {np.min(datos):.4f}")
            print(f"    Máximo: {np.max(datos):.4f}")
        except Exception as e:
            print(f"  ⚠️ No se pudo cargar el archivo {file}: {e}")

    # Realizar la prueba de Kruskal-Wallis solo si hay al menos dos grupos
    if len(grupos_datos) > 1:
        kruskal_stat, kruskal_p = stats.kruskal(*grupos_datos)
        print(f"\n  Prueba de Kruskal-Wallis:")
        print(f"    Estadístico H = {kruskal_stat:.4f}")
        print(f"    Valor p = {kruskal_p:.4f}")

        if kruskal_p < 0.05:
            conclusion = "Hay diferencias significativas entre los algoritmos."
            print(f"    ✅ {conclusion}")
        else:
            conclusion = "No hay diferencias significativas entre los algoritmos."
            print(f"    ❌ {conclusion}")

        # Guardar resultados en una lista
        resultados.append([dataset, kruskal_stat, kruskal_p, conclusion])
    else:
        print(f"  ⚠️ No hay suficientes grupos para comparar en la base de datos {dataset}.")

# Guardar los resultados en un archivo CSV
df_resultados = pd.DataFrame(resultados, columns=["Base de Datos", "Estadístico H", "Valor p", "Conclusión"])
df_resultados.to_csv("resultados_kruskal_wallis.csv", index=False)
print("\nResultados guardados en 'resultados_kruskal_wallis.csv'")
