function WarcraftWiki:GetEventPage(event)
	local t = {}
	local signature = string.format("{{apisig|%s}}\n", self:GetEventSignature(event))
	table.insert(t, signature)
	local payload = self:GetEventPayload(event)
	table.insert(t, string.format("==Payload==\n%s\n", payload))
	return table.concat(t, "\n")
end

function WarcraftWiki:GetEventSignature(event)
	local t = {}
	table.insert(t, event.LiteralName)
	if event.Payload then
		local payload = event:GetPayloadString(false, false)
		table.insert(t, string.format(": %s", payload))
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
