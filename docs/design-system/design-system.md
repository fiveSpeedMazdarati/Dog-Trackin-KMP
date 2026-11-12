# Dog Trackin' Design System

> **Status:** v0.1. The tokens live in [`tokens.json`](tokens.json), which is the source of truth for every platform.
> The Compose implementation is in
> `composeApp/src/commonMain/kotlin/com/softwareofnote/dogtrackin/designsystem/`. A SwiftUI implementation
> will follow once the UI-stack decision is made (see the implementation plan, ADR-1).

## Principles

1. **Glanceable first.** The most important fact on any screen is "how long since…". Large numbers, short labels.
2. **Four colours, and colour is never the only cue.** Black, white, light purple, light blue. Every state also has a glyph and a word.
3. **System everything.** System fonts, system glyphs (SF Symbols on Apple platforms), system controls, Dynamic Type.
4. **Glyphs, not graphics.** No illustrations or bitmaps. A dog is a `pawprint`, not a picture.
5. **Calm by default.** No red alarm colours. Urgency comes from the inverted black banner and the wording, not from saturation.

## 1. Colour

### 1.1 Palette (primitives)

| Token | Hex | Role |
|---|---|---|
| `ink` | `#000000` | Text, glyphs, dark-mode background, critical banners |
| `paper` | `#FFFFFF` | Light-mode background, text on ink |
| `lavender` | `#D8CCFF` | **Light purple.** Primary actions, *people* (caretakers, "you"), selected state |
| `lavenderSoft` | `#EFEAFF` | Tinted surfaces, inbox unread rows |
| `sky` | `#C6E4FF` | **Light blue.** *Activity and information*: event chips, info banners, sync, location |
| `skySoft` | `#EAF5FF` | Tinted surfaces, timeline day headers |
| `gray900` | `#1A1A1A` | Dark-mode elevated surface |
| `gray600` | `#5C5C5C` | Secondary text on paper |
| `gray400` | `#A3A3A3` | Secondary text on ink / gray900 |
| `gray300` | `#C7C7C7` | Hairlines and dividers on paper |
| `gray800` | `#2A2A2A` | Hairlines and dividers on ink |

The grays are mixtures of black and white, so the brand still reads as four colours. ⚠ Confirm this with
the product owner, along with whether a darker purple or blue is wanted for text (see open questions).

### 1.2 The one rule
**Light purple and light blue are surfaces, never text.** On white they reach only 1.3–1.5:1 contrast, which
fails WCAG. Text and glyphs on purple or blue surfaces are always `ink`, at 14:1 or better. This rule holds in
**both** light and dark mode, so a purple button looks the same everywhere, and in dark mode the pastels stand out against the black.

### 1.3 Semantic tokens

| Semantic token | Light | Dark |
|---|---|---|
| `background` | paper | ink |
| `surface` (cards) | paper + `gray300` hairline | gray900 |
| `onBackground` / `onSurface` | ink | paper |
| `textSecondary` | gray600 | gray400 |
| `divider` | gray300 | gray800 |
| `accentPrimary` (buttons, selection) | lavender | lavender |
| `onAccentPrimary` | ink | ink |
| `accentPrimarySoft` | lavenderSoft | lavender @ 16% over ink |
| `accentInfo` (event chips, info) | sky | sky |
| `onAccentInfo` | ink | ink |
| `accentInfoSoft` | skySoft | sky @ 16% over ink |
| `bannerCritical` bg / fg | ink / paper | paper / ink (inverts against the page) |
| `focusRing` | ink 2pt | paper 2pt |

### 1.4 Measured contrast (WCAG 2.x)

These are computed in a unit test (`DesignTokensContrastTest`), so a palette change that breaks them fails the build.

| Pair | Ratio | AA normal text (4.5) |
|---|---|---|
| ink on paper | 21.0 | ✓ |
| ink on lavender | 14.0 | ✓ |
| ink on sky | 15.9 | ✓ |
| ink on lavenderSoft | 17.9 | ✓ |
| ink on skySoft | 19.0 | ✓ |
| gray600 on paper | 6.7 | ✓ |
| gray400 on ink | 8.3 | ✓ |
| lavender on gray900 (chip on dark card edge) | 11.6 | ✓ |
| ~~lavender text on paper~~ | 1.5 | ✗, which is why the rule above exists |

### 1.5 Status without colour

| State | Glyph (SF Symbol, proposed) | Surface | Word |
|---|---|---|---|
| Info announcement | `info.circle.fill` | sky | "Info" |
| Warning announcement | `exclamationmark.triangle.fill` | lavender | "Heads up" |
| Critical / outage | `exclamationmark.octagon.fill` | **inverted** (ink bg, paper text) | "Service issue" |
| Offline | `wifi.slash` | inverted | "Offline — 3 changes waiting" |
| Pending sync (per row) | `arrow.triangle.2.circlepath` | none (glyph only) | VoiceOver: "Not yet synced" |
| Synced | — (no indicator; silence is success) | | |

## 2. Typography

**System fonts only.** On Apple platforms that means SF Pro / SF Pro Rounded (⚠ OPEN: rounded for numerals?) through the
built-in **text styles**, so Dynamic Type works automatically. On Android, Roboto via the default family.

