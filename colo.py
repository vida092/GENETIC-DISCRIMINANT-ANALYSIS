from sklearn.datasets import fetch_openml
import pandas as pd

# Cargar la base Colon
colon = fetch_openml(name="Colon", version=1, as_frame=True)

# Separar en features y etiquetas
X = colon.data
y = colon.target

# Ver resumen rápido
print("Shape:", X.shape)
print("Etiquetas:", y.unique())


from scipy.stats import shapiro

normality_results = {}
for col in X.columns[:10]:
    stat, p = shapiro(X[col])
    normality_results[col] = p

# Mostrar features y sus valores p
pd.Series(normality_results).sort_values()


import numpy as np

# Separar por clase
X0 = X[y == y.unique()[0]]
X1 = X[y == y.unique()[1]]

# Calcular matrices de covarianza
cov0 = np.cov(X0.T)
cov1 = np.cov(X1.T)

# Distancia entre matrices (puedes usar Frobenius o algo más específico)
frobenius_distance = np.linalg.norm(cov0 - cov1, ord='fro')
print("Frobenius norm between covariances:", frobenius_distance)


print("Número de muestras:", X.shape[0])
print("Número de variables:", X.shape[1])
print("Clases disponibles:", y.unique())
print("Muestras por clase:\n", y.value_counts())

from scipy.stats import shapiro
import pandas as pd

# Seleccionamos solo las primeras 10 columnas
subset = X.iloc[:, :10]

# Aplicamos el test de Shapiro-Wilk
normality_results = {}
for col in subset.columns:
    stat, p = shapiro(subset[col])
    normality_results[col] = p

# Convertimos a DataFrame para interpretar mejor
normality_df = pd.DataFrame.from_dict(normality_results, orient='index', columns=['p-value'])
normality_df['Normal?'] = normality_df['p-value'] > 0.05  # True si no se rechaza la normalidad
print(normality_df)
