# Prompt Engineering Learning Journey

This file documents all user prompts from the hackathon session, along with suggestions for improvement. Each entry shows the original prompt and a collapsible section with guidance on how to make it more effective.

---

> /init

---

> Please analyze this codebase and create a CLAUDE.md file, which will be given to future instances of Claude Code to operate in this repository.

<details>
<summary>💡 How to improve this prompt</summary>

Specify the focus areas for the CLAUDE.md file (e.g., commands, architecture, conventions) and mention if there are existing documentation files (README, rules) that should be incorporated. Also indicate the desired level of detail and whether to include or exclude generic development practices.

</details>

---

> please add a new folder in src starting with id 002. in this folder show me how to create reusable models. I want to add shapes that I can exclude from the shapes so that new shapes appear. e.g a wifi logo on a box to indicate wireless connection, also add shapes that embossed on the surfacetemperature sign to indicate. use parametrized functions if possible. create an export.sh file to export the result in its own output folder. use openscad format.

<details>
<summary>💡 How to improve this prompt</summary>

Use clearer terminology: "cut-out" or "engraved" instead of "exclude from shapes", and "embossed" or "raised" instead of "on the surface". Specify the desired parametrization level (size, depth, scale) and whether you want documentation comments. Also clarify if you want a demonstration model or just the reusable modules themselves.

</details>

---

> please update this component to load the shape modules from another file if it is possible, I do not see the prompt audit section in prompts/claude.md. please update CLAUDE.md in root to make sure you follow that rule so that all my prompts are saved

<details>
<summary>💡 How to improve this prompt</summary>

Break it into separate requests: 1) "Extract the icon modules into a separate library file and import them using OpenSCAD's use/include statements", 2) "Audit all prompts from this conversation and add them to prompts/claude.md following the format in CLAUDE.md". This makes each task clearer and easier to track.

</details>

---

> please add a section to the instructions to alwats run the export script after you consider the model done and check whether it builds properly

<details>
<summary>💡 How to improve this prompt</summary>

Be more specific: "Add a Build Verification section to CLAUDE.md that mandates running the export script after creating or modifying any model, checking for errors, and verifying STL file generation before considering the task complete." This makes the requirement clearer and specifies where to add it.

</details>

---

> in the next id 003 please suggest me reusable components that people generally use. like box, plane etc. in real life projects.

<details>
<summary>💡 How to improve this prompt</summary>

Be more specific about the use cases: "Create a library of commonly used 3D printing components in folder 003, including parametric boxes with rounded corners, mounting plates with customizable hole patterns, PCB standoffs, snap-fit joints, living hinges, cable management clips, ventilation grids, and wall mount brackets. Include JSDoc-style documentation for each component and demonstrate their usage in a sample file." This provides clearer guidance on what components to include and their expected features.

</details>

---

> by another model I was suggested another folder structutre. please rename src folder to playground in the references as well like cluaude.md and please adhere to the following structure now that I'm getting closer to the final result. please make sure to add a section on how to create image previews, add it to the instructions and previous playground experiments as well. make sure to export with a wireframe view if possible and mechanical blueprint version from top,left,front.

<details>
<summary>💡 How to improve this prompt</summary>

Provide the folder structure inline or as a clear specification, specify which files need updating (CLAUDE.md, README.md, etc.), and clearly state the preview generation requirements: "Create a bash script in scripts/ that generates 6 PNG views (perspective, top, front, left, wireframe, blueprint) using OpenSCAD's --imgsize, --camera, --projection, and --view options. Update CLAUDE.md to document this script with examples. Generate previews for all existing projects."

</details>

---

> please add the missing prompts to prompts/claude.md file with the required additional info

<details>
<summary>💡 How to improve this prompt</summary>

Be more specific: "Audit all user prompts from this conversation session and add them to prompts/claude.md following the established format (> for prompts, collapsible details for improvement suggestions, horizontal rules after each). Include prompts about CHEATSHEET cleanup, repository restructuring, and preview generation." This clarifies exactly which prompts should be added and in what format.

</details>

---

> please add a script to the makefile to compress all generated pngs to reduce size in git

<details>
<summary>💡 How to improve this prompt</summary>

