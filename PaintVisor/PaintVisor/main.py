import rgb as visor
import os

print("Digite el nombre de la imagen")

visor.image_name = input()

print("Digite la ruta 'path' de la imagen")

path_pc = input()

format_path = path_pc.replace('"', '')

visor.image_path = os.path.normpath(format_path)

visor.resize_function()