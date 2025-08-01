--!strict
local function makeKeys<K, V>(input: { [K]: V }): { [V]: K }
	local keys = {}

	for key, value in input do
		keys[value] = key
	end

	return keys
end

local INIT_PHRASE = "mrrp!"
local CAT_LEXICON_MAPPING = {
	["a"] = "mew",
	["b"] = "meow;",
	["c"] = "myau",
	["d"] = "uwu",
	["e"] = "?",
	["f"] = "owo",
	["g"] = ">///<",
	["h"] = "mao",
	["i"] = "merp",
	["j"] = "miaau",
	["k"] = "miaow",
	["l"] = "mraow",
	["m"] = "mrrew",
	["n"] = ">:3",
	["o"] = "prrrr",
	["p"] = "mrrrr",
	["q"] = "raaow",
	["r"] = "mrr",
	["s"] = "hiss",
	["t"] = "meow",
	["u"] = "mau",
	["v"] = "reowr",
	["w"] = "(meow)",
	["x"] = "rawr x3",
	["y"] = "le miaou",
	["z"] = "meowww",
	[" "] = "!",
	["."] = "*yawn*",
	["!"] = "OwO",
	["?"] = "^__^",
} :: { [string]: string }
local REVERSE_LEXICON_MAPPING = makeKeys(CAT_LEXICON_MAPPING)

local CONTENT_PATTERN = `^{INIT_PHRASE}%s*([^~]+)~$`

local function _toCatReplace(character: string): string
	local phrase = CAT_LEXICON_MAPPING[character:lower()] or character

	return phrase .. "\32"
end

return table.freeze {
	toMeow = function(input: string): string
		local meow = input
			:gsub(".", _toCatReplace)
			:gsub("%s+([?!]+)", "%1")
			:gsub("%s+$", "")

		return `{INIT_PHRASE} {meow}~`
	end,
	fromMeow = function(input: string): string
		local content = input:match(CONTENT_PATTERN)

		assert(content, "Invalid cat steganography!")

		local output = ""
		local window = ""

		local function flush()
			output ..= window
			window = ""
		end

		for char in content:gmatch "." do
			if char:match "%s" then
				flush()

				continue
			end

			window ..= char

			local letter = REVERSE_LEXICON_MAPPING[window]

			if letter then
				window = letter

				flush()
			end
		end

		flush()

		return output
	end,
}
