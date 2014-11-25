ICU2po
======

Converts ICU data files to gettext po files.

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

Usage instructions can be found in the convert.lua file.