Be more specific about the compression tools and targets: "Create a Makefile target 'optimize-pngs' that uses pngquant and optipng to compress PNG files recursively. Include options for quality settings (default 65-80), dry-run mode, and specific directory targeting. Add a helper script in scripts/ directory with proper error handling and progress reporting. Document the installation requirements for both macOS and Linux." This provides clear technical requirements and expected functionality.

</details>

---

> as a new project please design an advent calendar with doors that can be opened and closed. the door sizes shall not be the same, and shall be in random order from 1-24. the enclosing box shall be a huge rectange, i do not need you to design the insert for now. the doors shall snap into the box without an additional metal object, but make it openable.  make sure to bewel the numbers in the doors, make a thin layer under it so it is not seethrough. please make sure to create the preview as well with the wireframe without the materials. if the preview generation does not work that way please make it so. do not forget to add the prompt audit and suggestion.

<details>
<summary>💡 How to improve this prompt</summary>

Break it into clearer specifications: "Create an advent calendar project in projects/advent_calendar/ with: 1) A rectangular box (400x300x60mm) with 24 door openings arranged in a 6x5 grid, 2) Doors in 3 random sizes (small 1x1, medium 1x2/2x1, large 2x2 cells) numbered 1-24, 3) Snap-fit hinge mechanism (3mm diameter pin with 0.2mm clearance), 4) Beveled numbers (1.5mm deep) with 0.8mm backing layer to prevent see-through, 5) Export script for box and all 24 doors, 6) Generate preview images including wireframe view. Specify OpenSCAD linear_extrude for beveled text and include assembly view with doors open." This provides precise measurements, technical details, and clear deliverables.

</details>

---

> the doors are vertical the box is horizontal. please fix it. make it look like an advent calendar. I do not see the numbers on the doors

<details>
<summary>💡 How to improve this prompt</summary>

Be more specific about the expected orientation and visibility issues: "The box should be oriented vertically (tall, like a traditional wall-mounted advent calendar), not horizontally. Change box_height to be larger than box_width. The door numbers should be embossed (raised) on the surface, not recessed, so they are clearly visible. Update the coordinate system to use the Z-axis for the vertical dimension." This provides concrete technical guidance on what needs to be fixed.

</details>

---

> please instead of bewelled numbers attach it to the doors different color

<details>
<summary>💡 How to improve this prompt</summary>

Clarify the desired visual effect: "Replace the beveled number design with flat numbers that are embossed (raised) on the door surface. Use a different color for the numbers (e.g., 'Gold') to contrast with the door color (e.g., 'Chocolate'). Remove the bevel effect created by the offset() function and use simple text() with linear_extrude()." This makes it clear that you want simpler geometry with color differentiation rather than beveled depth effects.

</details>

---

> it looks ugly. please make the doors rectangular, align in a grid. just make the door numbers randomized by a seed

<details>
<summary>💡 How to improve this prompt</summary>

Be more specific about the design requirements: "Simplify the advent calendar to use a uniform 6x4 grid where all doors are the same rectangular size. Remove the variable door sizes (small/medium/large). Keep the snap-fit hinges and embossed numbers, but only randomize the number assignments (1-24) across the grid positions using the seed parameter for repeatability. Update door_configs array to a simple randomization function." This provides clear technical direction on what to keep vs. what to simplify.

</details>

---

> please keep a padding between the doors, please cut the places of the doors from the box

<details>
<summary>💡 How to improve this prompt</summary>

Specify the desired padding amount and clarify what's needed: "Increase door_clearance from 0.3mm to 2mm to create visible gaps/padding between doors. Verify that door openings are properly cut from the box using difference() operations in the calendar_box() module. The padding should be visible in the rendered output and create clear separation between adjacent doors." This makes the requirements measurable and verifiable.

</details>

---

> please make sure the box dimensions are bigger than what the doors take up with the paddings. make sure that the doors are aligned by the Y axis as if they are taken outside from it. make sure to cut the places of the doors from the box where they will fit. make sure there is a hole for the hinge as well that is on the doors

<details>
<summary>💡 How to improve this prompt</summary>

