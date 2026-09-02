--!strict

local Selection = game:GetService("Selection")
local StarterGui = game:GetService("StarterGui")

local Auditor = require(script.Parent.Auditor)
local Theme = require(script.Parent.Theme)

local AUTHOR = "KSAGlory"
local COMMUNITY = "discord.gg/ksahub"

local toolbar = plugin:CreateToolbar("KSA Resources")
local toolbarButton = toolbar:CreateButton(
	"KSA Accessibility Preflight",
	"Review Roblox UI accessibility before publishing",
	"rbxassetid://4458901886"
)
toolbarButton.ClickableWhenViewportHidden = true

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Right,
	false,
	false,
	410,
	620,
	350,
	420
)

local widget = plugin:CreateDockWidgetPluginGui("KSAA11yPreflight_v1", widgetInfo)
widget.Title = "KSA Accessibility Preflight"
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function create(className: string, properties: { [string]: any }, parent: Instance?): Instance
	local instance = Instance.new(className)
	for key, value in properties do
		(instance :: any)[key] = value
	end
	instance.Parent = parent
	return instance
end

local function addCorner(parent: Instance, radius: number)
	create("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function addStroke(parent: Instance, color: Color3?, transparency: number?)
	create("UIStroke", {
		Color = color or Theme.Border,
		Transparency = transparency or 0,
		Thickness = 1,
	}, parent)
end

local root = create("Frame", {
	Name = "Root",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Theme.Background,
	BorderSizePixel = 0,
}, widget) :: Frame

create("UIPadding", {
	PaddingTop = UDim.new(0, 16),
	PaddingRight = UDim.new(0, 16),
	PaddingBottom = UDim.new(0, 14),
	PaddingLeft = UDim.new(0, 16),
}, root)

local header = create("Frame", {
	Name = "Header",
	Size = UDim2.new(1, 0, 0, 60),
	BackgroundTransparency = 1,
}, root) :: Frame

local brandMark = create("Frame", {
	Size = UDim2.fromOffset(44, 44),
	Position = UDim2.fromOffset(0, 2),
	BackgroundColor3 = Theme.Accent,
	BorderSizePixel = 0,
}, header)
addCorner(brandMark, 11)

create("TextLabel", {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Text = "KSA",
	TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.GothamBold,
	TextSize = 14,
}, brandMark)

create("TextLabel", {
	Position = UDim2.fromOffset(56, 0),
	Size = UDim2.new(1, -56, 0, 25),
	BackgroundTransparency = 1,
	Text = "Accessibility Preflight",
	TextColor3 = Theme.Text,
	TextXAlignment = Enum.TextXAlignment.Left,
	Font = Enum.Font.GothamBold,
	TextSize = 17,
}, header)

create("TextLabel", {
	Position = UDim2.fromOffset(56, 26),
	Size = UDim2.new(1, -56, 0, 18),
	BackgroundTransparency = 1,
	Text = "Catch UI barriers before your players do.",
	TextColor3 = Theme.Muted,
	TextXAlignment = Enum.TextXAlignment.Left,
	Font = Enum.Font.Gotham,
	TextSize = 11,
}, header)

local intro = create("TextLabel", {
	Position = UDim2.fromOffset(0, 68),
	Size = UDim2.new(1, 0, 0, 44),
	BackgroundTransparency = 1,
	Text = "Scans contrast, text scaling, small text, and reduced-motion support. Nothing is changed automatically.",
	TextColor3 = Theme.Muted,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	TextWrapped = true,
	Font = Enum.Font.Gotham,
	TextSize = 11,
}, root) :: TextLabel

local actions = create("Frame", {
	Position = UDim2.fromOffset(0, 120),
	Size = UDim2.new(1, 0, 0, 42),
	BackgroundTransparency = 1,
}, root) :: Frame

create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, actions)

local function makeActionButton(text: string, primary: boolean, layoutOrder: number): TextButton
	local button = create("TextButton", {
		LayoutOrder = layoutOrder,
		Size = UDim2.new(0.5, -4, 1, 0),
		BackgroundColor3 = if primary then Theme.Accent else Theme.Surface,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = text,
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
	}, actions) :: TextButton
	addCorner(button, 8)
	if not primary then
		addStroke(button)
	end

	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = if primary then Theme.Accent:Lerp(Color3.new(1, 1, 1), 0.08) else Theme.SurfaceHover
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = if primary then Theme.Accent else Theme.Surface
	end)

	return button
