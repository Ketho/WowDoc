local m = {}

function m:template_apilink(apitype, apitable)
	local t = {}
	table.insert(t, "{{apilink")
	table.insert(t, "t="..apitype)
	table.insert(t, self:api_func_GetFullName(apitable))
	if apitype == "a" or apitype == "w" then
		if apitable.Arguments and #apitable.Arguments > 0 then
			local r = {}
			for _, v in pairs(apitable.Arguments) do
				table.insert(r, v.Name)
			end
			table.insert(t, "arg="..table.concat(r, ", "))
		end
		if apitable.Returns and #apitable.Returns > 0 then
			local r = {}
			for _, v in pairs(apitable.Returns) do
				table.insert(r, v.Name)
			end
			table.insert(t, "ret="..table.concat(r, ", "))
		end
	elseif apitype == "e" then
		if apitable.payload then
			table.insert(t, "payload="..apitable.payload)
		end
	end
	return table.concat(t, "|").."}}"
end

return m
