// make.fun sticker entry (Node 22, standard library only, no network).
// Copies the committed sticker.png (rendered from sticker.svg by render.ps1) to /output/entry.png.

import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const PNG_SIGNATURE = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];
const MAX_BYTES = 1024 * 1024;

const png = readFileSync(new URL('./sticker.png', import.meta.url));
if (!PNG_SIGNATURE.every((b, i) => png[i] === b)) throw new Error('sticker.png is not a PNG');
if (png.length > MAX_BYTES) throw new Error(`sticker.png is ${png.length} bytes, over the 1 MiB cap`);

// The grader's /output already exists; a local run may point MAKEFUN_OUTPUT_DIR at a new folder.
const outDir = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';
mkdirSync(outDir, { recursive: true });
writeFileSync(join(outDir, 'entry.png'), png);
