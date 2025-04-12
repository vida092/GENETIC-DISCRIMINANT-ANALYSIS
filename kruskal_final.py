import pandas as pd
from scipy.stats import kruskal

# Cargar los archivos de texto (asumimos que tienen una sola columna de valores)
fitness_3d = pd.read_csv('iris_best_fitnes_3D.txt', header=None).squeeze()[: 30]
fitness_2d = pd.read_csv('iris_best_fitnesses_2D.txt', header=None).squeeze()[:30]

# Cargar el archivo CSV (también asumimos que tiene una sola columna)
glda_silueta = pd.read_csv('iris_glda_silueta.csv', header=None).squeeze()

print("GPDA 3D:")
print(fitness_3d.describe())
print("\nGPDA 2D:")
print(fitness_2d.describe())
print("\nGLDA:")
print(glda_silueta.describe())


# Prueba de Kruskal-Wallis
stat, p_value = kruskal(fitness_3d, fitness_2d, glda_silueta)

print(f'\nEstadístico H: {stat:.4f}')
print(f'Valor p: {p_value:.4e}')

# Interpretación del resultado
alpha = 0.05
if p_value < alpha:
    print("Rechazamos la hipótesis nula: al menos un grupo tiene una mediana significativamente diferente.")
else:
    print("No se rechaza la hipótesis nula: no hay evidencia suficiente para afirmar que las medianas sean diferentes.")


import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

# Crear un DataFrame conjunto con los datos
fitness_3d = pd.read_csv('iris_best_fitnes_3D.txt', header=None, names=['Fitness'])
fitness_3d['Algorithm'] = 'GPDA 3D'

fitness_2d = pd.read_csv('iris_best_fitnesses_2D.txt', header=None, names=['Fitness'])
fitness_2d['Algorithm'] = 'GPDA 2D'

glda_silueta = pd.read_csv('iris_glda_silueta.csv', header=None, names=['Fitness'])
glda_silueta['Algorithm'] = 'GLDA'

# Unir los tres DataFrames
data = pd.concat([fitness_3d, fitness_2d, glda_silueta], ignore_index=True)

# Configurar el tamaño de la figura
plt.figure(figsize=(14, 6))

# Boxplot
plt.subplot(1, 3, 1)
sns.boxplot(x='Algorithm', y='Fitness', data=data)
plt.title('Boxplot de Fitness por Algoritmo')

# Violin Plot
plt.subplot(1, 3, 2)
sns.violinplot(x='Algorithm', y='Fitness', data=glda_silueta)
plt.title('Violin Plot de Fitness por Algoritmo')
 
# Swarm Plot
plt.subplot(1, 3, 3)
sns.swarmplot(x='Algorithm', y='Fitness', data=data)
plt.title('Swarm Plot de Fitness por Algoritmo')

plt.tight_layout()
plt.show()
