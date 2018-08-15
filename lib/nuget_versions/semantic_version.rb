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
      @major = Integer(major, major.is_a?(String) ? 10 : 0)
      @minor = Integer(minor, minor.is_a?(String) ? 10 : 0)
      @patch = Integer(patch, patch.is_a?(String) ? 10 : 0)

      if !release_labels.nil?
        release_labels = release_labels.to_s.split('.') if !release_labels.kind_of? Array
        SemanticVersion.validate_identifiers release_labels
        @release_labels = release_labels
      end

      SemanticVersion.validate_identifier metadata if !metadata.nil?
      @metadata = metadata
    end

    attr_reader :major
    attr_reader :minor
    attr_reader :patch
    attr_reader :release_labels
    attr_reader :metadata

    def major=(new_value)
      @major = Integer(new_value, new_value.is_a?(String) ? 10 : 0)
    end

    def minor=(new_value)
      @minor = Integer(new_value, new_value.is_a?(String) ? 10 : 0)
    end

    def patch=(new_value)
      @patch = Integer(new_value, new_value.is_a?(String) ? 10 : 0)
    end

    def release_labels=(new_value)
      return @release_labels = nil if new_value.nil?
      new_value = new_value.to_s.split('.') if !new_value.kind_of? Array
      SemanticVersion.validate_identifiers new_value
      @release_labels = new_value
    end

    def metadata=(new_value)
      return @metadata = nil if new_value.nil?
      SemanticVersion.validate_identifier new_value
      @metadata = new_value
    end

    def release
      return nil if @release_labels.nil?
      @release_labels.join('.')
    end

    def release=(new_value)
      return @release_labels = nil if new_value.nil?
      new_value = new_value.split('.')
      SemanticVersion.validate_identifiers new_value
      @release_labels = new_value
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

      return nil if value.empty?

      value = value.split("+", 2)

      metadata = (value.length == 2) ? value.last : nil

      value = value.first.split("-", 2)

      return nil if value.empty?

      release_labels = (value.length == 2) ? value.last.split('.') : nil

      parts = value.first.split(".")

      return nil if parts.length != 3
      return nil if release_labels && !SemanticVersion.try_validate_identifiers(release_labels)
      return nil if metadata && !SemanticVersion.try_validate_identifier(metadata)

      begin
        major = Integer(parts[0], 10)
        minor = (parts.length >= 2) ? Integer(parts[1], 10) : 0
        patch = (parts.length >= 3) ? Integer(parts[2], 10) : 0
      rescue
        return nil
      end

      return SemanticVersion.new(major, minor, patch, release_labels, metadata)
    end

  protected
    def self.validate_identifiers(array)
      array.each { |identifier| validate_identifier(identifier) }
    end

    def self.validate_identifier(identifier)
      raise "Invalid semantic version identifier: #{identifier}" if !try_validate_identifier(identifier)
    end

    def self.try_validate_identifiers(array)
      array.all? { |identifier| try_validate_identifier(identifier) }
    end

    def self.try_validate_identifier(identifier)
      return identifier.count("^A-Za-z0-9-").zero?
    end
  end
end
