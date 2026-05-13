local m = {}

function m:GetPatchVersion(v)
	return v:match("%d+%.%d+%.%d+")
end

function m:GetPatchText(patchData, ID, patch_override)
	local version = self:GetPatchVersion(patchData[ID].patch)
	local text = patch_override and patch_override[version] or version
	local ptrVersion = "11.2.7"
	if text == ptrVersion then
		text = text.." [[File:PTR_client.png|16px|link=]]"
	end
	return text
end

return m
