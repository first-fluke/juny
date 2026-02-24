import { existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, "..");
const SOURCE_DIR = join(ROOT, "src");
const MOBILE_OUTPUT_DIR = resolve(ROOT, "../../apps/mobile/lib/i18n/messages");

interface ArbFile {
  [key: string]: string | object;
}

function arbToMobileArb(arb: ArbFile, locale: string): ArbFile {
  const result: ArbFile = { "@@locale": locale };

  for (const [key, value] of Object.entries(arb)) {
    if (key === "@@locale") continue;
    result[key] = value;
  }

  return result;
}

function ensureDir(dir: string): void {
  if (!existsSync(dir)) {
    mkdirSync(dir, { recursive: true });
  }
}

function readArbFiles(): Map<string, ArbFile> {
  const files = new Map<string, ArbFile>();
  const arbFiles = readdirSync(SOURCE_DIR).filter((f) => f.endsWith(".arb"));

  for (const file of arbFiles) {
    const content = readFileSync(join(SOURCE_DIR, file), "utf-8");
    const locale = file.replace(".arb", "");
    files.set(locale, JSON.parse(content));
  }

  return files;
}

function buildMobile(arbFiles: Map<string, ArbFile>): void {
  console.log("Building mobile i18n files...");
  ensureDir(MOBILE_OUTPUT_DIR);

  for (const [locale, arb] of arbFiles) {
    const mobileArb = arbToMobileArb(arb, locale);
    const outputPath = join(MOBILE_OUTPUT_DIR, `app_${locale}.arb`);
    writeFileSync(outputPath, `${JSON.stringify(mobileArb, null, 2)}\n`);
    console.log(`  Created: ${outputPath}`);
  }
}

function main(): void {
  console.log("i18n build started (target: mobile)");

  const arbFiles = readArbFiles();
  console.log(`Found ${arbFiles.size} locale(s): ${[...arbFiles.keys()].join(", ")}`);

  buildMobile(arbFiles);

  console.log("i18n build completed!");
}

main();
