# frozen_string_literal: true

require 'pronto'
require_relative '../../spec_helper'
require 'pronto/punchlist/patch_validator'

describe Pronto::Punchlist::PatchValidator do
  subject { validator.valid_patch?(patch) }

  let(:validator) do
    described_class.new(file_classifier: file_classifier)
  end
  let(:file_classifier) do
    instance_double(Pronto::Punchlist::FileClassifier, 'file_classifier')
  end
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
      allow(file_classifier).to receive(:non_binary?)
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
