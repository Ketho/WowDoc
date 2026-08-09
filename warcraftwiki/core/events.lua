function WarcraftWiki:GetEventPage(event)
	local t = {}
	table.insert(t, self:GetDocumentation(event))
	local signature = self:GetEventSignature(event)
	table.insert(t, string.format("{{apisig|%s}}\n", signature))
	table.insert(t, "==Payload==")
	table.insert(t, self:GetEventPayload(event))
	return table.concat(t, "\n")
end

function WarcraftWiki:GetEventSignature(event)
	local t = {}
	table.insert(t, event.LiteralName)
	if event.Payload then
		local multiStride = self:IsMultiStride(event.Payload)
		for _, param in pairs(event.Payload) do
			local r = {}
			if event.StrideIndex and not multiStride then
				table.insert(r, "...")
			end
			table.insert(r, param.Name)
			table.insert(t, table.concat(r))
		end
		local payload = table.concat(t, ", ")
		table.insert(t, string.format(": %s", payload))
		if multiStride then
			table.insert(t, ", ...")
		end
	end
	return table.concat(t)
end

function WarcraftWiki:GetEventPayload(event)
	if event.Payload then
		return self:GetParameters(event.Payload)
	else
		return "None"
	end
end
