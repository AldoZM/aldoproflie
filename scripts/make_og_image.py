"""Genera web/og-image.png: la vista previa al compartir el enlace."""
from PIL import Image, ImageDraw, ImageFont

W, H = 1200, 630
BG      = (1, 4, 9)        # #010409
PRIMARY = (230, 237, 243)  # #e6edf3
BLUE    = (88, 166, 255)   # #58a6ff
GREEN   = (63, 185, 80)    # #3fb950
GRAY    = (139, 148, 158)  # #8b949e

MONO = r"C:\Windows\Fonts\consola.ttf"
MONO_BOLD = r"C:\Windows\Fonts\consolab.ttf"

img = Image.new("RGB", (W, H), BG)
d = ImageDraw.Draw(img)

f_prompt = ImageFont.truetype(MONO, 26)
f_name   = ImageFont.truetype(MONO_BOLD, 66)
f_title  = ImageFont.truetype(MONO, 30)
f_foot   = ImageFont.truetype(MONO, 22)

x = 90
d.text((x, 150), "$ whoami", font=f_prompt, fill=GREEN)
d.text((x, 205), "Aldo Zetina Muciño", font=f_name, fill=PRIMARY)
d.text((x, 305), "Software Engineer · Backend & APIs · Mobile", font=f_title, fill=BLUE)
d.text((x, 380), "Java · Spring · Node.js · Flutter · C++ · Python",
       font=f_foot, fill=GRAY)
d.text((x, 470), "aldozm.github.io/aldoproflie", font=f_foot, fill=GRAY)

# Franja inferior: el mismo gradiente azul→verde de la barra de progreso.
for i in range(W):
    t = i / W
    d.line([(i, H - 6), (i, H)], fill=(
        int(BLUE[0] + (GREEN[0] - BLUE[0]) * t),
        int(BLUE[1] + (GREEN[1] - BLUE[1]) * t),
        int(BLUE[2] + (GREEN[2] - BLUE[2]) * t),
    ))

img.save("web/og-image.png")
print("web/og-image.png escrito:", img.size)
