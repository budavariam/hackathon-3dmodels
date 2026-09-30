# Skadis-Kallax Pegboard Panel

Parametric Skadis-compatible pegboard panel, designed to fit inside an IKEA Kallax shelf slot.  
Prints on a standard 200×200 mm bed in four segments that click together — no glue, no screws needed for assembly.

---

## Contents

```
skadis_panel.scad   Main parametric model (all parts)
export_stl.sh       Bulk export script for all presets
output/             Generated STL files (git-ignored)
previews/           Preview images
```

---

## Quick start — pick your use case

Run one command from the **repo root**.  Everything needed to print is generated and grouped into its own output folder.

> **macOS note:** if `make` exits with code 69, run `sudo xcodebuild -license accept` once first.

| Your situation | Command | Output folder |
|---|---|---|
| Fill the **back** of a Kallax slot | `make bundle-kallax-back` | `output/kallax_back_clip/` |
| Panel **behind a drawer** (drill 4 holes) | `make bundle-kallax-drawer` | `output/kallax_back_bracket/` |
| Panel on the **inner side wall** | `make bundle-kallax-side` | `output/kallax_side_clip/` |
| Replicate Skadis **36×56 cm** board | `make bundle-skadis-small` | `output/skadis_small_clip/` |
| Replicate Skadis **56×56 cm** board | `make bundle-skadis-large` | `output/skadis_large_clip/` |
| **Everything** at once | `make bundle-all` | all of the above |

Each command prints a **PRINT LIST** with exact quantities and assembly notes.

---

### 1. Kallax back panel — snap-clip mount *(recommended, no drilling)*

```
make kallax-back-clip
```

Fills the back of one Kallax slot with a Skadis hole pattern.  
Two-piece printed clips grip the Kallax shelf edge — no drilling, no screws.

| Qty | File | Notes |
|-----|------|-------|
| 1× | `part_0_0.stl` | bottom-left segment |
| 1× | `part_0_1.stl` | top-left segment |
| 1× | `part_1_0.stl` | bottom-right segment |
| 1× | `part_1_1.stl` | top-right segment |
| 4× | `clip_male.stl` | front clip — pins go through panel corner holes |
| 4× | `clip_female.stl` | back clip + Kallax-edge hook |

**Assembly:**
1. Lay the four segments face-down and snap them together along the tongue-and-groove edges (they click).
2. At each outer corner: push a `clip_male` pin pair through the panel holes from the front.
3. Loop the `clip_female` hook over the Kallax shelf edge, then press its barrels onto the male pins until they click.
4. Repeat for all four corners.

---

### 2. Kallax back panel — slide-in bracket mount *(for use behind drawers)*

```
make kallax-back-bracket
```

Same panel, but attached via four brackets screwed to the Kallax back wall.  
The panel slides straight down from above — no tilting required.  
**Bottom holders have a floor** (panel rests here); **top holders are open** (panel slides through freely).

| Qty | File | Notes |
|-----|------|-------|
| 1× | `part_0_0.stl` | bottom-left segment |
| 1× | `part_0_1.stl` | top-left segment |
| 1× | `part_1_0.stl` | bottom-right segment |
| 1× | `part_1_1.stl` | top-right segment |
| 2× | `holder_bottom.stl` | screw to back wall at the lower position |
| 2× | `holder_top.stl` | screw to back wall at the upper position |

**Assembly:**
1. Screw `holder_bottom` (×2) and `holder_top` (×2) to the Kallax back wall (4 × M4 or wood screws).  
   Space each pair left/right to match the outer corners of the panel.
2. Print orientation: rotate each holder −90° around X in your slicer so the channel opens face-up (no supports needed).
3. Lower the assembled panel straight down into all four channels.
4. Panel bottom edge lands on the `holder_bottom` floors; top holders prevent forward tipping.

---

### 3. Kallax side panel — snap-clip mount

```
make kallax-side-clip
```

380×325 mm panel for the inner side wall of a Kallax slot.  
Same clip system as above.

---

### 4. Kallax side panel — bracket mount

```
make kallax-side-bracket
```

---

### 5. Skadis small board (360×560 mm)

```
make skadis-small-clip
```

Replicates the original IKEA Skadis 36×56 cm board, split into four printable segments.

---

### 6. Skadis large board (560×560 mm)

```
make skadis-large-clip
```

---

## Key parameters (edit at the top of `skadis_panel.scad`)