end

local scanSelectionButton = makeActionButton("Scan selection", true, 1)
local scanStarterGuiButton = makeActionButton("Scan StarterGui", false, 2)

local summary = create("Frame", {
	Position = UDim2.fromOffset(0, 174),
	Size = UDim2.new(1, 0, 0, 66),
	BackgroundColor3 = Theme.Surface,
	BorderSizePixel = 0,
}, root) :: Frame
addCorner(summary, 9)
addStroke(summary)

local statusDot = create("Frame", {
	Position = UDim2.fromOffset(14, 18),
	Size = UDim2.fromOffset(10, 10),
	BackgroundColor3 = Theme.Muted,
	BorderSizePixel = 0,
}, summary) :: Frame
addCorner(statusDot, 5)

local statusLabel = create("TextLabel", {
	Position = UDim2.fromOffset(34, 10),
	Size = UDim2.new(1, -46, 0, 20),
	BackgroundTransparency = 1,
	Text = "Ready for a preflight scan",
	TextColor3 = Theme.Text,
	TextXAlignment = Enum.TextXAlignment.Left,
	Font = Enum.Font.GothamMedium,
	TextSize = 12,
}, summary) :: TextLabel

local metaLabel = create("TextLabel", {
	Position = UDim2.fromOffset(34, 33),
	Size = UDim2.new(1, -46, 0, 18),
	BackgroundTransparency = 1,
	Text = "Select a ScreenGui, frame, or group of UI objects.",
	TextColor3 = Theme.Muted,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Font = Enum.Font.Gotham,
	TextSize = 10,
}, summary) :: TextLabel

local findingsHeader = create("Frame", {
	Position = UDim2.fromOffset(0, 252),
	Size = UDim2.new(1, 0, 0, 24),
	BackgroundTransparency = 1,
}, root) :: Frame

local findingsTitle = create("TextLabel", {
	Size = UDim2.new(0.5, 0, 1, 0),
	BackgroundTransparency = 1,
	Text = "FINDINGS",
	TextColor3 = Theme.Muted,
	TextXAlignment = Enum.TextXAlignment.Left,
	Font = Enum.Font.GothamBold,
	TextSize = 10,
}, findingsHeader) :: TextLabel

local countsLabel = create("TextLabel", {
	Position = UDim2.fromScale(0.5, 0),
	Size = UDim2.new(0.5, 0, 1, 0),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = Theme.Muted,
	TextXAlignment = Enum.TextXAlignment.Right,
	Font = Enum.Font.Gotham,
	TextSize = 10,
}, findingsHeader) :: TextLabel

local results = create("ScrollingFrame", {
	Position = UDim2.fromOffset(0, 282),
	Size = UDim2.new(1, 0, 1, -312),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = Theme.Border,
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	CanvasSize = UDim2.new(),
}, root) :: ScrollingFrame

local resultsLayout = create("UIListLayout", {
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, results) :: UIListLayout

create("TextLabel", {
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 0, 1, 0),
	Size = UDim2.new(1, 0, 0, 22),
	BackgroundTransparency = 1,
	Text = `Free resource by {AUTHOR}  ·  {COMMUNITY}`,
	TextColor3 = Theme.Muted,
	TextXAlignment = Enum.TextXAlignment.Center,
	Font = Enum.Font.Gotham,
	TextSize = 9,
}, root)

local function showEmptyState(text: string, color: Color3?)
	create("TextLabel", {
		Name = "EmptyState",
		Size = UDim2.new(1, -6, 0, 110),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = color or Theme.Muted,
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextWrapped = true,
	}, results)
end

showEmptyState("Run a scan to review your interface.\nFindings are guidance, not accessibility certification.")

local severityColors = {
	high = Theme.High,
	medium = Theme.Medium,
	review = Theme.Review,
}

local function clearResults()
	for _, child in results:GetChildren() do
		if child ~= resultsLayout then
			child:Destroy()
		end
	end
end

