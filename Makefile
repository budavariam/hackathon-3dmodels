.PHONY: help clean optimize-pngs render-all test-previews install-deps \
        skadis-kallax \
        kallax-back-clip kallax-back-bracket \
        kallax-side-clip kallax-side-bracket \
        skadis-small-clip skadis-large-clip \
        bundle-kallax-back bundle-kallax-drawer bundle-kallax-side \
        bundle-skadis-small bundle-skadis-large bundle-all

# ── Paths ────────────────────────────────────────────────────────────────────
SCAD      = projects/skadis_kallax/skadis_panel.scad
SK_OUT    = projects/skadis_kallax/output

# ── Configuration ────────────────────────────────────────────────────────────
DIR       ?= .
QUALITY   ?= 65-80
DRY       ?= 0
PRESET    ?=
SPLIT_COLS ?= 2
SPLIT_ROWS ?= 2

# ── Help ─────────────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "OpenSCAD 3D Models"
	@echo ""
	@echo "── USE-CASE BUNDLES (start here) ────────────────────────────────────"
	@echo "  bundle-kallax-back    Fill the BACK of a Kallax slot with Skadis holes"
	@echo "                        → 4 panel segments + 4 snap-clips per corner"
	@echo "                          No drilling. Clips grip the Kallax frame edge."
	@echo ""
	@echo "  bundle-kallax-drawer  Skadis panel that lives BEHIND A DRAWER"
	@echo "                        → 4 panel segments + 2 bottom + 2 top brackets"
	@echo "                          Drill 4 holes in Kallax back wall. Panel slides"
	@echo "                          in from the top. Bottom brackets stop it;"
	@echo "                          top brackets keep it from tipping forward."
	@echo ""
	@echo "  bundle-kallax-side    Panel on the INNER SIDE WALL of a Kallax slot"
	@echo "                        → 4 panel segments + 4 snap-clips per corner"
	@echo ""
	@echo "  bundle-skadis-small   Replicate the IKEA Skadis 36×56 cm board"
	@echo "                        → 4 panel segments + 4 snap-clips"
	@echo ""
	@echo "  bundle-skadis-large   Replicate the IKEA Skadis 56×56 cm board"
	@echo "                        → 4 panel segments + 4 snap-clips"
	@echo ""
	@echo "  bundle-all            Build every bundle above"
	@echo ""
	@echo "── Low-level combo targets (choose clip vs bracket yourself) ─────────"
	@echo "  kallax-back-clip      kallax-back-bracket"
	@echo "  kallax-side-clip      kallax-side-bracket"
	@echo "  skadis-small-clip     skadis-large-clip"
	@echo ""
	@echo "── Bulk / utilities ──────────────────────────────────────────────────"
	@echo "  skadis-kallax [PRESET=kallax]   All presets + accessories"
	@echo "  render-all                      All projects in projects/"
	@echo "  test-previews                   PNG previews for all projects"
	@echo "  optimize-pngs [DIR=.] [DRY=1]  Compress PNGs for git"
	@echo "  clean                           Remove all generated STL/PNG"
	@echo "  install-deps                    Install openscad/pngquant/optipng"
	@echo ""
	@echo ""
	@echo "── Low-level / bulk builds ───────────────────────────────────────────"
	@echo "  skadis-kallax               All presets + accessories"
	@echo "  skadis-kallax PRESET=kallax Single preset only"
	@echo "  render-all                  All projects in projects/"
	@echo "  test-previews               PNG previews for all projects"
	@echo ""
	@echo "── Utilities ────────────────────────────────────────────────────────"
	@echo "  optimize-pngs [DIR=.] [DRY=1]   Compress PNG files for git"
	@echo "  clean                            Remove all generated STL/PNG"
	@echo "  install-deps                     Install openscad/pngquant/optipng"
	@echo ""

# ── Internal helpers ─────────────────────────────────────────────────────────

# Render the 2×2 panel segments for a given preset into $OUT_DIR
# $(1) = output dir   $(2) = preset name
define _render_segments
	for col in 0 1; do \
	  for row in 0 1; do \
	    openscad -o "$(1)/part_$${col}_$${row}.stl" \
	      -D "preset=\"$(2)\"" \
	      -D "render_part=\"$${col}_$${row}\"" \
	      -D "split_cols=$(SPLIT_COLS)" \
	      -D "split_rows=$(SPLIT_ROWS)" \
	      skadis_panel.scad; \
	  done; \
	done
endef

# Render the two-piece snap-clip accessories into $OUT_DIR
# $(1) = output dir
define _render_clips
	openscad -o "$(1)/clip_male.stl"   -D 'render_part="clip_male"'   skadis_panel.scad; \
	openscad -o "$(1)/clip_female.stl" -D 'render_part="clip_female"' skadis_panel.scad
endef

# Render the slide-in bracket accessories into $OUT_DIR
# $(1) = output dir
define _render_brackets
	openscad -o "$(1)/holder_bottom.stl" -D 'render_part="holder_bottom"' skadis_panel.scad; \
	openscad -o "$(1)/holder_top.stl"    -D 'render_part="holder_top"'    skadis_panel.scad
