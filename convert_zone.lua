dofile("zone/en.lua")
dofile("zone/xx.lua")


function print_zones(sourcetable, translations)
	if(translations ~= nil) then
		for i, source in pairs(sourcetable) do
			for j, entry in pairs(source) do
				if(translations[i] ~= nil and translations[i][j] ~= nil) then
					print("#: " .. i .. " - " .. j)
					print([[msgid "]] .. entry[1] .. [["]])
					print([[msgstr "]] .. translations[i][j][1] .. [["]])
					print()
				end
			end
		end
	end
end


print_zones(en["zoneStrings"], xx["zoneStrings"])
