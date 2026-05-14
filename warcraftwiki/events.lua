function WarcraftWiki:GetEventText(event)
	local signature = format("{{apisig|%s}}\n", self:GetEventSignature(event))
	local payload = format("\n==Payload==\n%s\n", self:GetEventPayload(event))
	return signature..payload
end

function WarcraftWiki:GetEventSignature(event)
	return event.LiteralName..(event.Payload and ": "..event:GetPayloadString(false, false) or "")
end

function WarcraftWiki:GetEventPayload(event)
	return event.Payload and self:GetParameters(event.Payload) or "None"
end
