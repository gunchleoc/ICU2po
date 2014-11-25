dofile("locales/en.lua")
dofile("locales/xx.lua")

-- Note on this file: This script is only converting the number patterns and calendars
-- that my own locale had. You might have to fix up your own calendars etc.

print_plural_translations(
	en["NumberElements"]["latn"]["patternsLong"]["decimalformat_"],
	xx["NumberElements"]["latn"]["patternsLong"]["decimalformat_"],
	1)
print_plural_translations(
	en["NumberElements"]["latn"]["patternsShort"]["decimalformat_"],
	xx["NumberElements"]["latn"]["patternsShort"]["decimalformat_"],
	1)
print_translations(
	en["NumberElements"]["latn"]["symbols"],
	xx["NumberElements"]["latn"]["symbols"],
	1)


function translate_calendar_helper1_numeric(source, translation, key)
	for i, pattern in ipairs(source[key]) do
			print("#: " .. key .. " " .. i)
			print([[msgid "]] .. pattern .. [["]])
		if(translation[key] ~= nil and translation[key][i] ~= nil) then
			print([[msgstr "]] .. translation[key][i] .. [["]])
		else
			print([[msgstr ""]])
		end
		print()
	end
end

function translate_calendar_helper1_alpha(source, translation, key)
	for i, pattern in pairs(source[key]) do
		if(pattern[1] ~= nil ) then
			print("#: " .. key .. " " .. i)
			print([[msgid "]] .. pattern[1] .. [["]])
			if(translation[key] ~= nil and translation[key][i] ~= nil) then
				print([[msgstr "]] .. translation[key][i][1] .. [["]])
			else
				print([[msgstr ""]])
			end
			print()
		end
	end
end


function translate_calendar(source, translation)
	translate_calendar_helper1_numeric(source, translation, "DateTimePatterns")
	translate_calendar_helper1_alpha(source, translation, "appendItems")
	translate_calendar_helper1_alpha(source, translation, "availableFormats")

	for i, entry in pairs(source["intervalFormats"]) do
		translate_calendar_helper1_alpha(source["intervalFormats"],
		translation["intervalFormats"], i)
	end

end

-- Generic

translate_calendar(en["calendar"]["generic"], xx["calendar"]["generic"])

-- Gregorian

gregorian_source = en["calendar"]["gregorian"]
gregorian_target = xx["calendar"]["gregorian"]
translate_calendar(gregorian_source, gregorian_target)

translate_calendar_helper1_alpha(gregorian_source["dayNames"], gregorian_target["dayNames"], "format_")
translate_calendar_helper1_alpha(gregorian_source, gregorian_target, "eras")
translate_calendar_helper1_alpha(gregorian_source["monthNames"], gregorian_target["monthNames"], "format_")
translate_calendar_helper1_alpha(gregorian_source["quarters"], gregorian_target["quarters"], "format_")
translate_calendar_helper1_numeric(gregorian_source, gregorian_target, "AmPmMarkers")
translate_calendar_helper1_numeric(gregorian_source, gregorian_target, "AmPmMarkers_variant")
translate_calendar_helper1_numeric(gregorian_source, gregorian_target, "AmPmMarkersNarrow")

-- Delimiters
print_translations(
	en["delimiters"],
	xx["delimiters"],	1)

-- Fields TODO
fields_source = en["fields"]
fields_translation = xx["fields"]
for i, entry in pairs(fields_source) do
	if (fields_source[i]["dn"] ~= nil) then
		print("#: " .. i)
			print([[msgid "]] .. fields_source[i]["dn"][1] .. [["]])
			if(fields_translation[i] ~= nil and fields_translation[i]["dn"] ~= nil) then
				print([[msgstr "]] .. fields_translation[i]["dn"][1] .. [["]])
			else
				print([[msgstr ""]])
			end
			print()
	end
	if (fields_source[i]["relative"] ~= nil) then
		translate_calendar_helper1_alpha(fields_source[i], fields_translation[i], "relative")
	end
	if (fields_source[i]["relativeTime"] ~= nil) then
		for j, entry in pairs(fields_source[i]["relativeTime"]) do
			print_plural_translations(fields_source[i]["relativeTime"], fields_translation[i]["relativeTime"], 1)
		end
	end
end

-- listPattern
for i, entry in pairs(en["listPattern"]) do
	translate_calendar_helper1_alpha(en["listPattern"], xx["listPattern"], i)
end

-- measurementSystemNames
print_translations(en["measurementSystemNames"], xx["measurementSystemNames"], 1)

-- transformNames
print_translations(en["transformNames"], xx["transformNames"], 1)
