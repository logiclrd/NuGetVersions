require_relative '../lib/nuget_versions.rb'

require 'test/unit'

class NuGetVersionTests < Test::Unit::TestCase
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
    y = NuGetVersion.copy_of x

    # Assert
    assert_equal(x.major, y.major)
    assert_equal(x.minor, y.minor)
    assert_equal(x.patch, y.patch)
    assert_equal(x.release_labels, y.release_labels)
    assert_equal(x.release, y.release)
    assert_equal(x.metadata, y.metadata)

    assert_equal(0, y.revision)
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

    # Act
    y = NuGetVersion.copy_of x

    # Assert
    assert_equal(x.major, y.major)
    assert_equal(x.minor, y.minor)
    assert_equal(x.patch, y.patch)
    assert_equal(x.revision, y.revision)
    assert_equal(x.release_labels, y.release_labels)
    assert_equal(x.release, y.release)
    assert_equal(x.metadata, y.metadata)
  end

  def test_initialize
    # Arrange & Act
    x = NuGetVersion.new(1, 2, 3)
    y = NuGetVersion.new(4, 5, 6, 7)
    z = NuGetVersion.new(8, 9, 10, 11, "label.12")
    w = NuGetVersion.new(13, 14, 15, 16, nil, "metadata17")
    v = NuGetVersion.new(18, 19, 20, 21, "label.22", "metadata23")

    # Assert
    assert_equal(1, x.major)
    assert_equal(2, x.minor)
    assert_equal(3, x.patch)
    assert_equal(0, x.revision)
    assert_nil(x.release_labels)
    assert_nil(x.release)
    assert_nil(x.metadata)

    assert_equal(4, y.major)
    assert_equal(5, y.minor)
    assert_equal(6, y.patch)
    assert_equal(7, y.revision)
    assert_nil(y.release_labels)
    assert_nil(y.release)
    assert_nil(y.metadata)

    assert_equal(8, z.major)
    assert_equal(9, z.minor)
    assert_equal(10, z.patch)
    assert_equal(11, z.revision)
    assert_equal(["label", "12"], z.release_labels)
    assert_equal("label.12", z.release)
    assert_nil(z.metadata)

    assert_equal(13, w.major)
    assert_equal(14, w.minor)
    assert_equal(15, w.patch)
    assert_equal(16, w.revision)
    assert_nil(w.release_labels)
    assert_nil(w.release)
    assert_equal("metadata17", w.metadata)

    assert_equal(18, v.major)
    assert_equal(19, v.minor)
    assert_equal(20, v.patch)
    assert_equal(21, v.revision)
    assert_equal(["label", "22"], v.release_labels)
    assert_equal("label.22", v.release)
    assert_equal("metadata23", v.metadata)
  end

  def test_assignments
    # Arrange
    x = NuGetVersion.new(1, 2, 3, 4, "test.5", "metadata6")

    # Act & Assert
    assert_equal(1, x.major)
    x.major = 7
    assert_equal(7, x.major)

    assert_equal(2, x.minor)
    x.minor = 8
    assert_equal(8, x.minor)

    assert_equal(3, x.patch)
    x.patch = 9
    assert_equal(9, x.patch)

    assert_equal(4, x.revision)
    x.revision = 10
    assert_equal(10, x.revision)

    assert_equal(["test", "5"], x.release_labels)
    assert_equal("test.5", x.release)
    x.release_labels = nil
    assert_nil(x.release_labels)
    assert_nil(x.release)
    x.release_labels = ["label", "11"]
    assert_equal(["label", "11"], x.release_labels)
    assert_equal("label.11", x.release)

    assert_equal("metadata6", x.metadata)
    x.metadata = nil
    assert_nil(x.metadata)
    x.metadata = "metadata12"
    assert_equal("metadata12", x.metadata)

    assert_equal("7.8.9.10-label.11+metadata12", x.to_s)
  end

  def test_original_version
    # Arrange
    strings =
      [
        "1.2.3",
        "1.2.3.4",
        "5.6.7-label.9",
        "5.6.7.0-label.9",
        "5.6.7.8-label.9",
        "10.11.12+build13",
        "14.15.16.17-label18+build19"
      ]

    # Act & Assert
    strings.each { |str| assert_equal(str, NuGetVersion.parse(str).original_version) }

    refute_empty(strings.select { |str| NuGetVersion.copy_of(NuGetVersion.parse(str)).to_s != str })
  end

  def test_to_s
    # Arrange
    strings =
      [
        "1.2.3",
        "1.2.3.4",
        "5.6.7-label.9",
        "5.6.7.0-label.9",
        "5.6.7.8-label.9",
        "10.11.12+build13",
        "14.15.16.17-label18+build19"
      ]

    # Act & Assert
    strings.each { |str| assert_equal(str, NuGetVersion.parse(str).to_s) }
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
    x = NuGetVersion.parse("1.2.3")
    same = NuGetVersion.new(1, 2, 3, 0, nil, nil)
    different =
      [
        NuGetVersion.parse("1.2.3.4"),
        NuGetVersion.parse("1.2.4"),
        NuGetVersion.parse("1.3.3"),
        NuGetVersion.parse("2.2.3"),
        NuGetVersion.parse("2.3.4"),
        NuGetVersion.parse("1.2.3-label"),
        NuGetVersion.parse("1.2.3+metadata"),
        NuGetVersion.parse("1.2.3-label+metadata"),
        NuGetVersion.parse("2.3.4-label"),
        NuGetVersion.parse("2.3.4+metadata"),
        NuGetVersion.parse("2.3.4-label+metadata")
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
    # Arrange
    tests = parse_tests

    # Act
    tests.each do |test|
      if test.include? :s
        test[:parsed] = NuGetVersion.parse(test[:s])
      elsif test.include? :f
        begin
          test[:parsed] = NuGetVersion.parse(test[:f])
        rescue StandardError => e
          test[:parse_error] = e
        end
      else
        raise "Invalid parse test definition, does not contain :s or :f"
      end
    end

    # Assert
    tests.each do |test|
      if test.include? :s
        assert_equal(test[:major], test[:parsed].major)
        assert_equal(test[:minor], test[:parsed].minor)
        assert_equal(test[:patch], test[:parsed].patch)
        assert_equal(test[:revision], test[:parsed].revision)

        if test.include? :release
          assert_equal(test[:release].split('.'), test[:parsed].release_labels)
          assert_equal(test[:release], test[:parsed].release)
        else
          assert_nil(test[:parsed].release_labels)
          assert_nil(test[:parsed].release)
        end

        if test.include? :metadata
          assert_equal(test[:metadata], test[:parsed].metadata)
        else
          assert_nil(test[:metadata])
        end

        assert_equal(test[:s], test[:parsed].original_version)
      elsif test.include? :f
        assert_false(test.include?(:parsed), "Appears to have parsed: #{test[:f]}")
        assert_true(test.include? :parse_error)
      end
    end
  end

  def test_try_parse
    # Arrange
    tests = parse_tests

    # Act
    tests.each do |test|
      if test.include? :s
        test[:parsed] = NuGetVersion.try_parse(test[:s])
      elsif test.include? :f
        begin
          test[:parsed] = NuGetVersion.try_parse(test[:f])
        rescue StandardError => e
          test[:parse_error] = e
        end
      else
        raise "Invalid parse test definition, does not contain :s or :f"
      end
    end

    # Assert
    tests.each do |test|
      if test.include? :s
        assert_equal(test[:major], test[:parsed].major)
        assert_equal(test[:minor], test[:parsed].minor)
        assert_equal(test[:patch], test[:parsed].patch)
        assert_equal(test[:revision], test[:parsed].revision)

        if test.include? :release
          assert_equal(test[:release].split('.'), test[:parsed].release_labels)
          assert_equal(test[:release], test[:parsed].release)
        else
          assert_nil(test[:parsed].release_labels)
          assert_nil(test[:parsed].release)
        end

        if test.include? :metadata
          assert_equal(test[:metadata], test[:parsed].metadata)
        else
          assert_nil(test[:metadata])
        end

        assert_equal(test[:s], test[:parsed].original_version)
      elsif test.include? :f
        assert_false(test.include?(:parse_error), "Exception raised parsing bad value: #{test[:f]}\n#{test[:parse_error]}")
        assert_true(test.include? :parsed)
        assert_nil(test[:parsed])
      end
    end
  end

private
  def in_order
    @in_order || @in_order =
      [
        NuGetVersion.parse("0.2.3"),
        NuGetVersion.parse("0.2.3.4"),
        NuGetVersion.parse("1.1.3.4"),
        NuGetVersion.parse("1.2.2.4"),
        NuGetVersion.parse("1.2.3.4-babel"),
        NuGetVersion.parse("1.2.3.4-label.5"),
        NuGetVersion.parse("1.2.3.4-label.6"),
        NuGetVersion.parse("1.2.3.4-label.6+metadata"),
        NuGetVersion.parse("1.2.3.4-label"),
        NuGetVersion.parse("1.2.3.4"),
        NuGetVersion.parse("1.2.3.5-label")
      ]
  end

  def parse_tests
    [
      { :s => "1.2", :major => 1, :minor => 2, :patch => 0, :revision => 0 },
      { :s => "1.2.3", :major => 1, :minor => 2, :patch => 3, :revision => 0 },
      { :s => "1.2.3.4", :major => 1, :minor => 2, :patch => 3, :revision => 4 },
      { :s => "5.6.7-label.9", :major => 5, :minor => 6, :patch => 7, :revision => 0, :release => "label.9" },
      { :s => "5.6.7.0-label.9", :major => 5, :minor => 6, :patch => 7, :revision => 0, :release => "label.9" },
      { :s => "5.6.7.8-label.9", :major => 5, :minor => 6, :patch => 7, :revision => 8, :release => "label.9" },
      { :s => "10.11.12+build13", :major => 10, :minor => 11, :patch => 12, :revision => 0, :metadata => "build13" },
      { :s => "14.15.16.17-label18+build19", :major => 14, :minor => 15, :patch => 16, :revision => 17, :release => "label18", :metadata => "build19" },

      { :f => "" },
      { :f => "*" },
      { :f => "x" },
      { :f => "1" },
      { :f => "1.2.3.4.5" },
      { :f => "1.2.3-test*5" },
      { :f => "1.2.3+build*32" },
      { :f => "1.2.3+build.4" },
      { :f => "-test.1" },
      { :f => "+build.2" }
    ]
  end
end

