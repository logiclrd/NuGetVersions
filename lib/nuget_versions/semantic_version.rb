module NuGetVersions
  # A strict SemVer implementation
  # Based on: NuGet.Client/NuGet.Core/NuGet.Versioning/SemanticVersion.cs from the NuGet source code.
  class SemanticVersion
    # Creates a SemanticVersion from an existing SemanticVersion
    # Parameters:
    # - version: Version to clone.
    def self.copy_of(version)
      return SemanticVersion.new(version.major, version.minor, version.patch, version.release_labels, version.metadata)
    end

    # Creates a SemanticVersion X.Y.Z, X.Y.Z-alpha, X.Y.Z-alpha+metadata.
    # Parameters:
    # - major: X.y.z
    # - minor: x.Y.z
    # - patch: x.y.Z
    # - release_labels: Prerelease label
    # - metadata: Build metadata
    def initialize(major, minor, patch, release_labels = nil, metadata = nil)
      @major = major
      @minor = minor
      @patch = patch

      if !release_labels.nil?
        release_labels = release_labels.to_s.split('.') if !release_labels.kind_of? Array
        @release_labels = release_labels
      end

      @metadata = metadata
    end

    attr_reader :major
    attr_reader :minor
    attr_reader :patch
    attr_reader :release_labels
    attr_reader :metadata

    def release
      return "" if @release_labels.nil?
      @release_labels.join('.')
    end

    def is_prerelease?
      !@release_labels.nil? && !@release_labels.all?(&:empty?)
    end

    def has_metadata?
      !@metadata.nil? && !@metadata.empty?
    end

    def to_s
      version = "#{@major}.#{@minor}.#{@patch}"
      version += "-#{release}" if is_prerelease?
      version += "+#{metadata}" if has_metadata?

      version
    end

    def ==(other)
      VersionComparer.compare(self, other) == 0
    end

    def !=(other)
      !(self == other)
    end

    def <(other)
      VersionComparer.compare(self, other) == -1
    end

    def >(other)
      other < self
    end

    def <=(other)
      !(other < self)
    end

    def >=(other)
      !(self < other)
    end

    def <=>(other)
      VersionComparer.compare(self, other)
    end

    def self.parse(value)
      ver = self.try_parse(value)
      raise "Invalid semantic version value" if ver.nil?

      ver
    end

    def self.try_parse(value)
      return nil if value.nil?

      value = value.to_s if !value.is_a? String

      value = value.split("+", 2)

      metadata = (value.length == 2) ? value.last : nil

      value = value.first.split("-", 2)

      release_labels = (value.length == 2) ? value.last : nil

      parts = value.first.split(".")

      return nil if value.length > 3

      begin
        major = Integer(parts[0])
        minor = (parts.length >= 2) ? Integer(parts[1]) : 0
        patch = (parts.length >= 3) ? Integer(parts[2]) : 0
      rescue
        return nil
      end

      return SemanticVersion.new(major, minor, patch, release_labels, metadata)
    end
  end
end
