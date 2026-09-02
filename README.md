# KSA Accessibility Preflight

KSA Accessibility Preflight is a free and open-source Roblox Studio plugin that reviews user interfaces for common accessibility barriers before an experience is published.

Select a `ScreenGui`, frame, or group of UI objects and run a scan. The plugin explains each finding and selects the affected object when clicked. It never edits or deletes your work.

> This is a preflight assistant, not accessibility certification. Automatic checks cannot understand every image, gradient, 3D background, interaction, or design decision.

## What It Checks

- Text/background contrast on opaque, solid-color UI
- `TextScaled` objects that do not respond to Roblox's preferred text-size setting
- Text smaller than 14 pixels that deserves testing on mobile and with low vision
- UI tween scripts that may not respect `GuiService.ReducedMotionEnabled`
- Image, gradient, translucent, and 3D backgrounds that require manual contrast review

## Why It Exists

Roblox gives players accessibility preferences for text size, reduced motion, and background transparency. Roblox also publishes accessibility guidance for creators, but Studio does not currently provide a complete automatic accessibility report for a `ScreenGui`.

KSA Accessibility Preflight turns part of that manual checklist into a fast, explainable scan. The rules are intentionally small and readable so developers can understand what the plugin can—and cannot—conclude.

## Install

1. Download `dist/KSA-Accessibility-Preflight.rbxmx`.
2. Open Roblox Studio and create or open a place.
3. Drag the `.rbxmx` file into Studio or insert it through the Asset Manager.
4. In Explorer, right-click the **KSA Accessibility Preflight** folder.
5. Choose **Save as Local Plugin**.
6. Open it from the **Plugins** toolbar under **KSA Resources**.

## Use

### Scan a specific interface

1. Select a `ScreenGui`, frame, text object, or group of UI objects in Explorer.
2. Open **KSA Accessibility Preflight**.
3. Select **Scan selection**.
4. Review the findings from highest priority to manual review.
5. Select a finding to highlight the affected object in Explorer.

### Scan all starter interfaces

Open the plugin and select **Scan StarterGui**. The plugin scans everything stored beneath `StarterGui`, including relevant UI scripts.

## Finding Levels

| Level | Meaning |
| --- | --- |
| High | The automatic measurement found a strong accessibility concern. |
| Medium | The interface conflicts with a documented Roblox behavior or misses the reference contrast target. |
| Review | Automation cannot safely decide, or the item should be tested manually. |

## Contrast Method

The plugin uses the standard sRGB relative-luminance formula and WCAG-inspired reference ratios:

- `4.5:1` for ordinary text
- `3:1` for text at `TextSize` 24 or above

These are practical reference targets, not a claim that Roblox pixels exactly equal CSS pixels or that passing the calculation guarantees accessibility.

Contrast is calculated only when the plugin finds an effectively opaque, solid-color `GuiObject` background. Images, gradients, translucent layers, text over the 3D world, and other uncertain cases are marked for manual review rather than given a misleading score.

## Privacy and Safety

- No analytics or telemetry
- No HTTP requests
- No accounts or tokens
- No uploaded UI or script source
- No automatic fixes, edits, or deletions
- All analysis happens locally inside Roblox Studio

See [SECURITY.md](SECURITY.md) for responsible reporting and the plugin's data-handling statement.

## Free Resource

KSA Accessibility Preflight is provided free of charge to the Roblox community. Official downloads and source code will never require payment. If someone attempts to sell access to an official build, please report it through the KSA community.

## Author and Community

- Created and maintained by **KSAGlory**
- Community and support: [discord.gg/ksahub](https://discord.gg/ksahub)

When asking for help, describe what you scanned, include the plugin version, and attach a screenshot of the finding when safe. Do not share private place files, account credentials, or personal information.

## Development

The repository supports [Rojo](https://rojo.space/):

```sh
rojo build -o dist/KSA-Accessibility-Preflight.rbxmx
```

Windows users can build and verify the installable model without dependencies:

```powershell
./scripts/build.ps1
./scripts/verify.ps1
```

Maintainers can use the included test interface and the steps in [TESTING.md](TESTING.md) to verify all initial rules inside Roblox Studio.

## Project Structure

```text
src/Contrast.luau       Relative luminance and contrast math
src/Auditor.luau        Read-only accessibility rules and scan report
src/Theme.luau          Shared visual tokens
src/Main.server.luau    Studio widget and Explorer interaction
scripts/build.ps1       Dependency-free .rbxmx packaging
scripts/build-test-ui.ps1 Rebuilds the Studio test interface
scripts/verify.ps1      Package and feature verification
examples/KSA-Accessibility-Test-UI.rbxmx Known pass and warning examples
tests/contrast.spec.luau Contrast-math unit tests
default.project.json    Rojo project definition
```

## Current Limitations

- Contrast over images, gradients, transparency, and the 3D world requires human review.
- The plugin does not test keyboard/controller navigation order.
- It cannot determine whether audio information has an equivalent visual cue.
- Tween detection is a source-code hint, not proof that motion is inaccessible.
- Small text is a review signal rather than a universal failure threshold.

## Contributing

Contributions should keep rules explainable, privacy-friendly, and conservative. Read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a change.

## License

[MIT](LICENSE)
