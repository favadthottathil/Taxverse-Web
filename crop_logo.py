from PIL import Image
import os

# Open the original PNG
src = "C:/Users/HP/Pictures/taxverse-logo.png"
dst = "C:/Users/HP/Desktop/taxverse-portfolio/assets/images/taxverse-logo.png"

img = Image.open(src).convert("RGBA")

# Get bounding box of non-white pixels
bbox = img.getbbox()
print(f"Original size: {img.size}")
print(f"Content bounding box: {bbox}")

# Add a small padding around the content (10px each side)
pad = 20
left   = max(0, bbox[0] - pad)
top    = max(0, bbox[1] - pad)
right  = min(img.width,  bbox[2] + pad)
bottom = min(img.height, bbox[3] + pad)

cropped = img.crop((left, top, right, bottom))
print(f"Cropped size: {cropped.size}")

# Save as high-quality PNG
cropped.save(dst, "PNG", optimize=True)
print(f"Saved to: {dst}")
