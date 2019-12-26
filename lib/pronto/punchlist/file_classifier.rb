# frozen_string_literal: true

module Pronto
  class Punchlist < Runner
    class FileClassifier
      def initialize(source_file_globber: SourceFinder::SourceFileGlobber.new)
        @source_file_globber = source_file_globber
      end

      def is_non_binary?(path)
        # https://ruby-doc.org/core-2.5.1/File.html#method-c-fnmatch
        # EXTGLOB enables ',' as part of glob language
        File.fnmatch?(@source_file_globber.source_and_doc_files_glob,
                      path,
                      File::FNM_EXTGLOB)
      end
    end
  end
end
