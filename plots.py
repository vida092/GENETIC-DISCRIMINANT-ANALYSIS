import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

# Crear un DataFrame conjunto con los datos
fitness_3d = pd.read_csv('iris_best_fitnes_3D.txt', header=None, names=['Fitness'])[:30]

fitness_3d['Algorithm'] = 'GPDA 3D'

fitness_2d = pd.read_csv('iris_best_fitnesses_2D.txt', header=None, names=['Fitness'])[:30]
fitness_2d['Algorithm'] = 'GPDA 2D'

glda_silueta = pd.read_csv('iris_glda_silueta.csv', header=None, names=['Fitness'])
glda_silueta['Algorithm'] = 'GLDA'

# Unir los tres DataFrames
data = pd.concat([fitness_3d, fitness_2d, glda_silueta], ignore_index=True)

# Ajustar el tamaño de la figura
plt.figure(figsize=(10, 6))

# Boxplot con ajuste del ancho de caja
sns.boxplot(x='Algorithm', y='Fitness', data=data, width=0.4, fliersize=5, linewidth=1.5, color="lightgray")

# Añadir puntos con Swarmplot
sns.swarmplot(x='Algorithm', y='Fitness', data=data, color='blue', alpha=0.7)

# Añadir etiquetas de mediana
medianas = data.groupby('Algorithm')['Fitness'].median()
for index, median in enumerate(medianas):
    plt.text(index, median, f'{median:.4f}', 
             horizontalalignment='center', 
             verticalalignment='bottom', 
             fontweight='bold', 
             color='black')

plt.title('Comparación de Algoritmos - Boxplot y Swarmplot Combinados')
plt.xlabel('Algoritmo')
plt.ylabel('Fitness')

plt.show()
