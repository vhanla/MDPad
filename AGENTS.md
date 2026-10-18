# AGENTS.md

Lazarus / Free Pascal markdown editor/viewer (MDPad). Cross-platform via `{$IFDEF MSWINDOWS}`. No tests, no CI, no lint.

## Build

- `lazbuild MarkDownPad.lpi` (modes `Default`/`Debug`/`Release`). Toolchain here: fpcupdeluxe install (`~/fpcupdeluxe/lazarus/lazbuild --pcp=~/fpcupdeluxe/config_lazarus`), FPC 3.3.1 trunk + Lazarus 5.99 — the old system Lazarus is gone, use this one.
- Syntax mode `Delphi` with `-dBorland -dVer150 -dDelphi7 -dCompiler6_Up -dPUREPASCAL` (in `.lpi`, don't override). Unit output `lib/$(TargetCPU)-$(TargetOS)`; `PathDelim` is `/` — keep it.
- Required packages (in `.lpi`): `LCL`, `atsynedit_package` + `atsynedit_ex_package` + `econtrol_package` (editor + EControl adapter/lexers), `FrameViewer09` (THtmlViewer), `printer4lazarus`, `MyWiki` (converters in `../components/WikiConverter/MyWiki`, registered via `--add-package-link`, NOT via `OtherUnitFiles` — base `SearchPaths` don't propagate into build modes, so raw paths silently break the build), `markdown4d_lcl` (`~/projects/Markdown4D/packages/markdown4d_lcl.lpk`, see *Third preview backend* below).
- Widgetset: default gtk2 needs system gtk2 (`sudo pacman -S gtk2`, not installed here) or linking fails on `-lgtk-x11-2.0`. **Verified path: `lazbuild --ws=qt6 MarkDownPad.lpi`** (LCL-qt6 units + `libQt6Pas.so.6` ship with this Lazarus; no qt5 bindings, so `--ws=qt5` won't link). Headless smoke test: `QT_QPA_PLATFORM=offscreen ./lib/x86_64-linux/MarkDownPad ./markdowntest.md` (clean exit, writes `settings.ini` next to the binary).
- Lowercase unit filenames are mandatory (`markdownprocessor.pas`, not `MarkdownProcessor.pas`) — FPC lowercases unit names when searching on case-sensitive filesystems. Keep the `Unit` identifiers as-is.
- `{$R *.res}` is guarded to `{$IFDEF MSWINDOWS}` in `.lpr` (Delphi-origin icon/manifest resource).
- `lib.lxl` (EControl lexers: markdown highlighting + code tree) is loaded from the **exe dir** at startup; without it the editor silently falls back to plain text. `tools/copy-lexlib.sh` copies it from `$ATSYNEDIT_DIR/app/lexlib/` (default `~/projects/components/ATSynEdit`) into every `lib/<cpu>-<os>/` output dir *and* the project root (where Release writes its binary), and is wired as the `.lpi` *Execute after* command in all three build modes (Lazarus/lazbuild run it with cwd = project dir; the script never fails the build — a missing source just prints a note). `lib.lxl` is git-ignored.

## Architecture: the preview backends

- **`SelectedPreview`** picks the *backend* (which control renders); **`SelectedEngine`** picks the markdown→HTML *engine*. They are separate axes; persisted as `preview=` / `engine=` in `settings.ini`, switched from *View → Preview: …* (`TogglePreview`) and *Engines* respectively.
  - `pvHTML` (default): `THtmlViewer` (`PreviewHtml`, created in `FormCreate`), always paired with the **native** engine (`TMarkdownProcessor`, default `SelectedEngine = mdNATIVE`). No JavaScript: `UpdateResult` renders to string and calls `LoadFromString` synchronously (no `DocumentComplete` dance).
  - `pvMARKDOWN4D`: `TMarkdownViewer` (`PreviewMd4D`, canvas renderer, parses the markdown itself — no HTML, no MyWiki). `UpdateResult` hands the source straight to it; `UsingMarkdown4D` gates every path that differs (scroll sync, zoom, print, Export HTML).
  - `pvIE`: legacy ActiveX `TWebBrowser`, **only** under `{$IFDEF MSWINDOWS}`. Picking one of the 5 JavaScript engines (PageDown, MarkdownJS, Marked, ShowDown, MarkdownIt) forces this backend regardless of `SelectedPreview` (that is what `UsingIE` checks).
- `UsingIE` / `UsingMarkdown4D` / `ActivePreview` decide the control on duty; `ApplyViewMode` hides all of them and re-applies editor/result layout after any backend switch. Add new backends to all four.
- Windows-only units (`Windows`, `ActiveXContainer`, `MSHTML_*`, `SHDocVw_*`) and APIs (`registry`, `CoInternetSetFeatureEnabled`, `SetPriorityClass`, `keybd_event`, `GetAsyncKeyState`, `ReleaseCapture/Perform`) are all behind `{$IFDEF MSWINDOWS}`. Never reference `Browser`/`BrowserContainer` outside such a guard.
- `LazActiveX` was dropped from `RequiredPackages` (doesn't compile on Linux). Windows builds need it installed in the IDE for the IE path; the IDE auto-suggests adding the dependency.
- `ExceptionLogger` was dropped (unused by our code, and its OPM copy fails to build on Linux: missing `dcconvertencoding.inc`).

### Third preview backend: Markdown4D (`pvMARKDOWN4D`)

- `~/projects/Markdown4D` is a CommonMark/GFM parser + **canvas** renderer (no browser). Its FPC/LCL port (`Source/Lcl`, targeted at FPC 3.3.1 + Lazarus trunk — the same toolchain as here) provides `TMarkdownViewer` in package `markdown4d_lcl`.
- The package depends on the **generated** tree: `build/fpc/{Core,Layout,Fpc,Lcl}` and `packages/markdown4d_lcl.lpk` are produced by `tools/fpcport/makefpc.sh` (Python transformer) and are *not* checked in. Regenerate before building MDPad on a fresh checkout, then link it **with the same widgetset**:
  - `tools/fpcport/makefpc.sh` (in `~/projects/Markdown4D`)
  - `lazbuild --pcp=~/fpcupdeluxe/config_lazarus --ws=qt6 --add-package-link ~/projects/Markdown4D/packages/markdown4d_lcl.lpk`
  - Omitting `--ws=qt6` registers the link for gtk3 and the qt6 build then says `Broken dependency`.
- Two generator bugs had to be fixed in `tools/fpcport/makelpkg.py` (both break the package silently):
  - the `.lpk` **file name must equal the package name** (`markdown4d_lcl.lpk`, not `Markdown4D.Lcl.lpk`) — `TPackageLink.IsMakingSense` in `packagelinkintf.pas` requires it, otherwise `--add-package-link` silently drops the link;
  - it must emit `<UsageOptions><UnitPath Value="$(PkgOutDir)"/></UsageOptions>`, otherwise a project that requires the package gets no unit path and fails with `Can't find unit Markdown4D`.
- Integration notes: the viewer owns an incrementally-reparsed model and marshals `SetText` to the main thread (`InvokeOnMainThread`), so there is **no worker thread** in this path. `OnLinkClick` only sees external targets (in-page anchors are resolved by the viewer). Scroll sync uses the exact `SourceLineToScrollOffset` (not the caret-line ratio), zoom maps to the viewer's real `Zoom`, and print renders the display list through `TMarkdownLclPainter` onto page bitmaps (`Printer.YDPI` is FPC's property; there is no `PixelsPerInch`). `PrintMarkdown4D` casts the painter to `IPainter`/`ITextMeasurer` explicitly — FPC won't convert the class implicitly.
- The viewer fetches remote images on `TTask`, so **`cthreads` must be first in the `.lpr` on Unix** (already the case).

## Editor

- `BCEditor1: TATSynEdit` used directly (the old `TBCEditor` subclass with Win32 `EM_*`/`user32` hacks is gone). Selection/clipboard/undo go through `DoCommand(cmd, TATCommandInvoke.MenuMain)` from `ATSynEdit_Commands` (qualify the enum; plain `MenuMain` doesn't resolve). No `OnDblClick`/`SetParent` on `TATSynEdit` — use `Parent :=`, `OnClickDouble`, `Carets[0].PosX/PosY/EndX/EndY` (0-based), `OffsetToCaretPos` (0-based offsets), `Strings.Count`.
- Editor context menu is a runtime `TPopupMenu` (`EditorPopup`, built in `FormCreate`); the editor has no default popup.
- Find dialog works on 0-based offsets (`FSelPos = -1` = find first), selection set via caret fields + `DoShowPos`.
- Scroll-sync uses caret-line ratio → `PreviewHtml.VScrollBarPosition` (or JS scroll on IE), except on the Markdown4D backend, which maps the caret line to a scroll offset exactly (`SourceLineToScrollOffset`). Status bar via `OnChangeCaretPos` → `UpdateCaretStatus`.

## Platform quirks that bite

- THtmlViewer defines `NoMetaFile` outside Windows (`htmlcons.inc`): **no `Print`/`PrintPreview` methods on Linux**. Printing uses `PrintHtmlViewer` (paginated `MakeBitmap` via `TPrinter`); `PrintPreview1` is disabled unless `UsingIE` (`ApplyViewMode`). Zoom = `DefFontSize` scaling (`PreviewBaseFontSize`), not optical zoom. Markdown4D has its own path (`PrintMarkdown4D`, same page-bitmap trick over a `TMarkdownLclPainter`, with `Painter.OriginY` naming the document Y mapped to the page top and the render viewport given in *document* coordinates — see `TMarkdownViewer.Paint`).
- Links in THtmlViewer: `OnHotSpotClick` → `OpenURL` for http(s), in-page anchors left alone. Elsewhere `OpenURL`/`OpenDocument` (LCLIntf) replace `ShellExecute`.
## Preview conversion (worker thread)

- `UpdateResult` → `PerformConversion` spawns `TConversionThread` (MyWiki `TMarkdownConverter`); UI update happens in `SyncUpdateUI`. Stale results are ignored via `FCurrentRequestID`; previous worker gets `Terminate` (checked before sync). `LastPreviewBody` (used by Export HTML) is set in `SyncUpdateUI`, not in `UpdateResult`.
- Thread lifetime rules (all learned from real GPFs): use blocking `Synchronize`, NEVER `Queue`, with `FreeOnTerminate` (queued calls can run after self-free → intermittent GPF). Track the latest worker in `FWorker` + `OnTerminate` nil-guard (`if Sender = FWorker`). `FormDestroy` sets `FShuttingDown`, then pumps `CheckSynchronize(0)` until `FActiveTaskCount` hits 0 — never plain `WaitFor` (deadlocks against a worker blocked in `Synchronize`). `SyncUpdateUI` early-exits on `FShuttingDown`.
- FPC 3.3.1 `TRegExpr` bug: backreference with counted repetition (`\2{2,}`) AVs in `RegNext` during compile. Workaround used in `MyWiki.MarkdownConverter.pas` (`RegexFencedCodeBlock`): `\2\2+`, semantically identical. Only occurrence in MyWiki; re-test with `mdtest` + `rxtest` programs if regexes change.
- `ATSynEdit` needs a local compat patch to build with system LCL-gtk2 (no `WITH_GTK2_IM`): the two `IM_Context_Set_Cursor_Pos` calls in `atsynedit_adapter_ime_gtk2.pas` are wrapped in `{$IFDEF WITH_GTK2_IM}`. Patched in BOTH checkouts (`~/projects/components/ATSynEdit` = registered one, `~/projects/components/CudaText_up` copy).
- `pagedown.inc` (`{$include}`d) holds JS engines + HTML shell as string consts. `style.css`/`Theme.json`/`markdowntest.md` load from the exe dir; `settings.ini` is runtime-generated (git-ignored, like `lib/`, `backup/`, `*.lps`, `*.ppu/*.o`).
- No test suite: verify with `lazbuild` + GUI smoke test using `markdowntest.md`.
