module NuGetVersions
  class NuGetVersion < SemanticVersion
    # Creates a NuGetVersion from an existing NuGetVersion
    # Parameters:
    # - version: Version to clone.
    def self.copy_of(version)
      revision = 0
      revision = version.revision if version.respond_to? :revision

      return NuGetVersion.new(version.major, version.minor, version.patch, revision, version.release_labels, version.metadata)
    end

    # Creates a NuGetVersion X.Y.Z, X.Y.Z-alpha, X.Y.Z-alpha+metadata, W.X.Y.Z, W.X.Y.Z-alpha, W.X.Y.Z-alpha+metadata.
    # Parameters:
    # - major: W.x.y.z
    # - minor: w.X.y.z
    # - patch: w.x.Y.z
    # - revision: w.x.y.Z
    # - release_labels: Prerelease label
    # - metadata: Build metadata
    def initialize(major, minor, patch, revision = 0, release_labels = nil, metadata = nil)
      super(major, minor, patch, release_labels, metadata)

      @revision = Integer(revision, revision.is_a?(String) ? 10 : 0)
    end

    attr_reader :revision

    def revision=(new_value)
      @revision = Integer(new_value, new_value.is_a?(String) ? 10 : 0)
    end

    attr_accessor :original_version

    def to_s
      return @original_version if !@original_version.nil? && !@original_version.empty?

      version = "#{@major}.#{@minor}.#{@patch}"
      version += ".#{@revision}" if revision != 0
      version += "-#{release}" if is_prerelease?
      version += "+#{metadata}" if has_metadata?

      version
    end

    def self.parse(value)
      ver = self.try_parse(value)
      raise "Invalid NuGet version value" if ver.nil?

      ver
    end

    def self.try_parse(value)
      return nil if value.nil?

      value = value.to_s if !value.is_a? String
      original_value = value

      return nil if value.empty?

      value = value.split("+", 2)

      metadata = (value.length == 2) ? value.last : nil

      value = value.first.split("-", 2)

      return nil if value.empty?

      release_labels = (value.length == 2) ? value.last.split('.') : nil

      parts = value.first.split(".")

      return nil if parts.length < 2 || parts.length > 4
      return nil if release_labels && !SemanticVersion.try_validate_identifiers(release_labels)
      return nil if metadata && !SemanticVersion.try_validate_identifier(metadata)

      begin
        major = Integer(parts[0], 10)
        minor = (parts.length >= 2) ? Integer(parts[1], 10) : 0
        patch = (parts.length >= 3) ? Integer(parts[2], 10) : 0
        revision = (parts.length >= 4) ? Integer(parts[3], 10) : 0
      rescue
        return nil
      end

      ver = NuGetVersion.new(major, minor, patch, revision, release_labels, metadata)
      ver.original_version = original_value

      ver
    end
  end
end
