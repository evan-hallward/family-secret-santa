# Family Secret Santa

A small website for the Hallward family Secret Santa. Everyone opens the site, taps their own name, and sees who they're buying for.

**Budget: $125 all-in.**

## Files

| File | What it is |
| --- | --- |
| `index.html` | The page the family visits. It reads the matches from `draw.js`. |
| `setup.html` | For the organizer: draws the names and saves `draw.js` without showing any matches. |
| `draw.js` | The draw itself, created by `setup.html`. It's not here until the names are drawn. |
| `style.css`, `snow.js` | Shared look and snowfall. |
| `secret-santa.ps1` | Older PowerShell version of the draw. The website doesn't use it. |

## Doing the draw

1. Open `setup.html` (on the live site or locally) and click **Draw names & save file**.
2. Move the downloaded `draw.js` into this folder, next to `index.html`.
3. Commit and push it. GitHub Pages updates within a minute or two.

Drawing again makes a brand-new draw, so replace `draw.js` before anyone looks.

To change who's in or who can't draw whom, edit the two lists at the top of the script in `setup.html`.

> The matches in `draw.js` are only lightly scrambled, not encrypted. This runs on the honor system.
