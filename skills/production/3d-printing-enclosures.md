# Skill: 3D Printing Enclosures for Audio Hardware

## When to use 3D printing
- Prototypes and one-offs
- Unusual form factors that off-the-shelf enclosures don't cover
- When panel graphics will be etched/printed post-print
- Eurorack panels (aluminium is better long-term, but 3D print works for prototyping)

## Process selection

| Process | Finish | Strength | Cost | Use for |
|---|---|---|---|---|
| FDM (PLA) | Rough, layer lines | Low-moderate | Cheap | Quick functional prototypes |
| FDM (PETG) | Similar to PLA, more durable | Better | Cheap | Enclosures that get handled |
| FDM (ABS) | Rough, shrinks | Good, post-process OK | Cheap | If you need acetone smoothing |
| Resin (SLA) | Smooth, detail | Brittle | Moderate | Panel front faces, cosmetic parts |

**KLANG default:** PETG for enclosures (better temperature tolerance, more durable than PLA), PLA for quick test prints.

## Tolerances

FDM tolerances: ±0.2–0.5mm depending on printer calibration.

**Practical rules:**
- For a hole that must fit a 6mm shaft: model at 6.3mm
- For press-fit: 0.0mm clearance (may need sanding)
- For sliding fit: 0.3mm clearance
- For loose fit / easy insertion: 0.5mm clearance
- Wall thickness minimum: 1.5mm (2mm preferred for rigidity)
- Floor/ceiling thickness: 1.2mm minimum (3 × 0.4mm layers at 0.4mm layer height)

## Panel cutout reference

| Component | Hole size (modelled) | Notes |
|---|---|---|
| 3.5mm jack (Thonkiconn PJ301BM) | 6.3mm | Standard Eurorack jack |
| 6.35mm jack (1/4") | 9.8mm | Instrument/line level |
| 9mm pot shaft (D-shaft or round) | 7.3mm | Most common pot |
| 6mm pot shaft | 6.3mm | Smaller pots |
| LED 3mm | 3.2mm | Slight clearance |
| LED 5mm | 5.2mm | |
| Toggle switch (SPDT, 6mm bushing) | 6.3mm | |
| Pushbutton (12mm) | 12.5mm | Check button spec |
| M3 screw (panel mount) | 3.2mm | Use inserts for strength |
| M2.5 screw | 2.7mm | |

## Eurorack panel specs (3D printed)

- Width: n × 5.08mm per HP (e.g. 6HP = 30.48mm)
- Height: 128.5mm (3U)
- Rack hole spacing: 3mm holes, centred 3mm from top and bottom edges
- Standard panel thickness for rigidity: 2–3mm

## Export formats

- **STL**: universal, accepted everywhere — use for FDM
- **STEP**: parametric, better for referencing in KiCad 3D viewer — keep this as source
- **3MF**: includes colour/material info — useful for multi-material prints

Always export from the parametric source (Fusion 360, FreeCAD, OpenSCAD) and keep the source file. STL is the end product, not the design file.

## Gotchas
- Overhangs > 45° need supports — design to avoid or use tree supports
- Round holes print oval in FDM — compensate or drill to final size
- Threaded holes: use brass heat-set inserts (M3) pressed in with a soldering iron for durability
- PETG sticks poorly to some surfaces — use textured PEI build plate
- Eurorack panel screws: if 3D printed panel, use M3 brass inserts or the plastic will strip after a few rack swaps
