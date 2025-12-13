#!/bin/bash
# Optimize PNG files using pngquant and optipng
# Reduces file size while maintaining visual quality

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default values
TARGET_DIR="."
RECURSIVE=false
QUALITY="65-80"
SPEED=3
DRY_RUN=false

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [DIRECTORY]

Optimize PNG files to reduce size for git repositories.
Uses pngquant for lossy compression and optipng for additional optimization.

OPTIONS:
    -r, --recursive         Search for PNGs recursively (default: false)
    -q, --quality RANGE     Quality range for pngquant (default: 65-80)
                            Format: MIN-MAX where 0-100
    -s, --speed LEVEL       Speed level 1-11 (default: 3)
                            1=slowest/best, 11=fastest/worst
    -d, --dry-run           Show what would be optimized without doing it
    -h, --help              Show this help message

DIRECTORY:
    Directory to search for PNG files (default: current directory)

EXAMPLES:
    # Optimize all PNGs in current directory
    $(basename "$0")

    # Optimize recursively with custom quality
    $(basename "$0") -r -q 70-85 ./projects

    # Dry run to see what would be optimized
    $(basename "$0") -r -d ./

NOTES:
    - Requires pngquant and optipng to be installed
    - macOS: brew install pngquant optipng
    - Linux: apt-get install pngquant optipng
    - Creates backup files with .bak extension (can be removed after verification)

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--recursive)
            RECURSIVE=true
            shift
            ;;
        -q|--quality)
            QUALITY="$2"
            shift 2
            ;;
        -s|--speed)
            SPEED="$2"
            shift 2
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
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
            TARGET_DIR="$1"
            shift
            ;;
    esac
done

# Check for required tools
check_dependencies() {
    local missing=()

    if ! command -v pngquant &> /dev/null; then
        missing+=("pngquant")
    fi

    if ! command -v optipng &> /dev/null; then
        missing+=("optipng")
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${RED}Error: Missing required tools: ${missing[*]}${NC}"
        echo ""
        echo "Install them with:"
        echo "  macOS:  brew install ${missing[*]}"
        echo "  Linux:  apt-get install ${missing[*]}"
        exit 1
    fi
}

# Get file size in human readable format
get_size() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        stat -f%z "$1" 2>/dev/null || echo "0"
    else
        stat -c%s "$1" 2>/dev/null || echo "0"
    fi
}

# Format bytes to human readable
format_size() {
    local bytes=$1
    if [ "$bytes" -lt 1024 ]; then
        echo "${bytes}B"
    elif [ "$bytes" -lt 1048576 ]; then
        echo "$((bytes / 1024))KB"
    else
        echo "$((bytes / 1048576))MB"
    fi
}

# Optimize a single PNG file
optimize_png() {
    local file="$1"
    local original_size=$(get_size "$file")

    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY RUN]${NC} Would optimize: $file ($(format_size $original_size))"
        return 0
    fi

    echo -ne "Optimizing: $file ... "

    # Backup original
    cp "$file" "$file.bak"

    # Run pngquant
    if pngquant --quality="$QUALITY" --speed "$SPEED" --force --output "$file" "$file.bak" 2>/dev/null; then
        # Run optipng for additional optimization
        optipng -quiet -o2 "$file" 2>/dev/null || true

        local new_size=$(get_size "$file")
        local saved=$((original_size - new_size))
        local percent=$((saved * 100 / original_size))

        if [ "$saved" -gt 0 ]; then
            echo -e "${GREEN}✓${NC} $(format_size $original_size) → $(format_size $new_size) (saved ${percent}%)"
            rm "$file.bak"
        else
            echo -e "${YELLOW}↔${NC} No improvement, keeping original"
            mv "$file.bak" "$file"
        fi
    else
        echo -e "${RED}✗${NC} Failed, keeping original"
        mv "$file.bak" "$file" 2>/dev/null || true
    fi
}

# Find and optimize PNGs
optimize_directory() {
    local total_original=0
    local total_optimized=0
    local count=0

    echo -e "${GREEN}PNG Optimization${NC}"
    echo "Directory: $TARGET_DIR"
    echo "Recursive: $RECURSIVE"
    echo "Quality: $QUALITY"
    echo "Speed: $SPEED"
    [ "$DRY_RUN" = true ] && echo -e "${YELLOW}DRY RUN MODE${NC}"
    echo ""

    # Find PNG files
    local find_opts="-maxdepth 1"
    [ "$RECURSIVE" = true ] && find_opts=""

    while IFS= read -r -d '' file; do
        local size=$(get_size "$file")
        total_original=$((total_original + size))

        optimize_png "$file"

        local new_size=$(get_size "$file")
        total_optimized=$((total_optimized + new_size))
        count=$((count + 1))
    done < <(find "$TARGET_DIR" $find_opts -type f -name "*.png" -print0 2>/dev/null)

    # Summary
    echo ""
    echo "================================"
    if [ "$count" -gt 0 ]; then
        local total_saved=$((total_original - total_optimized))
        local total_percent=0
        [ "$total_original" -gt 0 ] && total_percent=$((total_saved * 100 / total_original))

        echo "Files processed: $count"
        echo "Original size: $(format_size $total_original)"
        echo "Optimized size: $(format_size $total_optimized)"
        echo -e "Total saved: ${GREEN}$(format_size $total_saved) (${total_percent}%)${NC}"
    else
        echo "No PNG files found"
    fi
}

# Main execution
check_dependencies
optimize_directory
