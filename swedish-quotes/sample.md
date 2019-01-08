---
lang: sv 
...

This document has a YAML head with "lang:sv". This is to test that quotes get a symmetrical while also converting three dots to ... and correctly changing --- em ---, -- en -- and - minus - dashes.

[This is a sentence in English...,
with some "quotes" --- em --- and -- en -- and - minus - dashes.]{lang=en}

::: {lang=en}
Here's a div in English.
Code is ignored: `"baoeuthasoe"`{.nolang}.
So are [URLs](http://example.com/"notaword").
:::
