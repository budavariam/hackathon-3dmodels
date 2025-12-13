#!/bin/bash
# Export OpenSCAD common components to STL

# Set paths
SCAD_FILE="003_common_components.scad"
OUTPUT_DIR="./output"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Exporting common components library demonstrations..."
echo ""

# Export all components together
echo "1. Exporting all components overview..."
openscad -o "$OUTPUT_DIR/all_components.stl" \
         -D 'render_part="all"' \
         "$SCAD_FILE"

# Export individual demonstrations
echo "2. Exporting box demonstration..."
openscad -o "$OUTPUT_DIR/box_demo.stl" \
         -D 'render_part="box_demo"' \
         "$SCAD_FILE"

echo "3. Exporting mounting demonstration..."
openscad -o "$OUTPUT_DIR/mounting_demo.stl" \
         -D 'render_part="mounting_demo"' \
         "$SCAD_FILE"

echo "4. Exporting cable management demonstration..."
openscad -o "$OUTPUT_DIR/cable_demo.stl" \
         -D 'render_part="cable_demo"' \
         "$SCAD_FILE"

echo "5. Exporting snap-fit joint demonstration..."
openscad -o "$OUTPUT_DIR/snapfit_demo.stl" \
         -D 'render_part="snapfit_demo"' \
         "$SCAD_FILE"

echo "6. Exporting ventilation patterns demonstration..."
openscad -o "$OUTPUT_DIR/ventilation_demo.stl" \
         -D 'render_part="ventilation_demo"' \
         "$SCAD_FILE"

echo ""
echo "Export complete! Files saved to $OUTPUT_DIR/"
echo ""
echo "Generated files:"
echo "  - all_components.stl (overview of all components)"
echo "  - box_demo.stl (parametric box with rounded corners and posts)"
echo "  - mounting_demo.stl (mounting plate with PCB standoffs)"
echo "  - cable_demo.stl (cable clips, guides, and rubber feet)"
echo "  - snapfit_demo.stl (snap-fit joints and living hinge)"
echo "  - ventilation_demo.stl (square and hexagonal ventilation grids)"
echo ""
echo "Library files (import these in your projects):"
echo "  - boxes_and_plates.scad"
echo "  - mechanical_and_utility.scad"
