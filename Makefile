.PHONY: help clean optimize-pngs render-all test-previews install-deps

# Default target
help:
	@echo "OpenSCAD 3D Models - Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  help           - Show this help message"
	@echo "  optimize-pngs  - Compress all PNG preview images for git"
	@echo "  render-all     - Generate STL files for all projects"
	@echo "  test-previews  - Generate previews for all projects"
	@echo "  clean          - Remove generated files (STL, PNG, backups)"
	@echo "  install-deps   - Install required dependencies (macOS/Linux)"
	@echo ""
	@echo "PNG Optimization Options:"
	@echo "  make optimize-pngs            - Optimize all PNGs recursively"
	@echo "  make optimize-pngs DIR=path   - Optimize PNGs in specific directory"
	@echo "  make optimize-pngs DRY=1      - Dry run (show what would be optimized)"
	@echo ""
	@echo "Examples:"
	@echo "  make optimize-pngs                    # Optimize all PNGs"
	@echo "  make optimize-pngs DIR=projects       # Optimize only projects"
	@echo "  make optimize-pngs DRY=1              # Preview optimization"

# Configuration
DIR ?= .
QUALITY ?= 65-80
DRY ?= 0

# Optimize PNG files to reduce size in git
optimize-pngs:
	@echo "Optimizing PNG files..."
	@if [ "$(DRY)" = "1" ]; then \
		bash scripts/optimize_pngs.sh -r -q $(QUALITY) -d $(DIR); \
	else \
		bash scripts/optimize_pngs.sh -r -q $(QUALITY) $(DIR); \
	fi

# Generate STL files for all projects
render-all:
	@echo "Rendering all projects..."
	@for project in projects/*/; do \
		if [ -f "$$project/export_stl.sh" ]; then \
			echo "Rendering $$project"; \
			(cd "$$project" && bash export_stl.sh); \
		fi \
	done
	@echo "All projects rendered!"

# Generate preview images for all projects
test-previews:
	@echo "Generating preview images for all projects..."
	@for project in projects/*/; do \
		scad_file=$$(find "$$project" -maxdepth 1 -name "*.scad" -type f | head -1); \
		if [ -n "$$scad_file" ]; then \
			echo "Generating previews for $$scad_file"; \
			bash scripts/generate_previews.sh -s 800x600 "$$scad_file"; \
		fi \
	done
	@echo "All previews generated!"

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	@find . -type f -name "*.stl" -delete
	@find . -type f -name "*.bak" -delete
	@find . -type d -name "output" -exec rm -rf {} + 2>/dev/null || true
	@echo "Clean complete!"

# Install dependencies
install-deps:
	@echo "Installing dependencies..."
	@if command -v brew >/dev/null 2>&1; then \
		echo "Using Homebrew (macOS)..."; \
		brew install openscad pngquant optipng; \
	elif command -v apt-get >/dev/null 2>&1; then \
		echo "Using apt (Debian/Ubuntu)..."; \
		sudo apt-get update && sudo apt-get install -y openscad pngquant optipng; \
	elif command -v yum >/dev/null 2>&1; then \
		echo "Using yum (RedHat/CentOS)..."; \
		sudo yum install -y openscad pngquant optipng; \
	else \
		echo "Error: No supported package manager found"; \
		echo "Please install manually: openscad, pngquant, optipng"; \
		exit 1; \
	fi
	@echo "Dependencies installed!"
