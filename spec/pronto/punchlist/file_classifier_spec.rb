# frozen_string_literal: true

require 'pronto'
require_relative '../../spec_helper'
require 'pronto/punchlist/file_classifier'

describe Pronto::Punchlist::FileClassifier do
  let(:file_classifier) { described_class.new }

  describe '#is_non_binary?' do
    subject { file_classifier.is_non_binary?(filename) }

    context 'when Ruby' do
      let(:filename) { instance_double(String, 'foo.rb') }

      it { is_expected.to be(true) }
    end

    context 'when Unix executable' do
      let(:filename) { instance_double(String, 'ls') }

      xit { is_expected.to be(false) }
    end

    context 'when DOS executable' do
      let(:filename) { instance_double(String, 'dir.exe') }

      xit { is_expected.to be(false) }
    end

    context 'when Gemfile' do
      let(:filename) { instance_double(String, 'Gemfile') }

      xit { is_expected.to be(true) }
    end

    context 'when Python' do
      let(:filename) { instance_double(String, 'bar.py') }

      xit { is_expected.to be(true) }
    end

    context 'when Markdown' do
      let(:filename) { instance_double(String, 'bar.md') }

      xit { is_expected.to be(true) }
    end
  end
end
