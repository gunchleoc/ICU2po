--[[

**************************
* HOW TO USE THIS SCRIPT *
**************************

This script is for converting CLDR data from the ICU package into .po files,
so translators can load it into their translation memories.

Note that I wrote this script for myself and I am publishing it for your convenience.
No warranty whatsoever that it will work or that it won't blow up your computer.
Also, don't expect me to provide support. YOu can of course ask nicely ;)

The po file output can have multiple entries for the same key,
so if you run them with msgmerge, it will give you an error.
You can avoid some of this by commenting out stuff.
In any case, you will be able to load the resulting po files into Virtaal or Poedit
to fill up your translation memory.

I am releasing this script into the Public Domain, so you are welcome to do
what you want with it.

--------------
I. Install Lua
--------------

You will need the Lua programming language in order to run this script.
I don't know if you need the dev packages as well.
You will have to find that out for yourself.

------------------------------------------------------
II. Get the ICU Data Package and create the data files
------------------------------------------------------

For version 54.1, download this file:

http://download.icu-project.org/files/icu4c/54.1/icu4c-54_1-data.zip

This link can be found on the bottom of the following page,
in the "ICU4C Source Code Download" section:

http://site.icu-project.org/download/54

Unpack the files and copy them into this folder.

We need the following folders:

  curr
  lang
  locales
  region
  unit
  zone

Delete all other folders.

Enter each folder and delete all files except for "en.txt" and the file for your locale.

Now, we have some wonky character stuff going on here, so we need to clean up the basic file format. This is how we do it:

In each folder, open "en.txt". Mark all text (e.g. with "CTRL-A") and copy into a new file. Save the new file as "en.lua". Make sure you have UTF-8 encoding. Do the same for your locale's file, e.g. for "xx.txt", you will get "xx.lua".

---------------------------------------
II. Turn the data files into Lua tables
---------------------------------------

The ICU files look almost like Lua tables, but only almost.
So, we will have to fix them up to turn them into proper Lua tables.

In order to do so, get a text editor that can handle UTF-8 encoding.
Personally, I use Geany.

Now it's time for some serious Find and Replace.

And some terminology I will use: a Lua table looks like this:

key = {
  "entry1",
  "entry2",
}

The "key =" is optional.

Tables can also be nested:

table1 = {
  "entry1",
  "entry2",
  table2 = {
    "entry4",
    "entry5",
  }
}

-----------------------------------------
a. Fixes you need to do on all data files
-----------------------------------------

1. Delete the comments at beginning of the file
2. Search/replace all "{" with "= {"
3. Search/replace all "}" with "}," and delete last ","
4. Search/replace "-" in keys with "_"
5. Search/replace "%" in keys with "_"


-----------------
b. Fixes for curr
-----------------
1. Optional placeholder fu:
   Replace " = {0}," with "%1%",  " = {1}," with "%2%",  " = {2}," with "%3%"

-----------------
c. Fixes for lang
-----------------

1. Replace iso code "or" for Oriya with something else
2. Keys starting with numbers = bad idea
3. Optional placeholder fu:
   Replace " = {0}," with "%1%",  " = {1}," with "%2%",  " = {2}," with "%3%"

--------------------
c. Fixes for locales
--------------------

Note on this file: This script is only converting the number patterns and calendars
that my own locale had. You might have to fix up your own calendars etc.

1. Replace "end =" with "end_ ="
2. Replace "format =" with "format_ ="
3. Replace all " 1" with " a1"
4. Replace all " 2" with " a2"
5. Fix relative date keys.
   Your language might have more than these. English has -1, 0 and 1.

   i.   Replace all "-3" = with a_3 = (including the "").
   ii.  Replace all "-2" = with a_2 = (including the "").
   iii. Replace all "-1" = with a_1 = (including the "").
   iv.  Replace all "0" = with a0 = (including the "").
   v.   Replace all "1" = with a1 = (including the "").
   vi.  Replace all "2" = with a2 = (including the "").
   vii. Replace all "3" = with a3 = (including the "").

6. Delete all entries down to "LocaleScript", so the first processed key is "NumberElements"
7. Delete "contextTransforms" entries
8. Optional placeholder fu:
   Replace " = {0}," with "%1%",  " = {1}," with "%2%",  " = {2}," with "%3%"

--------------------
c. Fixes for region
--------------------

1. Replace all " 0" with " a0", " 1" with " a1", and replace "419" with "a419"

-----------------
c. Fixes for unit
-----------------

1. Optional placeholder fu:
   Replace " = {0}," with "%1%",  " = {1}," with "%2%",  " = {2}," with "%3%"

-----------------
c. Fixes for zone
-----------------

1. Replace all ":" with "_"
2. Replace all },<newline>" with },<newline> (this will delete the ")
3. Replace all " = { with  = { (this will delete the ")
4. Replace "Africa: with Africa: (this will delete the ")
5. Delete entries on the bottom from "fallbackFormat" to "regionFormatStandard"