local function addFindingCard(finding: Auditor.Finding, layoutOrder: number)
	local color = severityColors[finding.severity]
	local card = create("TextButton", {
		LayoutOrder = layoutOrder,
		Size = UDim2.new(1, -6, 0, 142),
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
	}, results) :: TextButton
	addCorner(card, 9)
	addStroke(card)

	local indicator = create("Frame", {
		Size = UDim2.fromOffset(4, 142),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
	}, card)
	addCorner(indicator, 9)

	create("TextLabel", {
		Position = UDim2.fromOffset(14, 9),
		Size = UDim2.new(1, -27, 0, 17),
		BackgroundTransparency = 1,
		Text = string.upper(finding.severity) .. "  ·  " .. finding.category,
		TextColor3 = color,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
	}, card)

	create("TextLabel", {
		Position = UDim2.fromOffset(14, 29),
		Size = UDim2.new(1, -27, 0, 19),
		BackgroundTransparency = 1,
		Text = finding.title,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
	}, card)

	create("TextLabel", {
		Position = UDim2.fromOffset(14, 50),
		Size = UDim2.new(1, -27, 0, 18),
		BackgroundTransparency = 1,
		Text = finding.path,
		TextColor3 = Theme.Muted,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Font = Enum.Font.Code,
		TextSize = 10,
	}, card)

	create("TextLabel", {
		Position = UDim2.fromOffset(14, 72),
		Size = UDim2.new(1, -27, 0, 34),
		BackgroundTransparency = 1,
		Text = finding.detail,
		TextColor3 = Theme.Muted,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Font = Enum.Font.Gotham,
		TextSize = 10,
	}, card)

	create("TextLabel", {
		Position = UDim2.fromOffset(14, 111),
		Size = UDim2.new(1, -112, 0, 22),
		BackgroundTransparency = 1,
		Text = finding.suggestion,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Font = Enum.Font.Gotham,
		TextSize = 9,
	}, card)

	create("TextLabel", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -12, 1, -10),
		Size = UDim2.fromOffset(88, 15),
		BackgroundTransparency = 1,
		Text = "SELECT  →",
		TextColor3 = Theme.Muted,
		TextXAlignment = Enum.TextXAlignment.Right,
		Font = Enum.Font.GothamBold,
		TextSize = 9,
	}, card)

	card.MouseEnter:Connect(function()
		card.BackgroundColor3 = Theme.SurfaceHover
	end)
	card.MouseLeave:Connect(function()
		card.BackgroundColor3 = Theme.Surface
	end)
	card.Activated:Connect(function()
		if finding.instance.Parent ~= nil then
			Selection:Set({ finding.instance })
		end
	end)
end

local scanning = false

local function runScan(roots: { Instance }, scopeName: string)
	if scanning then
		return
	end

	scanning = true
	statusDot.BackgroundColor3 = Theme.Accent
	statusLabel.Text = "Scanning " .. scopeName .. "…"
	metaLabel.Text = "Reviewing UI objects and related scripts"

	task.defer(function()
		local report = Auditor.scan(roots)
		clearResults()

		local highCount = 0
		local mediumCount = 0
		local reviewCount = 0

		for index, finding in report.findings do
			if finding.severity == "high" then
				highCount += 1
			elseif finding.severity == "medium" then
				mediumCount += 1
			else
				reviewCount += 1
			end
			addFindingCard(finding, index)
		end

		if #report.findings == 0 then
			showEmptyState(
				"No automatic warnings found.\nManually test images, audio cues, keyboard navigation, and real devices.",
				Theme.Pass
			)
		end

		statusDot.BackgroundColor3 = if highCount > 0 then Theme.High else Theme.Pass
		statusLabel.Text = if #report.findings == 0
			then "Automatic checks passed"
			else `{#report.findings} finding(s) need attention`
		metaLabel.Text = `{report.textObjectsScanned} text objects · {report.objectsScanned} total · {report.durationSeconds * 1000 // 1} ms`
		findingsTitle.Text = `FINDINGS  ·  {#report.findings}`
		countsLabel.Text = `{highCount} high  ·  {mediumCount} medium  ·  {reviewCount} review`
		scanning = false
	end)
end

scanSelectionButton.Activated:Connect(function()
	local selected = Selection:Get()
	if #selected == 0 then
		statusDot.BackgroundColor3 = Theme.Medium
		statusLabel.Text = "Nothing selected"
		metaLabel.Text = "Select a ScreenGui, frame, or UI object in Explorer."
		return
	end

	runScan(selected, "selection")
end)

scanStarterGuiButton.Activated:Connect(function()
	runScan({ StarterGui }, "StarterGui")
end)

toolbarButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

widget:GetPropertyChangedSignal("Enabled"):Connect(function()
	toolbarButton:SetActive(widget.Enabled)
end)
