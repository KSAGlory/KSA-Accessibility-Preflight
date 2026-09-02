--!strict

local Contrast = require(script.Parent.Contrast)

export type Severity = "high" | "medium" | "review"

export type Finding = {
	severity: Severity,
	category: string,
	title: string,
	detail: string,
	suggestion: string,
	instance: Instance,
	path: string,
	ratio: number?,
}

export type Report = {
	findings: { Finding },
	objectsScanned: number,
	textObjectsScanned: number,
	durationSeconds: number,
}

local Auditor = {}

local severityRank = {
	high = 1,
	medium = 2,
	review = 3,
}

local function hasEnabledGradient(guiObject: GuiObject): boolean
	for _, child in guiObject:GetChildren() do
		if child:IsA("UIGradient") and child.Enabled then
			return true
		end
	end

	return false
end

local function isImageObject(instance: Instance): boolean
	return instance:IsA("ImageLabel") or instance:IsA("ImageButton")
end

local function findSolidBackground(textObject: GuiObject): (Color3?, string?)
	local current: Instance? = textObject

	while current and current:IsA("GuiObject") do
		local guiObject = current :: GuiObject
		if isImageObject(guiObject) then
			return nil, "The nearest visible background is an image."
		end

		if hasEnabledGradient(guiObject) then
			return nil, "The nearest visible background uses a UIGradient."
		end

		if guiObject.BackgroundTransparency <= 0.05 then
			return guiObject.BackgroundColor3, nil
		end

		if guiObject.BackgroundTransparency < 1 then
			return nil, "The nearest visible background is translucent."
		end

		current = guiObject.Parent
	end

	return nil, "No opaque GuiObject background was found."
end

local function addFinding(findings: { Finding }, finding: Finding)
	table.insert(findings, finding)
end

local function inspectTextObject(instance: Instance, findings: { Finding })
	if not (instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox")) then
		return
	end

	local textObject = instance :: any
	local path = instance:GetFullName()

	if textObject.TextTransparency >= 1 or not textObject.Visible then
		return
	end

	if textObject.TextScaled then
		addFinding(findings, {
			severity = "medium",
			category = "Text scaling",
			title = "TextScaled ignores preferred text size",
			detail = "Roblox does not enlarge TextScaled text when a player chooses a larger PreferredTextSize.",
			suggestion = "Use a fixed TextSize with AutomaticSize or TextWrapped where the design allows it.",
			instance = instance,
			path = path,
			ratio = nil,
		})
	elseif textObject.TextSize < 14 then
		addFinding(findings, {
			severity = "review",
			category = "Text size",
			title = "Small text deserves a mobile check",
			detail = `This object uses TextSize {textObject.TextSize}. Small text can be difficult to read on phones or with low vision.`,
			suggestion = "Preview it on a small phone and at Roblox's Largest preferred text size.",
			instance = instance,
			path = path,
			ratio = nil,
		})
	end

	local backgroundColor, reason = findSolidBackground(textObject)
	if textObject.TextTransparency > 0.05 then
		addFinding(findings, {
			severity = "review",
			category = "Color contrast",
			title = "Transparent text needs manual review",
			detail = "TextTransparency changes the effective text color, so a solid-color ratio could be misleading.",
			suggestion = "Check the text in its final context and reduce transparency if readability is weak.",
			instance = instance,
			path = path,
			ratio = nil,
		})
	elseif backgroundColor then
		local ratio = Contrast.ratio(textObject.TextColor3, backgroundColor)
		local requiredRatio = if textObject.TextSize >= 24 then 3 else 4.5

		if ratio < requiredRatio then
			addFinding(findings, {
				severity = if ratio < 3 then "high" else "medium",
				category = "Color contrast",
				title = "Text contrast is below the reference target",
				detail = `Measured {Contrast.formatRatio(ratio)} against a {requiredRatio}:1 WCAG-inspired reference target.`,
				suggestion = "Increase the difference between the text and background colors, then scan again.",
				instance = instance,
				path = path,
				ratio = ratio,
			})
		end
	elseif textObject.Text ~= "" then
		addFinding(findings, {
			severity = "review",
			category = "Color contrast",
			title = "Contrast needs manual review",
			detail = reason or "The effective background color cannot be calculated safely.",
			suggestion = "Check this text over every image, gradient, translucent layer, or 3D scene it can appear on.",
			instance = instance,
			path = path,
			ratio = nil,
		})
	end
end

local function inspectMotionScript(instance: Instance, findings: { Finding })
	if not instance:IsA("LuaSourceContainer") then
		return
	end

	local ok, source = pcall(function()
		return instance.Source
	end)
	if not ok then
		return
	end

	local sourceText = source :: string
	local usesTween = string.find(sourceText, "TweenService", 1, true)
		or string.find(sourceText, ":TweenPosition", 1, true)
		or string.find(sourceText, ":TweenSize", 1, true)
	local respectsReducedMotion = string.find(sourceText, "ReducedMotionEnabled", 1, true)

	if usesTween and not respectsReducedMotion then
		addFinding(findings, {
			severity = "review",
			category = "Reduced motion",
			title = "UI animation may ignore reduced motion",
			detail = "This UI script appears to create tweens but does not reference GuiService.ReducedMotionEnabled.",
			suggestion = "Consider shortening or skipping non-essential motion when ReducedMotionEnabled is true.",
			instance = instance,
			path = instance:GetFullName(),
			ratio = nil,
		})
	end
end

local function collect(roots: { Instance }): { Instance }
	local collected: { Instance } = {}
	local seen: { [Instance]: boolean } = {}

	local function include(instance: Instance)
		if seen[instance] then
			return
		end
		seen[instance] = true
		table.insert(collected, instance)
	end

	for _, root in roots do
		include(root)
		for _, descendant in root:GetDescendants() do
			include(descendant)
		end
	end

	return collected
end

function Auditor.scan(roots: { Instance }): Report
	local startedAt = os.clock()
	local findings: { Finding } = {}
	local objects = collect(roots)
	local textObjectsScanned = 0

	for _, instance in objects do
		if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
			textObjectsScanned += 1
			inspectTextObject(instance, findings)
		end
		inspectMotionScript(instance, findings)
	end

	table.sort(findings, function(first, second)
		local firstRank = severityRank[first.severity]
		local secondRank = severityRank[second.severity]
		if firstRank == secondRank then
			if first.category == second.category then
				return first.path < second.path
			end
			return first.category < second.category
		end
		return firstRank < secondRank
	end)

	return {
		findings = findings,
		objectsScanned = #objects,
		textObjectsScanned = textObjectsScanned,
		durationSeconds = os.clock() - startedAt,
	}
end

return Auditor
