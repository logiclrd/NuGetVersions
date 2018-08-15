require_relative '../lib/nuget_versions.rb'

require 'test/unit'

class VersionComparerTests < Test::Unit::TestCase
  include NuGetVersions

  def test_compare
    # Arrange
    versions =
      [
        [ NuGetVersion.parse("0.0.0.0"), SemanticVersion.parse("0.0.0") ],
        [ NuGetVersion.parse("0.0.0.1") ],
        [ NuGetVersion.parse("0.0.1.0"), SemanticVersion.parse("0.0.1") ],
        [ NuGetVersion.parse("0.0.2.0-label.1"), SemanticVersion.parse("0.0.2-label.1") ],
        [ NuGetVersion.parse("0.0.2.0-label"), SemanticVersion.parse("0.0.2-label") ],
        [ NuGetVersion.parse("0.0.2.0"), SemanticVersion.parse("0.0.2") ],
        [ NuGetVersion.parse("0.0.2.0+metadata"), SemanticVersion.parse("0.0.2+metadata") ],
        [ NuGetVersion.parse("0.0.2.1+metadata") ],
        [ NuGetVersion.parse("0.0.2.2") ],
        [ NuGetVersion.parse("0.0.2.3-label.2") ],
        [ NuGetVersion.parse("0.0.2.4-label.2.3") ],
        [ NuGetVersion.parse("0.0.2.5-label.2.3") ],
        [ NuGetVersion.parse("0.1.0-label"), SemanticVersion.parse("0.1.0-label") ],
        [ NuGetVersion.parse("0.1.1-babel"), SemanticVersion.parse("0.1.1-babel") ],
        [ NuGetVersion.parse("0.1.1-label"), SemanticVersion.parse("0.1.1-label") ],
        [ NuGetVersion.parse("0.1.1"), SemanticVersion.parse("0.1.1") ],
        [ NuGetVersion.parse("0.2.0"), SemanticVersion.parse("0.2.0") ],
        [ NuGetVersion.parse("0.2.0.1") ],
        [ NuGetVersion.parse("0.3.0"), SemanticVersion.parse("0.3.0") ],
        [ NuGetVersion.parse("0.3.0+metadata"), SemanticVersion.parse("0.3.0+metadata") ],
        [ NuGetVersion.parse("1.0.0"), SemanticVersion.parse("1.0.0") ],
        [ NuGetVersion.parse("1.0.0.1-label") ],
        [ NuGetVersion.parse("1.0.0.1") ],
        [ NuGetVersion.parse("1.0.0.2-label") ],
        [ NuGetVersion.parse("1.0.1"), SemanticVersion.parse("1.0.1") ],
        [ NuGetVersion.parse("1.1.0"), SemanticVersion.parse("1.1.0") ],
        [ NuGetVersion.parse("1.1.1"), SemanticVersion.parse("1.1.1") ]
      ]

    for x in 0 .. versions.length-1
      for y in 0 .. versions.length - 1
        for z in 0 .. versions[x].length - 1
          for w in 0 .. versions[y].length - 1
            assert_equal(x <=> y, VersionComparer.compare(versions[x][z], versions[y][w]), "Comparing #{versions[x][z]} with #{versions[y][w]}, expected order #{x <=> y}")
          end
        end
      end
    end
  end
end
