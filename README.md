# KSA Accessibility Preflight

Review Roblox interfaces for common accessibility problems before players encounter them.

KSA Accessibility Preflight is a free, open-source Roblox Studio plugin that scans selected UI or an entire `StarterGui`. It explains each finding, takes you directly to the affected object, and never edits or deletes your work.

The plugin is designed as a practical preflight check, not a replacement for testing with real players or assistive technology.

## What it checks

- Text contrast against simple, solid backgrounds
- Small text that may be difficult to read
- `TextScaled` objects that may ignore a player's preferred text size
- Tween-based motion that may need a reduced-motion alternative
- Visual situations that need human review, including images, gradients, transparency, and 3D backgrounds

## Download and installation

Download the latest `.rbxmx` file from the [Releases page](https://github.com/KSAGlory/KSA-Accessibility-Preflight/releases).

1. Open Roblox Studio and create or open a place.
2. Drag the downloaded `.rbxmx` file into Studio or insert it through Asset Manager.
3. In Explorer, right-click the **KSA Accessibility Preflight** folder.
4. Choose **Save as Local Plugin**.
5. Open it from the **Plugins** toolbar under **KSA Resources**.

## Running a scan

Open the plugin from the Studio toolbar, then choose one of two scan modes:

- **Scan selection** checks the UI objects you currently have selected.
- **Scan StarterGui** checks every supported interface under `StarterGui`.

Select a finding to jump directly to the affected object in Explorer.

## Finding levels

| Level | Meaning |
| --- | --- |
| High | A likely accessibility problem worth fixing first |
| Medium | A potential problem that should be reviewed |
| Review | The plugin cannot judge the result reliably and needs a human decision |

## Contrast checks

The scanner uses a minimum contrast ratio of `4.5:1` for ordinary text and `3:1` for text with a `TextSize` of at least 24. When the visible background cannot be determined safely, the result is marked for review instead of presenting a guess as a confirmed issue.

## Privacy and safety

KSA Accessibility Preflight runs locally inside Roblox Studio.

- No accounts or sign-in
- No telemetry or analytics
- No HTTP requests
- No project uploads
- No automatic edits or deletions

Your place and interface content stay on your computer.

## Current limitations

The plugin does not currently verify keyboard or controller navigation, screen-reader behavior, audio alternatives, flashing content, or every possible layered UI combination. Treat the report as an early warning system and include manual accessibility testing in your release process.

## Development

The repository supports Rojo and also includes dependency-free PowerShell scripts for Windows. Build and verify the installable plugin with:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build.ps1
powershell -ExecutionPolicy Bypass -File scripts/verify.ps1
```

Additional testing information is available in [TESTING.md](TESTING.md).

## Contributing

Bug reports and focused improvements are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

## Author and Community

- Author: **KSAGlory**
- Community: [discord.gg/ksahub](https://discord.gg/ksahub)

## License

This project is available under the [MIT License](LICENSE).

Copyright © 2026 KSAGlory
