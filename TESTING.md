# Testing KSA Accessibility Preflight

The repository includes a small interface containing known pass and warning examples. It lets maintainers confirm the plugin's behavior without using a private game.

## Prepare the Plugin

1. Open Roblox Studio with a blank place.
2. Import `dist/KSA-Accessibility-Preflight.rbxmx`.
3. In Explorer, right-click the **KSA Accessibility Preflight** folder and choose **Save as Local Plugin**.
4. Restart Studio if the **KSA Resources** toolbar does not appear immediately.

## Import the Test Interface

1. Import `examples/KSA-Accessibility-Test-UI.rbxmx`.
2. Move **KSA Accessibility Test UI** into `StarterGui` if Studio imports it elsewhere.
3. Select **KSA Accessibility Test UI** in Explorer.
4. Open **KSA Accessibility Preflight** from the **KSA Resources** toolbar.
5. Select **Scan selection**.

## Expected Result

The scan should report six findings:

- 1 high finding for `LowContrastText`
- 1 medium finding for `ScaledText`
- 1 review finding for `SmallText`
- 1 review finding for `TransparentText`
- 1 review finding for `GradientText`
- 1 review finding for `TweenWithoutReducedMotion`

`GoodContrastText` and `ExpectedResults` should not produce findings.

Select each result card and confirm that Studio selects the matching object in Explorer. Resize and dock the plugin window, then confirm that cards remain readable and the list scrolls correctly.

## Report a Difference

If the count or severity differs, record:

- The plugin version
- Roblox Studio version
- The displayed finding counts
- Which expected object is missing or incorrect
- A screenshot of the plugin window when safe

Share the report through [discord.gg/ksahub](https://discord.gg/ksahub). Do not include account credentials, cookies, private place files, or personal information.
