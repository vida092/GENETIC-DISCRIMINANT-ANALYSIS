import numpy as np
import pandas as pd
import scikit_posthocs as sp
import os

# Cargar los resultados de Kruskal-Wallis
df_resultados = pd.read_csv("resultados_kruskal_wallis.csv")
archivos = [
    'datos8_best_fitnes_3D.csv',
    'datos8_best_fitnesses_2D.csv',
    'golub_cleaned_best_fitnes_3D.csv',
    'golub_cleaned_best_fitnesses_2D.csv',
    'diabetes_best_fitnes_3D.csv',
    'diabetes_best_fitnesses_2D.csv',
    'diabetes_glda_silueta.csv',
    'iris_best_fitnes_3D.csv',
    'iris_best_fitnesses_2D.csv',
    'iris_glda_silueta.csv'
]
print("\nAnálisis Post-Hoc: Test de Dunn (por cada conjunto con diferencias significativas)\n")

for index, row in df_resultados.iterrows():
    dataset = row["Base de Datos"]
    p_value = row["Valor p"]

    if p_value < 0.05:
        print(f"Base de Datos: {dataset} - Diferencias significativas detectadas")
        
        # Encontrar los archivos correspondientes a este conjunto
        archivos = [
            f for f in os.listdir(".")
            if f.startswith(dataset) and f.endswith(".csv")
        ]

        # Preparar listas para construir el DataFrame en formato largo
        valores = []
        grupos = []

        # Cargar los datos para el análisis post-hoc
        for archivo in archivos:
            try:
                datos = pd.read_csv(archivo, header=None).squeeze()

                # Verificar si el archivo tiene datos válidos
                if datos.empty or len(datos) == 0:
                    print(f"  ⚠️ Archivo {archivo} está vacío o no contiene datos válidos. Omitido.")
                    continue

                # Determinar el nombre del algoritmo según el archivo
                if "3D" in archivo:
                    algoritmo = "GPDA 3D"
                elif "2D" in archivo:
                    algoritmo = "GPDA 2D"
                elif "glda" in archivo.lower():
                    algoritmo = "GLDA"
                else:
                    algoritmo = "Desconocido"
                
                # Agregar los valores y los nombres de grupo al DataFrame
                valores.extend(list(datos))
                grupos.extend([algoritmo] * len(datos))

            except Exception as e:
                print(f"  ⚠️ No se pudo cargar el archivo {archivo}: {e}")

        # Verificar si hay al menos dos grupos con datos válidos
        if len(grupos) < 2 or len(valores) < 2:
            print(f"  ❌ No hay suficientes grupos con datos válidos para {dataset}. Omitido.\n")
            continue

        # Crear el DataFrame en formato largo
        try:
            data_long = pd.DataFrame({"Algoritmo": grupos, "Valor": valores})

            # Realizar el test de Dunn
            dunn_result = sp.posthoc_dunn(data_long, val_col='Valor', group_col='Algoritmo', p_adjust='bonferroni')
            print(f"\nResultados del Test de Dunn para {dataset}:\n")
            print(dunn_result)
            
            # Guardar los resultados en un archivo CSV individual por cada dataset
            filename = f"posthoc_dunn_{dataset}.csv"
            dunn_result.to_csv(filename)
            print(f"Resultados guardados en '{filename}'\n")

        except Exception as e:
            print(f"  ⚠️ No se pudo realizar el Test de Dunn para {dataset}: {e}")
