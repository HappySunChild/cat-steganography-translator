--!strict
local function makeKeys<K, V>(input: { [K]: V }): { [V]: K }
	local keys = {}

	for key, value in input do
		keys[value] = key
	end

	return keys
end

local function toList<V>(input: { [any]: V }): { V }
	local list = {}

	for _, value in input do
		table.insert(list, value)
	end

	return list
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
local LEXICON_LIST = toList(CAT_LEXICON_MAPPING)

table.sort(LEXICON_LIST, function(a: string, b: string)
	return #a > #b
end)

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
		local i = 1

		while i <= #content do
			local ok = false

			for _, word in LEXICON_LIST do
				if content:sub(i, i + #word - 1) == word then
					ok = true

					print(word, i)

					i += #word
					output ..= REVERSE_LEXICON_MAPPING[word]

					break
				end
			end

			if not ok then
				i += 1
			end
		end

		return output
	end,
}
