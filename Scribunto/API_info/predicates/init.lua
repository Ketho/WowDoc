---@diagnostic disable: need-check-nil
local pathlib = require("path")

local log = require("wowdoc.util.log")
local loader = require("wowdoc.loader")
local cfg = require("wowdoc.config")
local widget_docs = require("wowdoc.namingway.scriptobjects")

-- need to do a reverse lookup
-- so gonna apply hack and make them unique /shrug
local function EditEnum()
	local t = {
		Attributes = 0x10a,
		Hierarchy = 0x10b,
		ObjectDebug = 0x10c,
		ObjectName = 0x10d,
		ObjectSecrets = 0x10e,
		ObjectSecurity = 0x10f,
		ObjectType = 0x11,
	}
	for k, v in pairs(t) do
		Enum.SecretAspect[k] = v
	end
end

APIDocumentation = nil
loader:LoadDocumentation()
EditEnum()

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
		-- predicates can be true or false
		if value == true then
			table.insert(t1, field)
		elseif value == false then
			table.insert(t1, field..": false")
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
	local output = pathlib.join(cfg.path.wiki_predicates, "API_info.predicates.lua")
	log.info(string.format("Writing %s", output))
	local file = io.open(output, "w")
	file:write("local m = {}\n\n")
	file:write([=[
m.description = {
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
	local output = pathlib.join(cfg.path.wiki_predicates, "API_info.SecretArguments.lua")
	log.info(string.format("Writing %s", output))
	local file = io.open(output, "w")
	file:write("local m = {}\n\n")
	file:write([=[function m:GetHeader()
	return '<div style="font-family:monospace">[[Patch_12.0.0/API_changes#Secret_values|SecretArguments]]</div>'
end

function m:GetAttributes()
	return 'title="%s" style="font-family: monospace; text-decoration: underline dotted;"'
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

local RevEnum_SecretAspect = {}
for k, v in pairs(Enum.SecretAspect) do
	RevEnum_SecretAspect[v] = k
end

local function WriteSecretAspects()
	local output = pathlib.join(cfg.path.wiki_predicates, "API_info.SecretAspects.lua")
	log.info(string.format("Writing %s", output))
	local file = io.open(output, "w")
	file:write("local m = {}\n\n")
	file:write([=[function m:GetHeaderArguments()
	return '<div style="font-family:monospace">[[Patch_12.0.0/API_changes#Secret_aspects|SecretArgumentsAddAspect]]</div>'
end

function m:GetHeaderReturns()
	return '<div style="font-family:monospace">[[Patch_12.0.0/API_changes#Secret_aspects|SecretReturnsForAspect]]</div>'
end

function m:GetAttributes()
	return 'class="apitype" title="%s" style="font-family:monospace;"'
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
				table.insert(t2, string.format('"%s"', RevEnum_SecretAspect[v2]))
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
				table.insert(t2, string.format('"%s"', RevEnum_SecretAspect[v2]))
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
	WritePredicates()
	WriteSecretArguments()
	WriteSecretAspects()
	log.success("Done")
end

main()
