---@diagnostic disable: need-check-nil
local pathlib = require("path")

require("wowdoc.config")
local widget_docs = require("wowdoc.loader.doc_widgets")
local log = require("wowdoc.log")
local PATH_PREDICATES = pathlib.join(".wow", "predicates")

local PRODUCT = "wow_beta" ---@type TactProduct
local wowdoc = require("wowdoc.loader")
wowdoc:main(PRODUCT, nil, true)

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

local function ProcessDocTable(t0, v)
	local t1 = {}
	for field, value in pairs(v) do
		if value == true then -- straightforward way to just check for true
			table.insert(t1, field)
		end
	end
	if #t1 > 0 then
		table.sort(t1)
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
	log:info(string.format("Writing %s", output))
	local file = io.open(output, "w")
	file:write("local m = {}\n\n")
	file:write([=[
m.description = {
	MayReturnNothing = "",
	IsProtectedFunction = "",
	HasRestrictions = "",
	RequiresValidAndPublicCVar = "",
	RequiresNonReadOnlyCVar = "",
	RequiresNonSecureCVar = "",
	RequiresIndexInRange = "",
	RequiresValidInviteTarget = "",
	RequiresFriendList = "",
	RequiresClubsInitialized = "",
	RequiresCommentator = "",
	RequiresActiveCommentator = "",
	SecretWhenInCombat = "",
	SecretReturns = "",
	SecretNonPlayerUnitOrMinionWhileInCombat = "",
	ConstSecretAccessor = "",
	RequiresValidTimelineEvent = "",
	SecretPayloads = "",
	SynchronousEvent = "Dispatch of event is immediate and will complete before the function call returns",
	UniqueEvent = "Event gets queued and dispatched toward the end of a frame",
	CallbackEvent = "Can be registered with RegisterEventCallback()",
}
]=])
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
	log:info(string.format("Writing %s", output))
	local file = io.open(output, "w")
	file:write("local m = {}\n\n")
	file:write([=[function m:GetHeader()
	return '<div style="font-family:monospace">[[Patch_12.0.0/API_changes#Secret_values|SecretArguments]]</div>'
end

function m:GetAttributes()
	return 'class="apitype" title="%s" style="font-family:monospace;"'
end

m.description = {
	AllowedWhenUntainted = "Only accepts secret values if execution isn't tainted",
	AllowedWhenTainted = "Always accepts secret values",
	NotAllowed = "Never accepts secret values, even from untainted callers",
}
]=])
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
	Rotation = 0x10000,
	MinimumWidth = 0x20000,
	Padding = 0x40000,
}

local RevEnum_SecretAspect = {}
for k, v in pairs(SecretAspect) do
	RevEnum_SecretAspect[v] = k
end

local function WriteSecretReturnsForAspect()
	local output = pathlib.join(PATH_PREDICATES, "API_info.SecretReturnsForAspect.lua")
	log:info(string.format("Writing %s", output))
	local file = io.open(output, "w")
	file:write("local m = {}\n\n")
	file:write([=[function m:GetHeader()
	return '<div style="font-family:monospace">[[Patch_12.0.0/API_changes#Secret_aspects|SecretReturnsForAspect]]</div>'
end

function m:GetAttributes()
	return 'style="font-family:monospace;" class="apitype"'
end
]=])
	file:write("m.SecretArgumentsAddAspect = {\n")
	local line = '\t["%s"] = {%s},\n'
	local t = {}
	for _, v in pairs(APIDocumentation.functions) do
		if v.SecretArgumentsAddAspect then
			local name = GetFullName(v)
			local t2 = {}
			for _, v2 in pairs(v.SecretArgumentsAddAspect) do
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

	file:write("m.SecretReturnsForAspect = {\n")
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
