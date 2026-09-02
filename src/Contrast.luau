--!strict

local Contrast = {}

local function linearize(channel: number): number
	if channel <= 0.04045 then
		return channel / 12.92
	end

	return ((channel + 0.055) / 1.055) ^ 2.4
end

function Contrast.relativeLuminance(color: Color3): number
	return 0.2126 * linearize(color.R)
		+ 0.7152 * linearize(color.G)
		+ 0.0722 * linearize(color.B)
end

function Contrast.ratio(first: Color3, second: Color3): number
	local firstLuminance = Contrast.relativeLuminance(first)
	local secondLuminance = Contrast.relativeLuminance(second)
	local lighter = math.max(firstLuminance, secondLuminance)
	local darker = math.min(firstLuminance, secondLuminance)

	return (lighter + 0.05) / (darker + 0.05)
end

function Contrast.formatRatio(ratio: number): string
	return string.format("%.2f:1", ratio)
end

return Contrast
