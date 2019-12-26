# frozen_string_literal: true

require 'pronto'
require_relative '../../spec_helper'
require 'pronto/punchlist/file_classifier'

describe Pronto::Punchlist::FileClassifier do
  let(:file_classifier) { described_class.new }

  describe '#non_binary?' do
    subject { file_classifier.non_binary?(filename) }

    context 'when Ruby' do
      let(:filename) { 'foo.rb' }

      it { is_expected.to be(true) }
    end

    context 'when Unix executable' do
      let(:filename) { 'ls' }

      it { is_expected.to be(false) }
    end

    context 'when differnet Ruby file' do
      let(:filename) { 'foo.rb' }

      it { is_expected.to be(true) }
    end

    context 'when DOS executable' do
      let(:filename) { 'dir.exe' }

      it { is_expected.to be(false) }
    end

    context 'when Rakefile' do
      let(:filename) { 'Rakefile' }

      it { is_expected.to be(true) }
    end

    context 'when Python' do
      let(:filename) { 'bar.py' }

      it { is_expected.to be(true) }
    end

    context 'when Markdown' do
      let(:filename) { 'bar.md' }

      it { is_expected.to be(true) }
    end
  end
end
