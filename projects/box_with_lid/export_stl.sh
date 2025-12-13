#!/bin/bash
# Export OpenSCAD file to STL

# Set your paths
SCAD_FILE="1_box_with_lid.scad"
OUTPUT_DIR="./output"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Export box and lid as separate STL files
echo "Exporting box..."
openscad -o "$OUTPUT_DIR/box.stl" \
         -D 'render_part="box"' \
         "$SCAD_FILE"

echo "Exporting lid..."
openscad -o "$OUTPUT_DIR/lid.stl" \
         -D 'render_part="lid"' \
         "$SCAD_FILE"

echo "Export complete! Files saved to $OUTPUT_DIR/"