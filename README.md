Desinax base for themes
=======================

[![Build Status](https://travis-ci.org/desinax/theme.svg?branch=master)](https://travis-ci.org/desinax/theme)
[![CircleCI](https://circleci.com/gh/desinax/theme.svg?style=svg)](https://circleci.com/gh/desinax/theme)

This can be used for base when building a Desinax theme, with or without Desinax modules.



External modules
-----------------------

The following external modules are used.



### Normalize.css

This is managed through the makefile by installing the npm package normalize.css and copying the files to `src/` and making a copy of `normalize.css` to `normalize.less`.

Use it by including it in your stylesheet.



### Font Awesome free

This is managed through the makefile by installing the npm package fortawesome/fontawesome-free and copying the files to `src/`.

Use it by including it into your stylesheet.

The font directory `webfonts/` needs to be manually copied to `htdocs/` when upgrading.

```text
# Go to the project root
rsync -av src/@fortawesome/fontawesome-free/webfonts htdocs/
```



```
 . 
..:  Copyright (c) 2018 Mikael Roos, mos@dbwebb.se 
```
