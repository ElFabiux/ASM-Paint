from PIL import Image
import numpy as np
import cv2

# Diccionario de colores a letras
color_to_letters = {
    (0, 0, 0): '0',          # Negro
    (0, 0, 255): '1',        # Azul
    (0, 128, 0): '2',        # Verde
    (0, 255, 255): '3',      # Cian
    (255, 0, 0): '4',        # Rojo
    (128, 0, 128): '5',      # Púrpura
    (165, 42, 42): '6',      # Marrón
    (245, 245, 245): '7',    # Blanco opaco
    (128, 128, 128): '8',    # Gris
    (173, 216, 230): '9',    # Azul Claro
    (144, 238, 144): 'A',    # Verde Claro
    (135, 206, 250): 'B',    # Celeste Claro
    (255, 105, 97): 'C',     # Rojo Claro
    (255, 192, 203): 'D',    # Rosado
    (255, 255, 0): 'E',      # Amarillo
    (255, 255, 255): 'F'     # Blanco
}

# Función para calcular la distancia entre dos colores
#  raizCuadrada (R1 - R2)^2 + (G1 - G2)^2 + (B1 - B2)^2
def color_distance(c1, c2):    
    return np.sqrt(np.sum((np.array(c1) - np.array(c2)) ** 2))

# Función para encontrar el color más cercano
# color_to_letters.keys() claves rgb del diccionario
# min(xxxxxxxx)  selecciona el color con la distancia euclidiana más mínima
def find_closest_color(color):
    closest_color = min(color_to_letters.keys(), key=lambda c: color_distance(c, color))
    return color_to_letters[closest_color]

def resize_function():

    #global resize_image

    img = cv2.imread(image_path)

    if img is not None:
        
        resize_image = cv2.resize(img, (400, 235) )
        print("La imagen ha sido redimensionada correctamente.")                       

        # convertir la imagen de OpenCV a formato Pillow para que la lea como objeto RGB no BGR
        image_rgb = cv2.cvtColor(resize_image, cv2.COLOR_BGR2RGB)
        image_pillow = Image.fromarray(image_rgb)

        #cv2.imshow('imageResized', resize_image)
        #cv2.waitKey(0)
        #cv2.destroyAllWindows()

        process_image(image_pillow)        

    else:
        print("Error: No se pudo cargar la imagen.")

# Función principal
def process_image(image_pillow):

    image = image_pillow    
    width, height = image.size    
    
    if image is not None:

        with open(f"C:/CURSOS_II_CICLO_2024/Arquitectura_Computadores/Proyecto_II/ASM-Paint/{image_name}.txt", "a") as txt:

            for y in range(height):            
                line = []
                for x in range(width):                    
                                        
                    line.append( find_closest_color( image.getpixel((x, y))) )

                line.append("@\n")
                txt.write(''.join(line) )
                
            txt.write("%")
    else:
        print("/process_image: Problema al abrir la imagen")

image_name = None
image_path = None