------------------------
III. Prepare the scripts
------------------------

1. In each .lua file, search and replace "xx" with your locale's ISO code.

2. Below this guide, fix local target_plurals = {"one", "two", "few", "other"}
   to match your language.
   You can find the4 dfeinition for your language e.g. in the curr source file.

3. On the bottom of this file, you will find a generic po-file header.
   Fix it up to fit your needs.
   If you don't know how to do that, steal from another po file ;)
   Don't forget the plural forms.

4. Uncomment one of the included scripts on the bottom, e.g. turn
   "--dofile("convert_curr.lua")" into "dofile("convert_curr.lua")"

5. Run this script with:

      lua convert.lua

   The output will be shown on the screen. If there are no errors, run the script again
   and specify an output file, like this:

     lua convert.lua > currencies-xx.po

6. Repeat step 4. and 5. for each converter script.

]]

local source_plurals = {"one", "other"}
local target_plurals = {"one", "two", "few", "other"}

function print_translations(sourcetable, translations, index)
	if(translations ~= nil) then
		for i, source in pairs(sourcetable) do
			print("#: " .. i)
			print([[msgid "]] .. source[index] .. [["]])
			if(translations[i] ~= nil and translations[i][index] ~= nil) then
				print([[msgstr "]] .. translations[i][index] .. [["]])
			else
				print([[msgstr ""]])
			end
			print()
		end
	end
end


function print_plural_translations(sourcetable, translations, index)
	if(translations ~= nil) then
		for i, source in pairs(sourcetable) do
			print("#: " .. i)
			print([[msgid "]] .. source[source_plurals[1]][1] .. [["]])
			print([[msgid_plural "]] .. source[source_plurals[index]][1] .. [["]])
			for j, target_plural in pairs(target_plurals) do
				if(translations[i] ~= nil and translations[i][target_plural][1] ~= nil) then
					print([[msgstr[]] .. (j-1) .. [[] "]] .. translations[i][target_plural][1] .. [["]])
				else
					print([[msgstr[]] .. (j-1) .. [[] ""]])
				end
			end
			print()
		end
	end
end


function print_unit_translations(sourcetable, translations, index)
	if(translations ~= nil) then
		for i, source in pairs(sourcetable) do
			if(source["dnam"] ~= nil and translations[i] ~= nil and translations[i]["dnam"] ~= nil) then
				print("#: " .. i)
				print([[msgid "]] .. source["dnam"][1] .. [["]])
				print([[msgstr "]] .. translations[i]["dnam"][1] .. [["]])
				print()
			end

			print("#: " .. i)
			print([[msgid "]] .. source[source_plurals[1]][1] .. [["]])
			print([[msgid_plural "]] .. source[source_plurals[index]][1] .. [["]])
			for j, target_plural in pairs(target_plurals) do
				if(translations[i] ~= nil and translations[i][target_plural][1] ~= nil) then
					print([[msgstr[]] .. (j-1) .. [[] "]] .. translations[i][target_plural][1] .. [["]])
				else
					print([[msgstr[]] .. (j-1) .. [[] ""]])
				end
			end
			print()
		end
	end
end


print([[# LOCALE translation for ICU
# AUTHOR <email>, 2014.
msgid ""
msgstr ""
"Project-Id-Version: ICU\n"
"Report-Msgid-Bugs-To: \n"
"POT-Creation-Date: 2014-11-14 17:33+0000\n"
"PO-Revision-Date: 2014-11-04 12:05+0000\n"
"Last-Translator: \n"
"Language-Team: \n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"
"Plural-Forms: \n"
"Language: xx\n"
]])

--dofile("convert_curr.lua")
--dofile("convert_lang.lua")
--dofile("convert_locales.lua")
--dofile("convert_region.lua")
--dofile("convert_unit.lua")
--dofile("convert_zone.lua")
