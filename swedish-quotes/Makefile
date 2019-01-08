test:
	@pandoc --lua-filter=swedish-quotes.lua sample.md | sort | diff --strip-trailing-cr -u expected.txt -
