import vtracer

input_path = "C:/Users/HP/Pictures/taxverse-logo.png"
output_path = "C:/Users/HP/Desktop/taxverse-portfolio/assets/images/taxverse-logo.svg"

# Convert image to svg using default settings, optimizing for color clustering
vtracer.convert_image_to_svg_py(
    input_path,
    output_path,
    colormode='color', # 'color' for colored image
    hierarchical='stacked',
    mode='spline',
    filter_speckle=4,
    color_precision=6,
    layer_difference=16,
    corner_threshold=60,
    length_threshold=4.0,
    max_iterations=10,
    splice_threshold=45,
    path_precision=8
)

print(f"Successfully generated {output_path}")
