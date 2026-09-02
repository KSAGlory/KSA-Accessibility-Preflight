--!strict

local Contrast = require("../src/Contrast")

local function color(red: number, green: number, blue: number): Color3
	return {
		R = red,
		G = green,
		B = blue,
	} :: any
end

local black = color(0, 0, 0)
local white = color(1, 1, 1)
local purple = color(120 / 255, 92 / 255, 1)

assert(math.abs(Contrast.ratio(black, white) - 21) < 0.0001, "black/white should be 21:1")
assert(math.abs(Contrast.ratio(purple, purple) - 1) < 0.0001, "identical colors should be 1:1")
assert(
	math.abs(Contrast.ratio(black, purple) - Contrast.ratio(purple, black)) < 0.0001,
	"contrast ratio should be symmetrical"
)
assert(Contrast.formatRatio(4.567) == "4.57:1", "ratio display should use two decimal places")

print("Contrast tests passed")