| Token | Apple text style | Default size / line height (pt) | Weight | Used for |
|---|---|---|---|---|
| `display` | `.largeTitle` | 34 / 41 | Bold | Screen titles, TV "time since" numbers (scaled up on tvOS) |
| `title1` | `.title` | 28 / 34 | Bold | Animal name on detail screen |
| `title2` | `.title2` | 22 / 28 | Semibold | Section headers |
| `title3` | `.title3` | 20 / 25 | Semibold | Card titles |
| `headline` | `.headline` | 17 / 22 | Semibold | Row titles, buttons |
| `body` | `.body` | 17 / 22 | Regular | Default text |
| `callout` | `.callout` | 16 / 21 | Regular | Banner body |
| `subheadline` | `.subheadline` | 15 / 20 | Regular | Row secondary text ("by Sam · Home") |
| `footnote` | `.footnote` | 13 / 18 | Regular | Timestamps |
| `caption` | `.caption` | 12 / 16 | Medium | Chip labels, badges |

Numbers that change, such as "2 h 14 m ago", use **monospaced digits** (`.monospacedDigit()`) so they don't jitter as they update.

## 3. Glyphs

A glyph always has an accessibility label. On Apple platforms these are SF Symbols; on Android, Material Symbols.
**⚠ Every symbol name below needs to be checked in Apple's SF Symbols app against the minimum OS version we pick.**
The names are proposals; availability by OS version can't be confirmed from this environment.

| Concept | SF Symbol (proposed) | Material Symbol (proposed) | Notes |
|---|---|---|---|
| App / animal | `pawprint.fill` | `pets` | |
| Pee | `drop.fill` | `water_drop` | |
| Poop | `leaf.fill` ⚠ | `compost` ⚠ | As far as I know SF Symbols has no dedicated poop glyph. This is a stand-in; decision needed. |
| Meal | `fork.knife` | `restaurant` | |
| Water | `cup.and.saucer.fill` ⚠ | `local_drink` | Could clash visually with "pee". Review needed. |
| Medication | `pills.fill` | `medication` | |
| Walk | `figure.walk` | `directions_walk` | |
| Outside (yard) | `door.left.hand.open` ⚠ | `door_open` | |
| Treat | `gift.fill` ⚠ | `cookie` | |
| Grooming | `scissors` | `content_cut` | |
| Vet | `cross.case.fill` | `medical_services` | |
| Note | `note.text` | `sticky_note_2` | |
| Named place | `mappin.and.ellipse` | `location_on` | |
| Dropped pin | `mappin` | `pin_drop` | |
| Home place | `house.fill` | `home` | |
| Caretaker(s) | `person.2.fill` | `group` | |
| Temporary access | `clock.badge` ⚠ | `schedule` | |
| Inbox / notifications | `bell.fill` | `notifications` | |
| Archive | `archivebox.fill` | `archive` | |
| Delete | `trash` | `delete` | |
| Offline | `wifi.slash` | `wifi_off` | |
| Sync pending | `arrow.triangle.2.circlepath` | `sync` | |

## 4. Spacing, shape and elevation

- **Spacing scale (4-pt grid):** `xxs 2 · xs 4 · s 8 · m 12 · l 16 · xl 24 · xxl 32 · xxxl 48`.
- **Screen margins:** 16 (iPhone), 20 (iPad regular width), 80 to 90 on the sides for tvOS safe area. ⚠ Confirm against Apple's HIG for tvOS.
- **Corner radius:** `small 8` (chips, badges), `medium 12` (buttons, fields), `large 20` (cards, sheets). Use **continuous** corners on iOS.
- **Elevation:** none. Hierarchy comes from a hairline border in light mode or a `gray900` surface in dark mode, not from shadows.
- **Minimum touch target:** 44 × 44 pt.

## 5. Components (v1 inventory)

| Component | Anatomy | Notes |
|---|---|---|
| **QuickLogButton** | glyph (title3) + label (caption) on `sky` tile, radius medium | 1 tap logs. Long-press opens the editor. Haptic on success. |
| **SinceTile** | glyph + "2 h 14 m" (display, mono digits) + "Meal · by Sam" | Used on the animal header, iPad counter mode and TV |
| **EventRow** | glyph in `sky` circle · title (headline) · "by Sam · Home" (subheadline) · time (footnote) · pending glyph | Swipe to edit or delete, own events only |
| **AnimalCard** | `pawprint` in `lavender` circle · name · 3 SinceTiles mini | Main list |
| **CaretakerChip** | initials in `lavender` circle + name; temporary shows `clock` + "until Fri" | |
| **Banner** | glyph · title (headline) · body (callout) · optional action · optional dismiss ✕ | Variants from §1.5. Sits under the nav bar and pushes content down (doesn't overlay it). |
| **PrimaryButton** | `lavender` fill, ink label (headline), radius medium, height 50 | |
| **SecondaryButton** | ink 1.5-pt outline, transparent fill | |
| **DestructiveButton** | ink fill, paper label, `trash` glyph, and **a confirmation step** | No red. The confirmation and the wording carry the weight. |
| **PlacePicker** | segmented control: Saved place / Drop pin / None; map sheet for pin | |
| **DuplicateWarningSheet** | `exclamationmark.triangle.fill` · "Already logged 12 min ago by Sam" · [Log anyway] [Cancel] | |
| **InboxRow** | unread = `lavenderSoft` background + dot | |

## 6. Motion and haptics
- Respect Reduce Motion. Default transitions are system-standard.
- Success haptic on a quick log. Warning haptic when the duplicate guard appears.

## 7. Accessibility checklist
- [ ] Every glyph has a label ("Pee", not "drop.fill").
- [ ] Layouts reflow at AX5. SinceTiles stack vertically.
- [ ] Contrast pairs are covered by the unit test.
- [ ] No state is conveyed by colour alone (§1.5).
- [ ] Focus states visible on iPad (keyboard) and tvOS (focus engine).

## 8. App icon
A glyph-based mark: `pawprint` in ink on a `lavender` field, with the rear pads offset slightly to the right of the
front pads, a visual nod to the "dog-tracking" gait. Built from vector glyph geometry, not an illustration. ⚠ Needs design approval.
