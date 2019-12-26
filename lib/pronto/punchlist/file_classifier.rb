module Pronto
  class Punchlist < Runner
    class FileClassifier
      def initialize(source_file_globber: SourceFinder::SourceFileGlobber.new)
      end

      def is_non_binary?(filename)
        # parse extension out
        # check extension against list in source_file_globber
        # https://ruby-doc.org/core-2.5.1/File.html#method-c-fnmatch
        true
      end
    end
  end
end
