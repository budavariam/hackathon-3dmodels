#!/bin/bash
# Export OpenSCAD reusable shapes to STL

# Set paths
SCAD_FILE="002_reusable_shapes.scad"
OUTPUT_DIR="./output"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Export demonstration box with all shapes
echo "Exporting demo box with embossed and cut-out shapes..."
openscad -o "$OUTPUT_DIR/demo_box.stl" \
         -D 'render_part="demo"' \
         "$SCAD_FILE"

# Export individual WiFi icon (for testing)
echo "Exporting WiFi icon..."
openscad -o "$OUTPUT_DIR/wifi_icon.stl" \
         -D 'render_part="wifi_cutout"' \
         "$SCAD_FILE"

# Export individual temperature icon (for testing)
echo "Exporting temperature icon..."
openscad -o "$OUTPUT_DIR/temperature_icon.stl" \
         -D 'render_part="temp_cutout"' \
         "$SCAD_FILE"

echo "Export complete! Files saved to $OUTPUT_DIR/"
echo ""
echo "Generated files:"
echo "  - demo_box.stl (box with embossed and cut-out icons)"
echo "  - wifi_icon.stl (standalone WiFi icon)"
echo "  - temperature_icon.stl (standalone temperature icon)"
