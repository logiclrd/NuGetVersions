require_relative '../lib/nuget_versions.rb'

require 'test/unit'

class SemanticVersionTests < Test::Unit::TestCase
  include NuGetVersions

  def test_copy_of_SemanticVersion
    # Arrange
    x = SemanticVersion.parse "1.2.3-pre.4+build-5"

    assert_equal(1, x.major);
    assert_equal(2, x.minor);
    assert_equal(3, x.patch);
    assert_equal(["pre", "4"], x.release_labels);
    assert_equal("build-5", x.metadata)

    # Act
    y = SemanticVersion.copy_of x

    # Assert
    assert_equal(x.major, y.major)
    assert_equal(x.minor, y.minor)
    assert_equal(x.patch, y.patch)
    assert_equal(x.release_labels, y.release_labels)
    assert_equal(x.release, y.release)
    assert_equal(x.metadata, y.metadata)
  end

  def test_copy_of_NuGetVersion
    # Arrange
    x = NuGetVersion.parse "1.2.3.6-pre.4+build-5"

    assert_equal(1, x.major);
    assert_equal(2, x.minor);
    assert_equal(3, x.patch);
    assert_equal(6, x.revision)
    assert_equal(["pre", "4"], x.release_labels);
    assert_equal("build-5", x.metadata)

    assert_true(x.respond_to? :revision)

    # Act
    y = SemanticVersion.copy_of x

    # Assert
    assert_equal(x.major, y.major)
    assert_equal(x.minor, y.minor)
    assert_equal(x.patch, y.patch)
    assert_equal(x.release_labels, y.release_labels)
    assert_equal(x.release, y.release)
    assert_equal(x.metadata, y.metadata)
    assert_false(y.respond_to? :revision)
  end

  def test_initialize
    # Arrange & Act
    x = SemanticVersion.new(1, 2, 3)
    y = SemanticVersion.new(4, 5, 6, "label.7")
    z = SemanticVersion.new(8, 9, 10, nil, "metadata11")
    w = SemanticVersion.new(12, 13, 14, "label.15", "metadata16")

    # Assert
    assert_equal(1, x.major)
    assert_equal(2, x.minor)
    assert_equal(3, x.patch)
    assert_nil(x.release_labels)
    assert_nil(x.release)
    assert_nil(x.metadata)

    assert_equal(4, y.major)
    assert_equal(5, y.minor)
    assert_equal(6, y.patch)
    assert_equal(["label", "7"], y.release_labels)
    assert_equal("label.7", y.release)
    assert_nil(y.metadata)

    assert_equal(8, z.major)
    assert_equal(9, z.minor)
    assert_equal(10, z.patch)
    assert_nil(z.release_labels)
    assert_nil(z.release)
    assert_equal("metadata11", z.metadata)

    assert_equal(12, w.major)
    assert_equal(13, w.minor)
    assert_equal(14, w.patch)
    assert_equal(["label", "15"], w.release_labels)
    assert_equal("label.15", w.release)
    assert_equal("metadata16", w.metadata)
  end

  def test_assignments
    # Arrange
    x = SemanticVersion.new(1, 2, 3, "test.4", "metadata5")

    # Act & Assert
    assert_equal(1, x.major)
    x.major = 6
    assert_equal(6, x.major)

    assert_equal(2, x.minor)
    x.minor = 7
    assert_equal(7, x.minor)

    assert_equal(3, x.patch)
    x.patch = 8
    assert_equal(8, x.patch)

    assert_equal(["test", "4"], x.release_labels)
    assert_equal("test.4", x.release)
    x.release_labels = nil
    assert_nil(x.release_labels)
    assert_nil(x.release)
    x.release_labels = ["label", "9"]
    assert_equal(["label", "9"], x.release_labels)
    assert_equal("label.9", x.release)

    assert_equal("metadata5", x.metadata)
    x.metadata = nil
    assert_nil(x.metadata)
    x.metadata = "metadata10"
    assert_equal("metadata10", x.metadata)

    assert_equal("6.7.8-label.9+metadata10", x.to_s)
  end

  def test_release_get
    # Arrange
    x = SemanticVersion.parse("1.2.3-pre.4+build5")
    y = SemanticVersion.parse("6.7.8-pre.9")
    z = SemanticVersion.parse("10.11.12+build13")
    w = SemanticVersion.parse("14.15.15")

    # Act & Assert
    assert_equal("pre.4", x.release)
    assert_equal("pre.9", y.release)
    assert_nil(z.release)
    assert_nil(w.release)
  end

  def test_release_set
    # Arrange
    x = SemanticVersion.parse("1.2.3")

    # Act & Assert
    assert_nil(x.release_labels)
    assert_nil(x.release)
    x.release = "test"
    assert_equal(["test"], x.release_labels)
    assert_equal("test", x.release)
    x.release = "label.4"
    assert_equal(["label", "4"], x.release_labels)
    assert_equal("label.4", x.release)
    x.release = nil
    assert_nil(x.release_labels)
    assert_nil(x.release)
  end

  def test_is_prerelease?
    # Arrange
    x = SemanticVersion.parse("1.2.3")
    y = SemanticVersion.parse("4.5.6-label.7")
    z = SemanticVersion.parse("8.9.10+build11")
    w = SemanticVersion.parse("12.13.14-test.15+build16")

    # Act & Assert
    assert_false(x.is_prerelease?)
    assert_true(y.is_prerelease?)
    assert_false(z.is_prerelease?)
    assert_true(w.is_prerelease?)
  end

  def test_has_metadata?
    # Arrange
    x = SemanticVersion.parse("1.2.3")
    y = SemanticVersion.parse("4.5.6-label.7")
    z = SemanticVersion.parse("8.9.10+build11")
    w = SemanticVersion.parse("12.13.14-test.15+build16")

    # Act & Assert
    assert_false(x.has_metadata?)
    assert_false(y.has_metadata?)
    assert_true(z.has_metadata?)
    assert_true(w.has_metadata?)
  end

  def test_to_s
    # Arrange
    x = SemanticVersion.parse("1.2.3")
    y = SemanticVersion.parse("4.5.6-label.7")
    z = SemanticVersion.parse("8.9.10+build11")
    w = SemanticVersion.parse("12.13.14-test.15+build16")

    # Act & Assert
    assert_equal("1.2.3", x.to_s)
    assert_equal("4.5.6-label.7", y.to_s)
    assert_equal("8.9.10+build11", z.to_s)
    assert_equal("12.13.14-test.15+build16", w.to_s)
  end

  def test_equals
    # Arrange
    x = SemanticVersion.parse("1.2.3")
    same = SemanticVersion.new(1, 2, 3, nil, nil)
    different =
      [
        SemanticVersion.parse("1.2.4"),
        SemanticVersion.parse("1.3.3"),
        SemanticVersion.parse("2.2.3"),
        SemanticVersion.parse("2.3.4"),
        SemanticVersion.parse("1.2.3-label"),
        SemanticVersion.parse("1.2.3+metadata"),
        SemanticVersion.parse("1.2.3-label+metadata"),
        SemanticVersion.parse("2.3.4-label"),
        SemanticVersion.parse("2.3.4+metadata"),
        SemanticVersion.parse("2.3.4-label+metadata")
      ]

    # Act & Assert
    assert_true(x == same)
    assert_true(same == x)

    different.each { |v| assert_false(x == v); assert_false(v == x) }
  end

  def test_not_equals
    # Arrange
    x = SemanticVersion.parse("1.2.3")
    same = SemanticVersion.new(1, 2, 3, nil, nil)
    different =
      [
        SemanticVersion.parse("1.2.4"),
        SemanticVersion.parse("1.3.3"),
        SemanticVersion.parse("2.2.3"),
        SemanticVersion.parse("2.3.4"),
        SemanticVersion.parse("1.2.3-label"),
        SemanticVersion.parse("1.2.3+metadata"),
        SemanticVersion.parse("1.2.3-label+metadata"),
        SemanticVersion.parse("2.3.4-label"),
        SemanticVersion.parse("2.3.4+metadata"),
        SemanticVersion.parse("2.3.4-label+metadata")
      ]

    # Act & Assert
    assert_false(x != same)
    assert_false(same != x)

    different.each { |v| assert_true(x != v); assert_true(v != x) }
  end

  def test_less_than
    # Act & Assert
    in_order.each { |v| assert_false(v < v) }

    for x in 0 .. in_order.length-2
      for y in x+1 .. in_order.length-1
        assert_true(in_order[x] < in_order[y], "[#{x}] < [#{y}] => #{in_order[x]} < #{in_order[y]}")
        assert_false(in_order[y] < in_order[x], "[#{x}] < [#{y}] => #{in_order[x]} < #{in_order[y]}")
      end
    end
  end

  def test_greater_than
    # Act & Assert
    in_order.each { |v| assert_false(v > v) }

    for x in 0 .. in_order.length-2
      for y in x+1 .. in_order.length-1
        assert_false(in_order[x] > in_order[y], "[#{x}] > [#{y}] => #{in_order[x]} > #{in_order[y]}")
        assert_true(in_order[y] > in_order[x], "[#{x}] > [#{y}] => #{in_order[x]} > #{in_order[y]}")
      end
    end
  end

  def test_less_than_or_equal
    # Act & Assert
    in_order.each { |v| assert_true(v <= v) }

    for x in 0 .. in_order.length-2
      for y in x+1 .. in_order.length-1
        assert_true(in_order[x] <= in_order[y], "[#{x}] <= [#{y}] => #{in_order[x]} <= #{in_order[y]}")
        assert_false(in_order[y] <= in_order[x], "[#{x}] <= [#{y}] => #{in_order[x]} <= #{in_order[y]}")
      end
    end
  end

  def test_greater_than_or_equal
    # Act & Assert
    in_order.each { |v| assert_true(v >= v) }

    for x in 0 .. in_order.length-2
      for y in x+1 .. in_order.length-1
        assert_false(in_order[x] >= in_order[y], "[#{x}] >= [#{y}] => #{in_order[x]} >= #{in_order[y]}")
        assert_true(in_order[y] >= in_order[x], "[#{x}] >= [#{y}] => #{in_order[x]} >= #{in_order[y]}")
      end
    end
  end

  def test_space_ship
    # Act & Assert
    for x in 0 .. in_order.length-1
      for y in 0 .. in_order.length-1
        assert_equal(x <=> y, in_order[x] <=> in_order[y], "[#{x}] <=> [#{y}] => #{in_order[x]} <=> #{in_order[y]}")
      end
    end
  end

  def test_parse
    # Act
    x = SemanticVersion.parse("1.2.3")
    y = SemanticVersion.parse("4.5.6-label.7")
    z = SemanticVersion.parse("8.9.10+metadata11")
    w = SemanticVersion.parse("12.13.14-label.15+metadata16")

    # Assert
    assert_equal(1, x.major)
    assert_equal(2, x.minor)
    assert_equal(3, x.patch)
    assert_nil(x.release_labels)
    assert_nil(x.release)
    assert_nil(x.metadata)

    assert_equal(4, y.major)
    assert_equal(5, y.minor)
    assert_equal(6, y.patch)
    assert_equal(["label", "7"], y.release_labels)
    assert_equal("label.7", y.release)
    assert_nil(y.metadata)

    assert_equal(8, z.major)
    assert_equal(9, z.minor)
    assert_equal(10, z.patch)
    assert_nil(z.release_labels)
    assert_nil(z.release)
    assert_equal("metadata11", z.metadata)

    assert_equal(12, w.major)
    assert_equal(13, w.minor)
    assert_equal(14, w.patch)
    assert_equal(["label", "15"], w.release_labels)
    assert_equal("label.15", w.release)
    assert_equal("metadata16", w.metadata)
  end

  def test_parse_fail
    # Arrange
    bad_strings =
      [
        "",
        "*",
        "x",
        "1",
        "1.2",
        "1.2.3.4",
        "1.2.3-test*5",
        "1.2.3+build*32",
        "1.2.3+build.4",
        "-test.1",
        "+build.2"
      ]

    # Act & Assert
    bad_strings.each { |str| assert_raise { SemanticVersion.Parse(str) } }
  end

  def test_try_parse
    # Arrange
    bad_strings =
      [
        "",
        "*",
        "x",
        "1",
        "1.2",
        "1.2.3.4",
        "1.2.3-test*5",
        "1.2.3+build*32",
        "1.2.3+build.4",
        "-test.1",
        "+build.2"
      ]

    # Act
    x = SemanticVersion.try_parse("1.2.3")
    y = SemanticVersion.try_parse("4.5.6-label.7")
    z = SemanticVersion.try_parse("8.9.10+metadata11")
    w = SemanticVersion.try_parse("12.13.14-label.15+metadata16")

    parse_fails = bad_strings.map { |str| SemanticVersion.try_parse(str) }

    # Assert
    assert_equal(1, x.major)
    assert_equal(2, x.minor)
    assert_equal(3, x.patch)
    assert_nil(x.release_labels)
    assert_nil(x.release)
    assert_nil(x.metadata)

    assert_equal(4, y.major)
    assert_equal(5, y.minor)
    assert_equal(6, y.patch)
    assert_equal(["label", "7"], y.release_labels)
    assert_equal("label.7", y.release)
    assert_nil(y.metadata)

    assert_equal(8, z.major)
    assert_equal(9, z.minor)
    assert_equal(10, z.patch)
    assert_nil(z.release_labels)
    assert_nil(z.release)
    assert_equal("metadata11", z.metadata)

    assert_equal(12, w.major)
    assert_equal(13, w.minor)
    assert_equal(14, w.patch)
    assert_equal(["label", "15"], w.release_labels)
    assert_equal("label.15", w.release)
    assert_equal("metadata16", w.metadata)

    assert_empty(parse_fails.compact)
  end

private
  def in_order
    @in_order || @in_order =
      [
        SemanticVersion.parse("0.2.3"),
        SemanticVersion.parse("1.1.3"),
        SemanticVersion.parse("1.2.2"),
        SemanticVersion.parse("1.2.3-babel"),
        SemanticVersion.parse("1.2.3-label.5"),
        SemanticVersion.parse("1.2.3-label.6"),
        SemanticVersion.parse("1.2.3-label.6+metadata"),
        SemanticVersion.parse("1.2.3-label"),
        SemanticVersion.parse("1.2.3"),
        SemanticVersion.parse("1.2.4-label")
      ]
  end
end

