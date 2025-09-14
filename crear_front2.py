import os

import os
import re

# Ruta del archivo maestro
input_file = r"C:\Users\LENOVO\Desktop\estructura_front2_pro_full.txt"

with open(input_file, "r", encoding="utf-8") as f:
    content = f.read()

# Usamos regex para capturar bloques con ruta
pattern = r"===== (C:[^\n]+) =====\n([\s\S]*?)(?=(?:=====|$))"
matches = re.findall(pattern, content)

count = 0
for file_path, file_content in matches:
    file_path = file_path.strip()
    folder = os.path.dirname(file_path)

    if folder and not os.path.exists(folder):
        os.makedirs(folder, exist_ok=True)

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(file_content.strip("\n"))

    print(f"✅ Archivo creado: {file_path}")
    count += 1

print(f"\n🎉 Proceso completado: {count} archivos creados.")