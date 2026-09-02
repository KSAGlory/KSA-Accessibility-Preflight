# Contributing to KSA Accessibility Preflight

Thank you for helping improve KSA Accessibility Preflight. The project is maintained as a free resource for the Roblox community.

## Before Proposing a Change

Open an issue or discuss the idea through [discord.gg/ksahub](https://discord.gg/ksahub) before making a large change. Small bug fixes and documentation corrections can be submitted directly.

Accessibility checks must be conservative. A warning should explain what was observed without claiming that a person, interface, or experience has failed a formal certification.

## Rule Requirements

Every new automatic check should provide:

- A clear title written for Roblox creators
- A factual explanation of the observed behavior
- A practical suggestion that does not modify user work automatically
- Known limitations and situations that require manual review
- A reliable way to identify the affected Studio instance

Avoid checks based only on personal design preferences. Prefer documented Roblox behavior or established accessibility guidance.

## Development Checks

Run the package verification script before submitting a change:

```powershell
./scripts/verify.ps1
```

If the Luau command-line tools are installed, compile every file in `src` and run `tests/contrast.spec.luau`.

## Code Style

- Use strict Luau for source modules.
- Choose descriptive names over abbreviations.
- Add comments only when they clarify intent or a non-obvious limitation.
- Keep network access and telemetry out of the plugin.
- Do not add automatic fixes or destructive behavior without prior discussion.
- Keep user-facing language direct, respectful, and easy to understand.

## Pull Requests

Describe the problem, the behavior before and after the change, and how you verified it. Include screenshots for interface changes when possible. Never include private Roblox places, credentials, user data, or copyrighted assets you do not have permission to share.

By contributing, you agree that your contribution may be distributed under the project's MIT License.
