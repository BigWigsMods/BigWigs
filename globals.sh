#!/bin/bash
# I suck at lua file system stuff :P
find . -name "*.lua" | while read fileName; do
	luac -l $fileName | lua globals.lua $fileName
done
rm luac.out
