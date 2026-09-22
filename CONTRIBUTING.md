# Contributing to KSA Accessibility Preflight

Contributions should make the plugin easier to use, improve its checks, or clarify its limitations.

## Before proposing a change

Open a [GitHub issue](https://github.com/KSAGlory/KSA-Accessibility-Preflight/issues) before making a large change. Small bug fixes and documentation corrections can be submitted directly.

Accessibility checks must be conservative. A warning should explain what was observed without claiming that a person, interface, or experience has failed a formal certification.

## Rule requirements

Every new automatic check should provide:

- A clear title written for Roblox creators
- A factual explanation of the observed behavior
- A practical suggestion that does not modify user work automatically
- Known limitations and situations that require manual review
- A reliable way to identify the affected Studio instance

Avoid checks based only on personal design preferences. Prefer documented Roblox behavior or established accessibility guidance.

## Development checks

Run the package verification script before submitting a change:

```powershell
./scripts/verify.ps1
```

If the Luau command-line tools are installed, check the source syntax and run the contrast tests from the repository root:

```powershell
Get-ChildItem src -Filter *.luau | ForEach-Object {
    luau-compile $_.FullName
    if ($LASTEXITCODE -ne 0) {
        throw "Compilation failed: $($_.Name)"
    }
}
luau tests/contrast.spec.luau
```

Package verification and contrast tests do not run the Studio interface. Follow [TESTING.md](TESTING.md) to check the installed plugin.

## Code style

- Use strict Luau for source modules.
- Choose descriptive names over abbreviations.
- Add comments only when they clarify intent or a non-obvious limitation.
- Keep network access and telemetry out of the plugin.
- Do not add automatic fixes or destructive behavior without prior discussion.
- Keep user-facing language direct, respectful, and easy to understand.

## Pull requests

Describe the problem, the behavior before and after the change, and how you verified it. Include screenshots for interface changes when possible. Never include private Roblox places, credentials, user data, or copyrighted assets you do not have permission to share.

By contributing, you agree that your contribution may be distributed under the project's MIT License.
