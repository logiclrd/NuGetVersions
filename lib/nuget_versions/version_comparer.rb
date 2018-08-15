module NuGetVersions
  class VersionComparer
    class << self
      def compare(a, b)
        return 0 if a.equal? b
        return 1 if b.nil?
        return -1 if a.nil?

        result = 0
        return result if (result = a.major <=> b.major) != 0
        return result if (result = a.minor <=> b.minor) != 0
        return result if (result = a.patch <=> b.patch) != 0

        if a.kind_of?(NuGetVersion) && b.kind_of?(NuGetVersion)
          return result if (result = a.revision <=> b.revision) != 0
        else
          return +1 if a.kind_of?(NuGetVersion) && (a.revision > 0)
          return -1 if b.kind_of?(NuGetVersion) && (b.revision > 0)
        end

        a_labels = a.release_labels || []
        b_labels = b.release_labels || []

        count = [a_labels.length, b_labels.length].max

        for i in 0..(count - 1)
          return +1 if i >= a_labels.length
          return -1 if i >= b_labels.length

          a_release = a_labels[i].to_s
          b_release = b_labels[i].to_s

          a_release_int = Integer(a_release, 10) rescue nil
          b_release_int = Integer(b_release, 10) rescue nil

          if !(a_release_int.nil? || b_release_int.nil?)
            return result if (result = a_release_int <=> b_release_int) != 0
          end

          return +1 if !a_release_int.nil? && b_release_int.nil?
          return -1 if a_release_int.nil? && !b_release_int.nil?

          return result if (result = a_release.casecmp(b_release)) != 0
        end

        return (a.metadata || "").casecmp(b.metadata || "")
      end
    end
  end
end
