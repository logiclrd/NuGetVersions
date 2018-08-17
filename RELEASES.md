## 1.0.1 (2018-08-17)
* Corrected NuGetVersion object to_s handling when the object is mutated (the original_version property that remembers the ".0" in "1.2.3.0" was interfering with this).

## 1.0.0 (2018-08-15)
* Made SemanticVersion and NuGetVersion mutable.
* Added unit tests.
* Various fixes based on results of unit testing.

## 0.9.1 (2018-07-19)
* Corrected assignment of original_version in NuGetVersions.try_parse.

## 0.9.0 (2018-07-19)
* Initial release.