Break it into specific technical requirements: "1) Calculate required box dimensions: 6 doors × cell_width + 2×wall_thickness for width, 4 doors × cell_height + 2×wall_thickness for height. Increase box_width to 410mm and box_height to 510mm. 2) Position doors using translate([x, z+h, wall_thickness]) rotate([90, 0, 0]) so they align with openings and extend outward from the box front face. 3) Verify door openings are cut using cube([w, wall_thickness+2, h]) in difference() block. 4) Position door hinges at local z=0 (becomes top after rotation), and cut hinge slots in box at translate([x+w/2, wall_thickness/2, z+h]) with cylinder for clearance." This provides specific dimensions, positioning formulas, and technical implementation details.

</details>

---

> now the doors are properly aligned at the Y axis, but I meant to align by the Z axis. please get it fixed. make sure to keep a small distance from the box do not overlap

<details>
<summary>💡 How to improve this prompt</summary>

Clarify the coordinate system and desired orientation: "The doors should be aligned along the Z axis (vertical), not Y axis. Remove the rotate([90, 0, 0]) transformation and position doors directly with translate([x, -(door_thickness + 1), z]) where: x is the horizontal position matching the opening, z is the vertical position matching the opening, and the negative Y positions the door in front of the box with 1mm clearance. Update the door module so hinges are at local Z=height (top of door) not Z=0 (bottom)." This provides clear coordinate specifications and explains the relationship between door local coordinates and world coordinates.

</details>

---

> continue. how can I make the image generation not add the material, just the wireframe as if I presed F11 in openscad? update my script please

<details>
<summary>💡 How to improve this prompt</summary>

Be more specific about the technical requirements: "Update scripts/generate_previews.sh to generate wireframe-only images (like OpenSCAD's F11 'Thrown Together' mode). Replace the wireframe view generation to use --preview=throwntogether flag instead of --view=axes,scales,edges. This will show only edges without rendering surfaces, making it a true wireframe view." This provides the exact OpenSCAD flag needed and specifies which file and section to modify.

</details>

---

> the numbers are not visible on the doors. please add them with a different color than the doors

<details>
<summary>💡 How to improve this prompt</summary>

Specify the issue more clearly: "The door numbers (which should be in Gold color) are not visible on the rendered doors. Verify the number positioning and orientation: numbers should be positioned at the front face of each door (Y=0 in local coordinates) and extrude outward in the +Y direction using linear_extrude(height=number_depth). Remove any rotation that might be pointing the numbers the wrong way. Ensure the Gold color is applied correctly." This helps diagnose whether it's a positioning issue, orientation issue, or color issue.

</details>

---

> please make the numbers outside. now it is on the wrong side

<details>
<summary>💡 How to improve this prompt</summary>

Clarify which surface should show the numbers: "The numbers should be visible on the outside (front) surface of the doors when viewed from in front of the calendar. Currently the numbers may be on the back side or pointing inward. Position numbers at Y=0 in door local coordinates (the back face which becomes the front after door positioning) and extrude in the +Y direction (outward). Remove the rotate([90, 0, 0]) from the number rendering and use a simple translate([width/2, 0, height/2]) + linear_extrude(height=number_depth) approach." This provides the exact transformation needed.

</details>

---

> the numbers are aligned still to the y axis not Z axis

<details>
<summary>💡 How to improve this prompt</summary>

Clarify the desired text orientation: "The door numbers should be oriented vertically (text aligned with the Z axis, reading upright). Currently the text is horizontal. Apply rotate([90, 0, 0]) after positioning but before or as part of the linear_extrude operation: translate([width/2, 0, height/2]) rotate([90, 0, 0]) linear_extrude(height=number_depth) flat_number(day). This rotates the text from the XY plane to the XZ plane so it reads vertically." This specifies the exact orientation transform needed.

</details>

---

> I have a revealjs presentation in presentation/presentation.md. it was a linux course the only relevant parts are the frontmatter, the imports the first slide with the image and the last slide advent calendar. please make me a review slideshow about this hackathon today. take into account prompts/claude.md, the playground projects. make sure to create a narrative on what I learned today. please add images to make the narrative speak better. please create a file called image_prompts.txt where you list the image prompts that I shall run in an image generator service to fit the narrative for the perfect slideshow.

<details>
<summary>💡 How to improve this prompt</summary>

