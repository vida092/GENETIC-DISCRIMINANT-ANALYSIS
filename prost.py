from sklearn.datasets import fetch_openml
import pandas as pd

# Cargar la base Colon
colon = fetch_openml(name="Colon", version=1, as_frame=True)

# Separar datos y etiquetas
X = colon.data
y = colon.target

# Mapear etiquetas a números: 'normal' → 0, 'tumor' → 1
label_map = {label: idx for idx, label in enumerate(sorted(y.unique()))}
y_encoded = y.map(label_map)

# Combinar en un solo DataFrame
df_colon = X.copy()
df_colon["label"] = y_encoded

# Guardar en archivo CSV
df_colon.to_csv("colon_encoded.csv", index=False)
print("Archivo 'colon_encoded.csv' guardado exitosamente.")
