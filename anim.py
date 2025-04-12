import numpy as np
from numpy import genfromtxt
import glob
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.cm as cm
from matplotlib.animation import PillowWriter 


folder_name = "best_individuals"
files = sorted(glob.glob(f"{folder_name}/matrix_*.csv"))

matrices = [np.loadtxt(f,delimiter=",") for f in files]
datos = genfromtxt("diabetes.csv", delimiter=',')
print("ñlaskjdfñlaksjdfñlaskjdfasdñljkf")



print(datos.shape)
labels= datos[:,-1]
datos = datos[:,:768]

print(labels.shape)
print(datos.shape)
num_frames = len(matrices)


# Asegurar que labels sea un array 1D y convertirlo a enteros
labels = np.array(labels).flatten().astype(int)

# Obtener etiquetas únicas (deben ser solo 3)
unique_labels = np.unique(labels)
print("Etiquetas únicas después de conversión:", unique_labels)  # Verifica que sean 3 valores distintos

# Asignar colores fijos a cada etiqueta
label_color_map = {
    unique_labels[0]: "blue",
    unique_labels[1]: "green",
    unique_labels[2]: "red"
}

# Convertir `labels` en colores según el diccionario
colors = np.array([label_color_map[label] for label in labels])

# Configurar la figura y los ejes en 3D
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Crear el scatter inicial sin datos
sc = ax.scatter([], [], [], c=[], edgecolors="k")

# Definir límites de la gráfica
ax.set_xlim(-7500, 6500)
ax.set_ylim(-7500, 6500)
ax.set_zlim(-7500, 6500)
ax.set_xlabel("Componente 1")
ax.set_ylabel("Componente 2")
ax.set_zlabel("Componente 3")
ax.set_title("Animación de Transformaciones Lineales en 3D")

# Función de inicialización
def init():
    sc._offsets3d = ([], [], [])
    sc.set_color([])  # Inicializar con colores vacíos
    return sc,

# Función para actualizar cada frame
def update(frame):
    transformed_data = datos @ matrices[frame]  # Aplicar la transformación lineal
    x, y, z = transformed_data[:, 0], transformed_data[:, 1], transformed_data[:, 2]

    sc._offsets3d = (x, y, z)  # Actualizar posiciones en 3D
    sc.set_color(colors)  # Aplicar colores fijos según etiquetas

    ax.set_title(f"Transformación {frame+1}")  # Actualizar título
    return sc,

# Crear la animación
ani = animation.FuncAnimation(fig, update, frames=len(matrices), init_func=init, blit=False, interval=500)
gif_writer = PillowWriter(fps=10)  # Ajustar FPS (velocidad de la animación)
ani.save("transformaciones_diabetes.gif", writer=gif_writer)

# Mostrar la animación
plt.show()