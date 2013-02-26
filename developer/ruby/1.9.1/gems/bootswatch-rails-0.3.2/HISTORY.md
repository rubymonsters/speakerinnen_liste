## 0.3.2 (2013-01-23)

* Escape complex arguments to box-shadow in Simplex (reported @murtra)
* Make glyphicon links rails-friendly by default (reported @nysalor)

## 0.3.1 (2013-01-14)

* Add !default to all bootswatch variables, making them overridable


## 0.3.0 (2013-01-13)

* Add a converter script for most of the repetitive less/sass conversion work
* Add bootswatch project as a submodule
* Add a rake task that auto-converts less files from submodule into scss
* Convert all latest bootswatches to scss
* Stop using percentage -> percentile conversion, it seems to only break things