| Parameter | Default | Description |
|-----------|---------|-------------|
| `preset` | `"kallax"` | Size preset (see below) |
| `mount_style` | `"clip"` | `"clip"` or `"bracket"` |
| `render_part` | `"full"` | What to render (see below) |
| `panel_thickness` | `5` | Panel body thickness (mm) |
| `margin_top/bottom/left/right` | `10` | Solid border — no holes in this zone |
| `hole_offset_x` / `hole_offset_y` | `0` | Shift entire hole grid (alignment tweak) |
| `hole_spacing_x` / `hole_spacing_y` | `40` / `20` | Skadis grid spacing |
| `split_cols` / `split_rows` | `2` / `2` | Print grid (2×2 = four segments) |
| `tongue_gap` | `0.25` | Snap joint clearance — increase if tight |
| `bead_gap` | `0.35` | Snap bead interference — increase for tighter click |

### Presets

| `preset` | Width × Height | Use |
|----------|----------------|-----|
| `"kallax"` | 330 × 330 mm | Back panel, one Kallax slot |
| `"kallax_side"` | 380 × 325 mm | Inner side wall of one Kallax slot |
| `"skadis_small"` | 360 × 560 mm | IKEA Skadis small board |
| `"skadis_large"` | 560 × 560 mm | IKEA Skadis large board |
| `"custom"` | `custom_width` × `custom_height` | Any size |

### `render_part` values

| Value | Output |
|-------|--------|
| `"full"` | Whole assembled panel (preview — not for printing) |
| `"0_0"`, `"0_1"`, `"1_0"`, `"1_1"` | Individual 2×2 print segments |
| `"clip_male"` | Front clip with pins |
| `"clip_female"` | Back clip with barrel holes + Kallax-edge hook |
| `"holder_bottom"` | Slide-in bracket with floor stop |
| `"holder_top"` | Slide-in bracket without floor (open channel) |

---

## Snap joint design

Adjacent segments connect with **tongue-and-groove + snap ledge** joints:

- Right and top edges of each segment carry a raised tongue rail with a locking ledge.
- Left and bottom edges have a matching groove with a recess.
- Press segments together — the ledge clicks into the recess and holds without glue or fasteners.
- Adjust `tongue_gap` (clearance) and `bead_gap` (snap interference) for your printer.

---

## Clip design (mount_style = "clip")

Based on the two-piece commercial Kallax clip design:

- **`clip_male`** — flat oblong body with two 4.8 mm cylindrical pins.  
  Pins insert through the panel's 5 mm corner holes from the front face.

- **`clip_female`** — matching body with two barrel holes + a J-shaped hook.  
  Hook slides over a Kallax shelf/wall edge (~16.5 mm thick).  
  Barrel holes press onto the male pins and lock.

Both pieces print flat (no supports).  The barrel-hole side locks with ~0.35 mm interference.

---

## Slide-in bracket design (mount_style = "bracket")

- **`holder_bottom`** — U-channel with a floor.  Panel bottom edge rests on the floor.
- **`holder_top`** — Open channel (no floor).  Panel slides through freely; bottom holders stop it.

Print with the channel opening facing up on the bed (rotate −90° around X in slicer).  
Screw through the base plate into the Kallax back wall with M4 bolts or 4 mm wood screws.

---

## Print settings (recommended)

| Setting | Value |
|---------|-------|
| Layer height | 0.2 mm |
| Infill | 15–20 % |
| Perimeters / walls | 3 |
| Material | PLA or PETG |
| Min. bed size | 200 × 200 mm |
| Supports | Not needed for any part |

---

## Makefile reference

From the repo root:

```bash
# Complete print-ready combos
make kallax-back-clip        # Kallax back panel + clips
make kallax-back-bracket     # Kallax back panel + slide-in brackets
make kallax-side-clip        # Kallax side panel + clips
make kallax-side-bracket     # Kallax side panel + brackets
make skadis-small-clip       # Skadis 36×56 cm board + clips
make skadis-large-clip       # Skadis 56×56 cm board + clips

# Bulk build (all presets × all parts)
make skadis-kallax
make skadis-kallax PRESET=kallax   # single preset
make skadis-kallax SPLIT_COLS=3 SPLIT_ROWS=3   # 3×3 grid

# Single part (manual openscad)
openscad -o part.stl -D 'preset="kallax"' -D 'render_part="0_0"' \
  projects/skadis_kallax/skadis_panel.scad
```
