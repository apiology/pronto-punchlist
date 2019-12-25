# frozen_string_literal: true

require 'pronto'
require_relative '../../spec_helper'
require 'pronto/punchlist/patch_validator'

describe Pronto::Punchlist::PatchValidator do
  subject { validator.valid_patch?(patch) }

  let(:validator) do
    described_class.new(source_file_globber: source_file_globber)
  end
  # TODO: - do something like this:
  # https://github.com/apiology/quality/blob/master/lib/quality/
  #  linguist_source_file_globber.rb
  # - should I export to its own repo?  Maybe import for now and
  # just test that this calls into that interface?
  let(:source_file_globber) { double('source_file_globber') }
  # let(:source_file_globber) do  # need to fix to include interface I want...
  #  instance_double(SourceFinder::SourceFileGlobber, 'source_file_globber')
  # end
  let(:patch) { instance_double(Pronto::Git::Patch) }
  let(:filename) { instance_double(String, 'filename') }

  before do
    allow(patch).to receive(:new_file_full_path) do
      filename
    end
    allow(patch).to receive(:additions).and_return(additions)
  end

  context 'with an empty patch' do
    let(:additions) { 0 }

    it { is_expected.to be false }
  end

  context 'with a valid file' do
    before do
      allow(source_file_globber).to receive(:is_non_binary?)
        .with(filename) { !file_is_binary }
    end

    let(:additions) { 1 }

    context 'when it is the Ruby language' do
      let(:file_is_binary) { false }

      it { is_expected.to be true }
    end

    context 'when it is binary' do
      let(:file_is_binary) { true }

      before do
        allow(patch).to receive(:patch).and_return('/foo/bar/baz.bin')
      end

      it { is_expected.to be false }
    end

    context 'when it is a markdown file' do
      let(:file_is_binary) { false }

      before do
        allow(patch).to receive(:patch).and_return('/foo/bar/baz.md')
      end

      it { is_expected.to be true }
    end
  end
end