endef

# Print the clip-combo manifest
# $(1) = output dir relative to projects/skadis_kallax/
define _manifest_clip
	@echo ""
	@echo "┌─────────────────────────────────────────────────────────┐"
	@echo "│  PRINT LIST  →  $(SK_OUT)/$(1)/"
	@echo "│"
	@echo "│  Qty  File                    Notes"
	@echo "│  ───  ─────────────────────  ──────────────────────────"
	@echo "│   1×  part_0_0.stl           bottom-left segment"
	@echo "│   1×  part_0_1.stl           top-left segment"
	@echo "│   1×  part_1_0.stl           bottom-right segment"
	@echo "│   1×  part_1_1.stl           top-right segment"
	@echo "│   4×  clip_male.stl          front clip  (one per corner)"
	@echo "│   4×  clip_female.stl        back clip + Kallax hook (one per corner)"
	@echo "│"
	@echo "│  Assemble: snap segments together with tongue+groove joints."
	@echo "│  At each corner: male pins → panel holes → female barrels."
	@echo "│  Female hook slides over the Kallax shelf edge. Done."
	@echo "└─────────────────────────────────────────────────────────┘"
endef

# Print the bracket-combo manifest
# $(1) = output dir relative to projects/skadis_kallax/
define _manifest_bracket
	@echo ""
	@echo "┌─────────────────────────────────────────────────────────┐"
	@echo "│  PRINT LIST  →  $(SK_OUT)/$(1)/"
	@echo "│"
	@echo "│  Qty  File                    Notes"
	@echo "│  ───  ─────────────────────  ──────────────────────────"
	@echo "│   1×  part_0_0.stl           bottom-left segment"
	@echo "│   1×  part_0_1.stl           top-left segment"
	@echo "│   1×  part_1_0.stl           bottom-right segment"
	@echo "│   1×  part_1_1.stl           top-right segment"
	@echo "│   2×  holder_bottom.stl      screw to back wall, lower pair"
	@echo "│   2×  holder_top.stl         screw to back wall, upper pair"
	@echo "│"
	@echo "│  Assemble: screw holders to Kallax back wall first."
	@echo "│  Lower panel straight down from above into all four channels."
	@echo "│  Bottom holders stop the panel; top holders prevent tipping."
	@echo "└─────────────────────────────────────────────────────────┘"
endef

# ── Combo targets ────────────────────────────────────────────────────────────

kallax-back-clip:
	@echo "Building: Kallax back panel + snap-clips…"
	@mkdir -p $(SK_OUT)/kallax_back_clip
	@cd projects/skadis_kallax && \
	  $(call _render_segments,output/kallax_back_clip,kallax) && \
	  $(call _render_clips,output/kallax_back_clip)
	$(call _manifest_clip,kallax_back_clip)

kallax-back-bracket:
	@echo "Building: Kallax back panel + slide-in brackets…"
	@mkdir -p $(SK_OUT)/kallax_back_bracket
	@cd projects/skadis_kallax && \
	  $(call _render_segments,output/kallax_back_bracket,kallax) && \
	  $(call _render_brackets,output/kallax_back_bracket)
	$(call _manifest_bracket,kallax_back_bracket)

kallax-side-clip:
	@echo "Building: Kallax side panel + snap-clips…"
	@mkdir -p $(SK_OUT)/kallax_side_clip
	@cd projects/skadis_kallax && \
	  $(call _render_segments,output/kallax_side_clip,kallax_side) && \
	  $(call _render_clips,output/kallax_side_clip)
	$(call _manifest_clip,kallax_side_clip)

kallax-side-bracket:
	@echo "Building: Kallax side panel + slide-in brackets…"
	@mkdir -p $(SK_OUT)/kallax_side_bracket
	@cd projects/skadis_kallax && \
	  $(call _render_segments,output/kallax_side_bracket,kallax_side) && \
	  $(call _render_brackets,output/kallax_side_bracket)
	$(call _manifest_bracket,kallax_side_bracket)

skadis-small-clip:
	@echo "Building: Skadis 36×56 board + snap-clips…"
	@mkdir -p $(SK_OUT)/skadis_small_clip
	@cd projects/skadis_kallax && \
	  $(call _render_segments,output/skadis_small_clip,skadis_small) && \
	  $(call _render_clips,output/skadis_small_clip)
	$(call _manifest_clip,skadis_small_clip)

skadis-large-clip:
	@echo "Building: Skadis 56×56 board + snap-clips…"
	@mkdir -p $(SK_OUT)/skadis_large_clip
	@cd projects/skadis_kallax && \
	  $(call _render_segments,output/skadis_large_clip,skadis_large) && \
	  $(call _render_clips,output/skadis_large_clip)
	$(call _manifest_clip,skadis_large_clip)