Break it into clear deliverables and specifications: "Create two files in presentation/: 1) hackathon_review.md - a RevealJS presentation (18-20 slides) documenting the learning journey. Structure: Title → Goals → Journey (setup, icon library, components, automation) → Advent Calendar iterations (show evolution through user feedback) → Learnings (prompt engineering, technical skills, workflow improvements) → Final results. Use the same frontmatter format as presentation.md. Reference actual preview images from projects/advent_calendar/previews/. 2) image_prompts.txt - detailed prompts for 15-20 images (one per slide) specifying style (modern technical illustration), aspect ratio (16:9), color scheme, and visual metaphors for abstract concepts (learning journey, iteration, automation). Include filename and placement guidance for each image." This provides clear structure, content requirements, and technical specifications.

</details>

---

> please add a shell script in projects/advent_calendar that calls the image generator to generate the previews at its previews folder

<details>
<summary>💡 How to improve this prompt</summary>

Clarify the script's purpose and functionality: "Create projects/advent_calendar/generate_previews.sh that wraps the global preview generation script. The script should: 1) Generate previews for all render_part variations (all, box, all_doors, and sample doors 1/7/18/24), 2) Use 1920x1080 resolution for main views, 3) Output to ./previews directory, 4) Show progress for each render_part being processed, 5) List all generated files at completion. Make the script executable (chmod +x). Update notes.md to document this convenience script as the 'quick method' for generating all previews at once." This specifies functionality, technical requirements, and documentation needs.

</details>

---

> please add https://budavariam.github.io/hackathon-3dmodels/?print-pdf-now to the readme to get the pdf of the slides

<details>
<summary>💡 How to improve this prompt</summary>

Specify where and how to add it: "Add a PDF export link to README.md in the 'View the Presentation' section (around line 207). Format: '**[📄 Download PDF](https://budavariam.github.io/hackathon-3dmodels/?print-pdf-now)** - Export slides as PDF (use browser's Print to PDF)'. Also add the link to the footer navigation (line ~280) alongside the existing 'View Presentation' and 'View Prompts' links. The ?print-pdf-now parameter triggers RevealJS's print-optimized view automatically." This provides exact location, format, and explanation of the URL parameter.

</details>

---

> please add projects/advent_calendar/previews/case_all_doors_perspective.png and projects/advent_calendar/previews/case_all_perspective.png projects/advent_calendar/previews/case_box_perspective.png images to readme

<details>
<summary>💡 How to improve this prompt</summary>

Specify layout and context: "In README.md's 'Featured Project: Advent Calendar' section (around line 128), replace the single preview image with a 3-column grid layout displaying: 1) case_all_perspective.png (Complete Calendar - all doors closed), 2) case_box_perspective.png (Box Only - showing door openings and hinge pins), 3) case_all_doors_perspective.png (All Doors - batch print layout). Use HTML div with grid styling for consistent display. Add descriptive captions under each image to explain what's shown and why it's useful (final assembly, separate printing, efficient print layout)." This provides specific layout requirements, image order, and caption guidance.

</details>

---

> the all doors print layout does not seem right. the doors in that case shall align to the Y axis so that it lies flat on the floor instead of standing up which is not ideal for printing

<details>
<summary>💡 How to improve this prompt</summary>

Be more specific about the coordinate transformation needed: "In the 'all_doors' render mode (case.scad line ~93), the doors are currently standing upright (vertical Z orientation) but should lie flat on the print bed for optimal 3D printing. Add rotate([90, 0, 0]) transformation to rotate doors around the X-axis, and adjust the Y translation to (y_pos + h) to compensate for the rotation. This makes the door's main surface parallel to the XY plane (print bed) instead of the XZ plane." This provides the exact technical fix and explains the coordinate system change.

</details>

---

> the numbers are not visible on top no on perspective view, is it possible they're upside down?

<details>
<summary>💡 How to improve this prompt</summary>

Specify the exact issue and solution: "The numbers in the 'all_doors' print layout are facing downward (into the print bed) instead of upward. Change the rotation from rotate([90, 0, 0]) to rotate([-90, 0, 0]) in case.scad line ~95. This flips the doors 180 degrees so the embossed gold numbers face upward while keeping the doors flat on the print bed. Also adjust the Y translation back to y_pos (remove the + h offset) since the rotation direction changed." This specifies both the rotation fix and the corresponding translation adjustment.

</details>

---
