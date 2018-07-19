# NuGetVersions

This Gem contains components for parsing & working with version numbers, as NuGet assigns them to packages. The NuGet versioning scheme is a superset of Semantic Versioning (http://semver.org). The components in this library are loosely based on the version number classes in the NuGet client source code.

## Class: `SemanticVersion`

This class is a basic implementation of Semantic Versions with no extensions. This allows version numbers of the form `x.y.z-prerelease+metadata`, where `-prerelease` and `+metadata` are each optional.

### Creating

There are three main ways to create an instance of `SemanticVersion`:

#### Constructor: `SemanticVersion.new`

The `SemanticVersion` constructor has arguments for all 5 parts of the version. The prerelease ("release label") and metadata parts are optional, and default to `nil`.

```
  version = SemanticVersion.new(1, 2, 3)                    # "1.2.3"
  version = SemanticVersion.new(1, 2, 3, "alpha")           # "1.2.3-alpha"
  version = SemanticVersion.new(1, 2, 3, "alpha.4")         # "1.2.3-alpha.4"
  version = SemanticVersion.new(1, 2, 3, ["alpha", "4"])    # "1.2.3-alpha.4"
  version = SemanticVersion.new(1, 2, 3, "alpha", "bugfix") # "1.2.3-alpha+bugfix"
  version = SemanticVersion.new(1, 2, 3, nil, "bugfix")     # "1.2.3+bugfix"
```
  
#### Copy: `SemanticVersion.copy_of`

If you have an existing instance of `SemanticVersion`, you can make another instance with equivalent values by calling the `copy_of` method on the class.

```
  version = ...
  
  version2 = SemanticVersion.copy_of(version)
```

This can be used to convert a `NuGetVersion` (below) to a `SemanticVersion`, as a `NuGetVersion` is a `kind_of? SemanticVersion`.

#### Parse: `SemanticVersion.parse`, `SemanticVersion.try_parse`

If you have a version number in string form, you can convert it to a `SemanticVersion` object using one of the parse methods on the class. The method `SemanticVersion.parse` raises an exception if the string is not in a valid format, while `SemanticVersion.try_parse` returns `nil`.

```
  version = SemanticVersion.parse("1.2.3")          # "1.2.3"
  version = SemanticVersion.parse("1.2.3-alpha.4")  # "1.2.3-alpha.4"
  version = SemanticVersion.parse("1.2.3+bugfix")   # "1.2.3+bugfix"
  version = SemanticVersion.parse("1.2.3.4")        # EXCEPTION
  version = SemanticVersion.try_parse("1.2.3.4")    # nil
```

### Using

The `SemanticVersion` class exposes its component values as read-only property accessors.

| Property Name    | Description                                                                                                |
| ---------------- | ---------------------------------------------------------------------------------------------------------- |
| `major`          | The major part of the version number - `X.y.z`.                                                            |
| `minor`          | The minor part of the version number - `x.Y.z`.                                                            |
| `patch`          | The patch part of the version number - `x.y.Z`.                                                            |
| `release`        | The release label of the version number, as in `alpha.4` for `1.2.3-alpha.4`. Can be `nil`.                |
| `release_labels` | The release label of the version number as an array of components, as in `[ 'alpha', '4' ]` for `alpha.4`. |
| `metadata`       | The metadata part of the version number, as in `bugfix` for `1.2.3+bugfix`. Can be `nil`.                  |

An instance of `SemanticVersion` can be converted to its string representation using the standard `to_s` method.

```
  SemanticVersion.parse("1.2.3-alpha.4+bugfix").to_s # "1.2.3-alpha.4-bugfix"
```

Instances of `SemanticVersion` are comparable & orderable.

```
  a = SemanticVersion.parse("1.2.3")
  b = SemanticVersion.parse("1.2.4")
  
  a < b   # true
  a <= b  # true
  a > b   # false
  a >= b  # false
  a < a   # false
  a <= a  # false
  a == a  # true
  a != a  # false
  a == b  # false
  a != b  # true
  a <=> b # -1
```

Instances of `SemanticVersion` can also be compared directly with instances of `NuGetVersion`.

## Class: `NuGetVersion`

This class extends `SemanticVersion` to support NuGet's "legacy" 4-part version number scheme. This is essentially the same scheme as Semantic Version, except with four version components instead of three. Thus, version numbers such as `1.2.3.4`, `1.2.3.4-alpha` and `1.2.3.4+bugfix` are permissible, in addition to any version `SemanticVersion` accepts. Note that if the 4th component is `0`, then it is omitted.

```
  NuGetVersion.parse("1.2.3.0").to_s # "1.2.3"
```

### Creating

As with `SemanticVersion`, there are three main ways to create an instance of `NuGetVersion`:

#### Constructor: `NuGetVersion.new`

The `NuGetVersion` constructor has arguments for all 6 parts of the version. The prerelease ("release label") and metadata parts are optional, and default to `nil`. The fourth version component is also optional, and defaults to `0`.

```
  version = NuGetVersion.new(1, 2, 3)                       # "1.2.3"
  version = NuGetVersion.new(1, 2, 3, 0)                    # "1.2.3"
  version = NuGetVersion.new(1, 2, 3, 4)                    # "1.2.3.4"
  version = NuGetVersion.new(1, 2, 3, 0, "alpha")           # "1.2.3-alpha"
  version = NuGetVersion.new(1, 2, 3, 4, "alpha")           # "1.2.3.4-alpha"
  version = NuGetVersion.new(1, 2, 3, 4, "alpha.5")         # "1.2.3.4-alpha.5"
  version = NuGetVersion.new(1, 2, 3, 4, ["alpha", "5"])    # "1.2.3.4-alpha.5"
  version = NuGetVersion.new(1, 2, 3, 4, "alpha", "bugfix") # "1.2.3.4-alpha+bugfix"
  version = NuGetVersion.new(1, 2, 3, 4, nil, "bugfix")     # "1.2.3.4+bugfix"
```
  
#### Copy: `NuGetVersion.copy_of`

If you have an existing instance of `NuGetVersion`, you can make another instance with equivalent values by calling the `copy_of` method on the class.

```
  version = ...
  
  version2 = NuGetVersion.copy_of(version)
```

This can be used to convert a `SemanticVersion` (above) to a `NuGetVersion`. In this case, the `revision` component of the `NuGetVersion` will be `0`.

#### Parse: `NuGetVersion.parse`, `NuGetVersion.try_parse`

If you have a version number in string form, you can convert it to a `NuGetVersion` object using one of the parse methods on the class. The method `NuGetVersion.parse` raises an exception if the string is not in a valid format, while `NuGetVersion.try_parse` returns `nil`.

```
  version = NuGetVersion.parse("1.2.3")          # "1.2.3"
  version = NuGetVersion.parse("1.2.3-alpha.4")  # "1.2.3-alpha.4"
  version = NuGetVersion.parse("1.2.3+bugfix")   # "1.2.3+bugfix"
  version = NuGetVersion.parse("1.2.3.4")        # "1.2.3.4"
  version = NuGetVersion.try_parse("1.2.3.4")    # "1.2.3.4"
  version = NuGetVersion.parse("1.2.3.4.5")      # EXCEPTION
  version = NuGetVersion.try_parse("1.2.3.4.5")  # nil
```

### Using

The `NuGetVersion` class exposes its component values as read-only property accessors.

| Property Name    | Description                                                                                                |
| ---------------- | ---------------------------------------------------------------------------------------------------------- |
| `major`          | The major part of the version number - `W.x.y.z`.                                                          |
| `minor`          | The minor part of the version number - `w.X.y.z`.                                                          |
| `patch`          | The patch part of the version number - `w.x.Y.z`.                                                          |
| `revision`       | The revision part of the version number - `w.x.y.Z`.                                                       |
| `release`        | The release label of the version number, as in `alpha.5` for `1.2.3.4-alpha.5`. Can be `nil`.              |
| `release_labels` | The release label of the version number as an array of components, as in `[ 'alpha', '5' ]` for `alpha.5`. |
| `metadata`       | The metadata part of the version number, as in `bugfix` for `1.2.3.4+bugfix`. Can be `nil`.                |

An instance of `NuGetVersion` can be converted to its string representation using the standard `to_s` method.

```
  NuGetVersion.parse("1.2.3-alpha.5+bugfix").to_s # "1.2.3-alpha.5-bugfix"
  NuGetVersion.parse("1.2.3.0-alpha.5+bugfix").to_s # "1.2.3-alpha.5-bugfix"
  NuGetVersion.parse("1.2.3.4-alpha.5+bugfix").to_s # "1.2.3.4-alpha.5-bugfix"
```

Instances of `NuGetVersion` are comparable & orderable.

```
  a = NuGetVersion.parse("1.2.3.4")
  b = NuGetVersion.parse("1.2.3.5")
  
  a < b   # true
  a <= b  # true
  a > b   # false
  a >= b  # false
  a < a   # false
  a <= a  # false
  a == a  # true
  a != a  # false
  a == b  # false
  a != b  # true
  a <=> b # -1
```

Instances of `NuGetVersion` can also be compared directly with instances of `SemanticVersion`.

## Class: `VersionComparer`

This class exists to provide the underlying implementation for the comparison operators on `SemanticVersion` and `NuGetVersion`. All of these operators are driven by a single method `VersionComparer.compare`, which returns the same type of value as the rocket ship operator `<=>`. Logically, its first argument is "subtracted" from its second argument, and if the result is negative, then `compare` returns -1. If the result is positive, `compare` returns +1. If the result is zero (i.e., the arguments have identical values), then `compare` returns 0.

This method can be called directly, and is documented as part of the interface, but in most cases it should be possible to compare instances of `SemanticVersion` and `NuGetVersion` directly, and this usage is preferred.
