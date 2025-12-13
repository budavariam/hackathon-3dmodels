#!/bin/bash
# Generate PNG previews for OpenSCAD models
# Supports standard views (top, front, left), wireframe, and perspective views

set -e  # Exit on error

# Default values
SCAD_FILE=""
OUTPUT_DIR="./previews"
SIZE="1920,1080"
COLORSCHEME="Tomorrow"
CAMERA_DISTANCE=200
RENDER_PART=""

# Help message
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] <scad_file>

Generate PNG previews for OpenSCAD models with multiple viewing angles.

OPTIONS:
    -o, --output DIR        Output directory for previews (default: ./previews)
    -s, --size WIDTHxHEIGHT Image size (default: 1024x768)
    -c, --colorscheme NAME  Color scheme: Cornfield, Metallic, Sunset, Starnight,
                            BeforeDawn, Nature, DeepOcean, Solarized, Tomorrow,
                            Tomorrow Night, Monotone (default: Tomorrow)
    -d, --distance NUM      Camera distance (default: 200)
    -p, --part NAME         Render specific part (use -D render_part="NAME")
    -h, --help              Show this help message

VIEWS GENERATED:
    - perspective.png       Default perspective view
    - top.png              Top-down orthographic view
    - front.png            Front orthographic view
    -  left.png             Left side orthographic view
    - wireframe.png        Wireframe view
    - blueprint.png        Technical blueprint style

EXAMPLES:
    # Basic usage
    $(basename "$0") model.scad

    # Custom output directory
    $(basename "$0") -o ./images model.scad

    # Render specific part
    $(basename "$0") -p "lid" box_with_lid.scad

    # Custom size and colorscheme
    $(basename "$0") -s 1920x1080 -c Solarized model.scad

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -s|--size)
            SIZE="${2//x/,}"
            shift 2
            ;;
        -c|--colorscheme)
            COLORSCHEME="$2"
            shift 2
            ;;
        -d|--distance)
            CAMERA_DISTANCE="$2"
            shift 2
            ;;
        -p|--part)
            RENDER_PART="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            SCAD_FILE="$1"
            shift
            ;;
    esac
done

# Validate input
if [ -z "$SCAD_FILE" ]; then
    echo "Error: No input file specified"
    usage
    exit 1
fi

if [ ! -f "$SCAD_FILE" ]; then
    echo "Error: File not found: $SCAD_FILE"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Get base filename
BASENAME=$(basename "$SCAD_FILE" .scad)

# Build render part option
PART_OPT=""
if [ -n "$RENDER_PART" ]; then
    PART_OPT="-D render_part=\"$RENDER_PART\""
    BASENAME="${BASENAME}_${RENDER_PART}"
fi

echo "Generating previews for: $SCAD_FILE"
echo "Output directory: $OUTPUT_DIR"
echo ""

# 1. Perspective view (default auto-camera)
echo "[1/6] Generating perspective view..."
openscad -o "$OUTPUT_DIR/${BASENAME}_perspective.png" \
         --imgsize=$SIZE \
         --colorscheme=$COLORSCHEME \
         --autocenter \
         --viewall \
         $PART_OPT \
         "$SCAD_FILE" 2>/dev/null

# 2. Top view (orthographic)
echo "[2/6] Generating top view..."
openscad -o "$OUTPUT_DIR/${BASENAME}_top.png" \
         --imgsize=$SIZE \
         --colorscheme=$COLORSCHEME \
         --autocenter \
         --viewall \
         --camera=0,0,0,0,0,0,$CAMERA_DISTANCE \
         --projection=o \
         $PART_OPT \
         "$SCAD_FILE" 2>/dev/null

# 3. Front view (orthographic)
echo "[3/6] Generating front view..."
openscad -o "$OUTPUT_DIR/${BASENAME}_front.png" \
         --imgsize=$SIZE \
         --colorscheme=$COLORSCHEME \
         --autocenter \
         --viewall \
         --camera=0,0,0,90,0,0,$CAMERA_DISTANCE \
         --projection=o \
         $PART_OPT \
         "$SCAD_FILE" 2>/dev/null

# 4. Left view (orthographic)
echo "[4/6] Generating left view..."
openscad -o "$OUTPUT_DIR/${BASENAME}_left.png" \
         --imgsize=$SIZE \
         --colorscheme=$COLORSCHEME \
         --autocenter \
         --viewall \
         --camera=0,0,0,90,0,90,$CAMERA_DISTANCE \
         --projection=o \
         $PART_OPT \
         "$SCAD_FILE" 2>/dev/null

# 5. Wireframe view (edges only, no surfaces - like F11 Thrown Together mode)
echo "[5/6] Generating wireframe view..."
openscad -o "$OUTPUT_DIR/${BASENAME}_wireframe.png" \
         --imgsize=$SIZE \
         --colorscheme=Monotone \
         --autocenter \
         --viewall \
         --preview=throwntogether \
         $PART_OPT \
         "$SCAD_FILE" 2>/dev/null

# 6. Blueprint style (orthographic top with monotone)
echo "[6/6] Generating blueprint view..."
openscad -o "$OUTPUT_DIR/${BASENAME}_blueprint.png" \
         --imgsize=$SIZE \
         --colorscheme=Monotone \
         --autocenter \
         --viewall \
         --camera=0,0,0,0,0,0,$CAMERA_DISTANCE \
         --projection=o \
         --view=axes,scales,edges \
         $PART_OPT \
         "$SCAD_FILE" 2>/dev/null

echo ""
echo "✓ Preview generation complete!"
echo ""
echo "Generated files in $OUTPUT_DIR/:"
ls -lh "$OUTPUT_DIR/${BASENAME}"_*.png
