import os

def export_frontend_files(base_path, output_file):
    # Extensiones permitidas
    valid_exts = {".html", ".css", ".js"}
    
    with open(output_file, "w", encoding="utf-8") as out:
        # Recorrer carpeta y subcarpetas
        for root, dirs, files in os.walk(base_path):
            for file in files:
                if os.path.splitext(file)[1].lower() in valid_exts:
                    full_path = os.path.join(root, file)
                    out.write(f"===== {full_path} =====\n")
                    try:
                        with open(full_path, "r", encoding="utf-8") as f:
                            out.write(f.read())
                    except Exception as e:
                        out.write(f"\n[Error al leer archivo: {e}]\n")
                    out.write("\n\n")

if __name__ == "__main__":
    # Cambia esta ruta a la carpeta base de tu proyecto frontend
    base_dir = r"C:\Users\LENOVO\Desktop\Webpage\irrigex\front2"
    output_txt = "estructura_front2_export.txt"
    export_frontend_files(base_dir, output_txt)
    print(f"Exportación completada en {output_txt}")