# ── High-level use-case bundles ──────────────────────────────────────────────
# Named after the use cases from the design conversation.
# Each bundle is a complete, self-contained print set.

# "I want to fill the back of a Kallax slot with a Skadis board"
# No door, backside panel. Snap-clips grip the Kallax frame — no drilling.
bundle-kallax-back: kallax-back-clip

# "I want to put a Skadis panel behind a drawer inside a Kallax slot"
# Drill 4 holes in the Kallax back wall. Panel slides straight down from the top.
# Bottom brackets stop the panel; top brackets keep it from tipping forward.
bundle-kallax-drawer: kallax-back-bracket

# "I want a Skadis panel on the inner side wall of a Kallax slot"
# Fits the 380×325 mm inner side wall. Snap-clips, no drilling.
bundle-kallax-side: kallax-side-clip

# "I want the original Skadis small board dimensions (36×56 cm)"
bundle-skadis-small: skadis-small-clip

# "I want the original Skadis large board dimensions (56×56 cm)"
bundle-skadis-large: skadis-large-clip

# Build every bundle
bundle-all: bundle-kallax-back bundle-kallax-drawer bundle-kallax-side \
            bundle-skadis-small bundle-skadis-large
	@echo ""
	@echo "All bundles built. Find your files in:"
	@echo "  $(SK_OUT)/kallax_back_clip/    ← bundle-kallax-back"
	@echo "  $(SK_OUT)/kallax_back_bracket/ ← bundle-kallax-drawer"
	@echo "  $(SK_OUT)/kallax_side_clip/    ← bundle-kallax-side"
	@echo "  $(SK_OUT)/skadis_small_clip/   ← bundle-skadis-small"
	@echo "  $(SK_OUT)/skadis_large_clip/   ← bundle-skadis-large"

# ── Bulk build (all presets + all accessories) ───────────────────────────────
skadis-kallax:
	@echo "Building all Skadis-Kallax STLs…"
	@cd projects/skadis_kallax && \
	PRESETS=$$(if [ -n "$(PRESET)" ]; then echo "$(PRESET)"; \
	           else echo "kallax kallax_side skadis_small skadis_large"; fi); \
	mkdir -p output; \
	for P in $$PRESETS; do \
	  echo "  preset: $$P"; \
	  openscad -o "output/$${P}_full.stl" \
	    -D "preset=\"$${P}\"" -D 'render_part="full"' skadis_panel.scad; \
	  for col in $$(seq 0 $$(($(SPLIT_COLS)-1))); do \
	    for row in $$(seq 0 $$(($(SPLIT_ROWS)-1))); do \
	      openscad -o "output/$${P}_part_$${col}_$${row}.stl" \
	        -D "preset=\"$${P}\"" \
	        -D "render_part=\"$${col}_$${row}\"" \
	        -D "split_cols=$(SPLIT_COLS)" \
	        -D "split_rows=$(SPLIT_ROWS)" \
	        skadis_panel.scad; \
	    done; \
	  done; \
	done; \
	echo "  Accessories:"; \
	for A in clip_male clip_female holder_bottom holder_top; do \
	  openscad -o "output/$${A}.stl" -D "render_part=\"$${A}\"" skadis_panel.scad; \
	  echo "    output/$${A}.stl"; \
	done
	@echo "Done — output in projects/skadis_kallax/output/"

# ── Shared utilities ─────────────────────────────────────────────────────────

optimize-pngs:
	@echo "Optimizing PNG files…"
	@if [ "$(DRY)" = "1" ]; then \
	  bash scripts/optimize_pngs.sh -r -q $(QUALITY) -d $(DIR); \
	else \
	  bash scripts/optimize_pngs.sh -r -q $(QUALITY) $(DIR); \
	fi

render-all:
	@echo "Rendering all projects…"
	@for project in projects/*/; do \
	  if [ -f "$$project/export_stl.sh" ]; then \
	    echo "  $$project"; \
	    (cd "$$project" && bash export_stl.sh); \
	  fi; \
	done
	@echo "Done."

test-previews:
	@echo "Generating previews for all projects…"
	@for project in projects/*/; do \
	  scad=$$(find "$$project" -maxdepth 1 -name "*.scad" | head -1); \
	  if [ -n "$$scad" ]; then \
	    bash scripts/generate_previews.sh -s 800x600 "$$scad"; \
	  fi; \
	done
	@echo "Done."

clean:
	@echo "Cleaning generated files…"
	@find . -type f -name "*.stl" -delete
	@find . -type f -name "*.bak" -delete
	@find . -type d -name "output" -exec rm -rf {} + 2>/dev/null || true
	@echo "Done."

install-deps:
	@if command -v brew >/dev/null 2>&1; then \
	  brew install openscad pngquant optipng; \
	elif command -v apt-get >/dev/null 2>&1; then \
	  sudo apt-get update && sudo apt-get install -y openscad pngquant optipng; \
	else \
	  echo "Install openscad, pngquant, optipng manually."; exit 1; \
	fi
