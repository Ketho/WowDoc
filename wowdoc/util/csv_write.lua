local m = {}

-- very basic csv writer
-- no escaping commas
-- requires empty strings for nil values
function m.main(path, tbl, header)
	local file = io.open(path, "w")
	if header then
		local line = table.concat(header, ",")
		file:write(string.format("%s\n", line))
	end
	for _, v in pairs(tbl) do
		local line = table.concat(v, ",")
		file:write(string.format("%s\n", line))
	end
	file:close()
end

return m
