#!/bin/bash
# Export Advent Calendar STL files

SCAD_FILE="case.scad"
OUTPUT_DIR="./output"

mkdir -p "$OUTPUT_DIR"

echo "Exporting Advent Calendar components..."
echo ""

# Export main box
echo "[1/3] Exporting calendar box..."
openscad -o "$OUTPUT_DIR/advent_box.stl" \
         -D 'render_part="box"' \
         "$SCAD_FILE"

# Export all doors as one file (for batch printing)
echo "[2/3] Exporting all doors (batch print)..."
openscad -o "$OUTPUT_DIR/all_doors.stl" \
         -D 'render_part="all_doors"' \
         "$SCAD_FILE"

# Export individual door samples (door 1, 7, 18, 24)
echo "[3/3] Exporting sample individual doors..."
for door_num in 1 7 18 24; do
    openscad -o "$OUTPUT_DIR/door_${door_num}.stl" \
             -D "render_part=\"door_${door_num}\"" \
             "$SCAD_FILE" 2>/dev/null &
done
wait

echo ""
echo "Export complete! Files saved to $OUTPUT_DIR/"
echo ""
echo "Generated files:"
echo "  - advent_box.stl (main calendar box with 24 openings)"
echo "  - all_doors.stl (all 24 doors laid flat for printing)"
echo "  - door_N.stl (sample individual doors: 1, 7, 18, 24)"
echo ""
echo "Print recommendations:"
echo "  - Box: 0.2mm layer height, 20% infill, support on build plate only"
echo "  - Doors: 0.15mm layer height, 100% infill for strength, no supports needed"
echo "  - Hinge clearance: 0.2mm (adjust if too tight/loose)"
