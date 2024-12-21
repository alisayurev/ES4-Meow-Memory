import sys
from PIL import Image

def process_image(image_path):
    img = Image.open(image_path)
    img = img.convert('RGB')
    if img.size != (160, 120): #pixel dimensions of image 
        raise ValueError("The image must be 120x160 pixels.")
    pixel_data = []
    for y in range(120):
        for x in range(160):
            r, g, b = img.getpixel((x, y))
            r_top2 = (r >> 6) & 0b11
            g_top2 = (g >> 6) & 0b11
            b_top2 = (b >> 6) & 0b11
            vector_6bit = (r_top2 << 4) | (g_top2 << 2) | b_top2
            address = (y << 8) | x
            pixel_data.append((address, vector_6bit))
    return pixel_data

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 process_image.py <image_file>")
        return
    image_path = sys.argv[1]
    pixels = process_image(image_path)
    for address, vector in pixels:
        if vector != 63: #change accordingly for transparency
            print(f'when "{address:015b}" => rgb <= "{vector:06b}";')

if __name__ == "__main__":
    main()
