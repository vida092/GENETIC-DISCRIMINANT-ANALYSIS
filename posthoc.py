import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from scipy.stats import mannwhitneyu

# Cargar los datos
fitness_3d = pd.read_csv('iris_best_fitnes_3D.txt', header=None, names=['Fitness'])
fitness_3d['Algorithm'] = 'GPDA 3D'

fitness_2d = pd.read_csv('iris_best_fitnesses_2D.txt', header=None, names=['Fitness'])
fitness_2d['Algorithm'] = 'GPDA 2D'

glda_silueta = pd.read_csv('iris_glda_silueta.csv', header=None, names=['Fitness'])
glda_silueta['Algorithm'] = 'GLDA'

# Unir los tres DataFrames
data = pd.concat([fitness_3d, fitness_2d, glda_silueta], ignore_index=True)

# Prueba post hoc (Mann-Whitney U) para comparaciones por pares
_, p_3d_2d = mannwhitneyu(fitness_3d['Fitness'], fitness_2d['Fitness'])
_, p_3d_glda = mannwhitneyu(fitness_3d['Fitness'], glda_silueta['Fitness'])
_, p_2d_glda = mannwhitneyu(fitness_2d['Fitness'], glda_silueta['Fitness'])

# Función para determinar el número de asteriscos según el valor p
def significance_label(p):
    if p < 0.001:
        return '***'
    elif p < 0.01:
        return '**'
    elif p < 0.05:
        return '*'
    else:
        return 'ns'  # No significativo

# Crear la gráfica combinada
plt.figure(figsize=(10, 6))

# Boxplot con swarmplot
sns.boxplot(x='Algorithm', y='Fitness', data=data, width=0.5, fliersize=5, linewidth=1.5, color="lightgray")
sns.swarmplot(x='Algorithm', y='Fitness', data=data, color='blue', alpha=0.7)

# Anotaciones de significancia
def add_significance(x1, x2, y, text):
    plt.plot([x1, x1, x2, x2], [y, y + 0.01, y + 0.01, y], lw=1.5, color='black')
    plt.text((x1 + x2) * 0.5, y + 0.02, text, ha='center', va='bottom', color='black', fontweight='bold')

# Añadir anotaciones entre algoritmos con asteriscos
y_max = data['Fitness'].max() + 0.02
add_significance(0, 1, y_max, significance_label(p_3d_2d))
add_significance(0, 2, y_max + 0.03, significance_label(p_3d_glda))
add_significance(1, 2, y_max + 0.06, significance_label(p_2d_glda))

# Ajustes finales
plt.title('Comparación de Algoritmos - Boxplot con Significancia Estadística')
plt.xlabel('Algoritmo')
plt.ylabel('Fitness')

plt.show()
