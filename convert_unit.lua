dofile("unit/en.lua")
dofile("unit/xx.lua")

units_source = en["units"]
units_translation = xx["units"]
for i, key in pairs(units_source) do
	if(units_translation[i] ~= nil) then
		print_unit_translations(units_source[i], units_translation[i], 1)
	end
end


unitsnarrow_source = en["unitsNarrow"]
unitsnarrow_translation = xx["unitsNarrow"]
for i, key in pairs(unitsnarrow_source) do
	if(unitsnarrow_translation[i] ~= nil) then
		print_unit_translations(unitsnarrow_source[i], unitsnarrow_translation[i], 1)
	end
end


unitsshort_source = en["unitsShort"]
unitsshort_translation = xx["unitsShort"]
for i, key in pairs(unitsshort_source) do
	if(unitsshort_translation[i] ~= nil) then
		print_unit_translations(unitsshort_source[i], unitsshort_translation[i], 1)
	end
end
