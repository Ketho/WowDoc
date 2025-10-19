---@diagnostic disable: need-check-nil
local pathlib = require("path")

require("wowdoc.config")
local widget_docs = require("wowdoc.loader.doc_widgets")
local log = require("wowdoc.log")
local PATH_PREDICATES = pathlib.join(".wow", "predicates")

local Predicates = {
	MayReturnNothing = 0,
	IsProtectedFunction = 1,
	HasRestrictions = 2,
	RequiresValidAndPublicCVar = 10,
	RequiresNonReadOnlyCVar = 11,
	RequiresNonSecureCVar = 12,
	RequiresIndexInRange = 13,
	RequiresValidInviteTarget = 20,
	RequiresFriendList = 30,
	RequiresClubsInitialized = 40,
	RequiresCommentator = 50,
	RequiresActiveCommentator = 51,
	SecretWhenInCombat = 60,
	SecretReturns = 61,
	SecretNonPlayerUnitOrMinionWhileInCombat = 62,
	ConstSecretAccessor = 63,
	RequiresValidTimelineEvent = 70,
}

local PRODUCT = "wow_beta" ---@type TactProduct
local wowdoc = require("wowdoc.loader")
wowdoc:main(PRODUCT)

local function GetFullName(apiTable)
	if apiTable.Type == "Event" then
		return apiTable.LiteralName
	elseif apiTable.Type == "Function" then
		if apiTable.System then
			if apiTable.System.Type == "System" then
				if apiTable.System.Namespace then
					return string.format("%s.%s", apiTable.System.Namespace, apiTable.Name)
				else
					return apiTable.Name
				end
			elseif apiTable.System.Type == "ScriptObject" then
				local widget = widget_docs[apiTable.System.Name]
				return string.format("%s %s", widget, apiTable.Name)
			end
		end
	end
end

local function SortPredicates(a, b)
	return Predicates[a] < Predicates[b]
end

local function ProcessDocTable(t0, v)
	local t1 = {}
	-- want to preserve the same order as in blizzard docs
	for attrib in pairs(Predicates) do
		if v[attrib] then
			table.insert(t1, attrib)
		end
	end
	if #t1 > 0 then
		table.sort(t1, SortPredicates)
		local t2 = {}
		for k2 in pairs(t1) do
			local stringified = string.format('"%s"', t1[k2])
			table.insert(t2, stringified)
		end
		local name = GetFullName(v) or v
		local propNames = table.concat(t2, ", ")
		local line = string.format('\t["%s"] = { %s },\n', name, propNames)
		table.insert(t0, line)
	end
end

local function ProcessDocs()
	local t0 = {}
	for _, v in pairs(APIDocumentation.functions) do
		ProcessDocTable(t0, v)
	end
	for _, v in pairs(APIDocumentation.events) do
		ProcessDocTable(t0, v)
	end
	table.sort(t0)
	return t0
end

local function WritePredicates()
	local output = pathlib.join(PATH_PREDICATES, "API_info.predicates.lua")
	local file = io.open(output, "w")
	file:write("local m = {}\n\n")
	file:write("m.data = {\n")
	local t = ProcessDocs()
	for _, v in pairs(t) do
		file:write(v)
	end
	file:write("}\n\n")
	file:write("return m\n")
	file:close()
end

local function WriteSecretArguments()
	local output = pathlib.join(PATH_PREDICATES, "API_info.SecretArguments.lua")
	local file = io.open(output, "w")
	file:write("local m = {}\n\n")
	file:write("m.data = {\n")
	local line = '\t["%s"] = "%s",\n'
	local t = {}
	for _, v in pairs(APIDocumentation.functions) do
		if v.SecretArguments then
			local name = GetFullName(v)
			table.insert(t, line:format(name, v.SecretArguments))
		end
	end
	table.sort(t)
	for _, v in pairs(t) do
		file:write(v)
	end
	file:write("}\n\n")
	file:write("return m\n")
	file:close()
end

local SecretAspect = {
	Hierarchy = 0x1,
	ObjectDebug = 0x1,
	ObjectName = 0x1,
	ObjectSecrets = 0x1,
	ObjectSecurity = 0x1,
	ObjectType = 0x1,
	ID = 0x2,
	Toplevel = 0x4,
	Text = 0x8,
	SecureText = 0x10,
	Shown = 0x20,
	Scale = 0x40,
	Alpha = 0x80,
	FrameLevel = 0x100,
	ScrollRange = 0x200,
	Cursor = 0x400,
	VertexColor = 0x800,
	Desaturation = 0x1000,
	TexCoords = 0x2000,
	BarValue = 0x4000,
	Cooldown = 0x8000,
}

local RevEnum_SecretAspect = {}
for k, v in pairs(SecretAspect) do
	RevEnum_SecretAspect[v] = k
end

local function WriteSecretReturnsForAspect()
	local output = pathlib.join(PATH_PREDICATES, "API_info.SecretReturnsForAspect.lua")
	local file = io.open(output, "w")
	file:write("local m = {}\n\n")
	file:write("m.data = {\n")
	local line = '\t["%s"] = {%s},\n'
	local t = {}
	for _, v in pairs(APIDocumentation.functions) do
		if v.SecretReturnsForAspect then
			local name = GetFullName(v)
			local t2 = {}
			for _, v2 in pairs(v.SecretReturnsForAspect) do
				local fs = '"Enum.SecretAspect.%s"'
				table.insert(t2, fs:format(RevEnum_SecretAspect[v2]))
			end
			table.insert(t, line:format(name, table.concat(t2, ", ")))
		end
	end
	table.sort(t)
	for _, v in pairs(t) do
		file:write(v)
	end
	file:write("}\n\n")
	file:write("return m\n")
	file:close()
end

local function main()
	pathlib.mkdir(PATH_PREDICATES)
	WritePredicates()
	WriteSecretArguments()
	WriteSecretReturnsForAspect()
	log:success("Done")
end

main()