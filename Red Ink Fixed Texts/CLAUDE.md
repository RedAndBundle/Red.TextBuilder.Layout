# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository context

This folder (`Red Ink Fixed Texts`) is one of two things tracked in the `Red.TextBuilder.Layout` git repo (repo root is one level up); the other is `../ForNAV Layouts`, a set of sample `.docx` report layouts unrelated to this AL code. Everything in this folder is a single Business Central AL extension ("Red Ink Fixed Texts", publisher "Red and Bundle").

The extension adds a rich-text "Fixed Text" editor field to Sales/Purchase document pages and to Customer/Contact/Item/Vendor card pages, backed by the `Red Ink Text` table and template logic from the **"Red Ink Text Templates"** app — a separate, external AL app referenced only as a dependency (id `8f9a54e2-3f61-4016-9c4d-274689d5d269` in `app.json`). That app's source is not in this repo; only its compiled symbols are available via `.alpackages`. The fixed-text logic itself (setup, find-or-create, load/save) lives in this app; Red Ink's own fixed-text members (`GetFixedTextIface`, `SaveTextIface`, the `* Fixed Text Type` / `* Flow To Transaction` fields on `Red Ink Setup`) are being obsoleted and must not be used. A copy of the Red Ink source ships inside the `.app` in `.alpackages` (it is a zip with a header) if you need to inspect it.

## Build / package

Use the `red-al-tools:red-build-al` skill to build/package this extension (bumps `app.json` version, builds via the AL Language MCP server, drops the `.app` into a local `_builds` folder). Do not build manually or invent alternative build commands.

To cut a release (docs + translations + build, in that fixed order), use `red-al-tools:red-release-al`.

There is no test suite in this repo — verification is via AL compilation (the build skill) and manual testing in a Business Central sandbox (see `.vscode/launch.json` for the configured dev server).

## Translations

Translations are XLIFF files under `Translations/` (`translation-da-DK.xlf`, `translation-de-DE.xlf`, `translation-en-US.xlf`, `translation-nl-NL.xlf`), generated from `Translations/Red Ink Fixed Texts.g.xlf`. `Scripts/Translate.ps1` round-trips these through `Scripts/Translations.xlsx` using the ForNAV cmdlet DLL (`Invoke-ExportTranslationFromXlfToExcel` / `Invoke-ImportTranslationFromExcelToXlf`) — that script requires ForNAV's Reports tooling installed locally and is not something to reproduce by hand. Prefer the `red-al-tools:red-update-docs` and `red-al-tools:red-release-al` skills over running it directly.

## Code architecture

Every object in this extension is a `pageextension` that follows one identical pattern (copy-pasted intentionally, not shared via a base object — do not "DRY" this up without checking with the user first, since AL page extensions can't easily share layout+trigger logic across unrelated base pages):

```al
pageextension <id> "PTE Ink <Name>" extends "<Base Page>"
{
    layout
    {
        addafter(General) / addlast(Content)
        {
            group(PTEInkFixedText)
            {
                field(PTEInkFixedTextEditor; PTEInkFixedText) { ... trigger OnValidate() calls PTEInkValidateFixedText(); }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        PTEInkFixedTextVisible := PTEInkFixedTextMgt.GetFixedText(Rec, PTEInkText, PTEInkFixedText, PTEInkFixedTextEditable);
    end;
    local procedure PTEInkValidateFixedText()
    begin
        if PTEInkFixedTextVisible then
            PTEInkFixedTextMgt.SaveFixedText(PTEInkText, PTEInkFixedText);
    end;
    var
        PTEInkText: Record "Red Ink Text";
        PTEInkFixedTextMgt: Codeunit "PTE Ink Fixed Text Mgt.";
        PTEInkFixedTextEditable, PTEInkFixedTextVisible : Boolean;
        PTEInkFixedText: Text;
}
```

- `PTE Ink Fixed Text Mgt.` (`General/InkFixedTextMgt.Codeunit.al`) does the real work: it resolves the text type per source table via `PTEGetFixedTextType` on the `Red Ink Setup` table extension, finds or creates the `Red Ink Text` (creation goes through Red Ink's public `Red Ink Text Interface`), and reads/writes the HTML in the `Entity Text` record (scenario `Red Ink Sales Text`). The page extensions are thin wiring only. To support a new source table, add it to `PTEGetFixedTextType`.
- Field/group names are consistently prefixed `PTEInkFixedText*`; object names/captions use the `PTE` mandatory affix required by `AppSourceCop.json`.
- Folders group page extensions by area: `General/` (Contact/Customer/Item/Vendor cards), `Sales/` and `Purchase/` (quote → order → posted invoice/credit memo document flow), `Setup/` (the `Red Ink Setup` table extension holding the `PTE * Fixed Text Type` / `PTE * Flow To Transaction` fields, plus the page extension that shows them), `Install/` (install + upgrade codeunits; `PTE Ink Fixed Text Setup Upgr.` copies the obsolete Red Ink fields into the PTE fields on the same `Red Ink Setup` record once per company, guarded by an upgrade tag).
- Object IDs are allocated from the `idRanges` block in `app.json` (84500–84550); pick the next free ID in that range for new objects rather than reusing one.

## Conventions

- New objects/fields must carry the `PTE` affix (enforced by `mandatoryAffixes` in `AppSourceCop.json`).
- Code analysis runs with CodeCop, PerTenantExtensionCop, and AppSourceCop (`.vscode/settings.json`), with several rules explicitly suppressed in `_BC.ruleset.json` — check that file before re-enabling or fighting a suppressed rule.
- This app is per-tenant, not AppSource-bound (`AS0084`/`AS0092` suppressed with that justification), so AppSource-specific requirements don't apply.
