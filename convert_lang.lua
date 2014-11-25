dofile("lang/en.lua")
dofile("lang/xx.lua")

print_translations(en["Keys"], xx["Keys"], 1)
print_translations(en["Languages"], xx["Languages"], 1)
print_translations(en["LanguagesShort"], xx["LanguagesShort"], 1)
print_translations(en["Scripts"], xx["Scripts"], 1)
print_translations(en["Scripts_stand_alone"], xx["Scripts_stand_alone"], 1)

types_source = en["Types"]
types_translation = xx["Types"]
for i, key in pairs(types_source) do
	if(types_translation[i] ~= nil) then
		print_translations(types_source[i], types_translation[i], 1)
	end
end

print_translations(en["Variants"], xx["Variants"], 1)
