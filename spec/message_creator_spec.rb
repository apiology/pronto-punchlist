# frozen_string_literal: true

require 'pronto'
require_relative 'spec_helper'
require 'pronto/punchlist/inspector'

describe Pronto::Punchlist::MessageCreator do
  let(:message_creator) do
    Pronto::Punchlist::MessageCreator.new
  end

  describe '#inspect_patch' do
    let(:path) { instance_double(String, 'path') }
    let(:commit_sha) { instance_double(String, 'commit_sha') }
    let(:line) do
      instance_double(Pronto::Git::Line, 'line', commit_sha: commit_sha)
    end

    subject { message_creator.create(path, line) }

    it 'returns offense' do
      expect(subject.line).to eq line
    end

    it 'returns Message subclass' do
      should be_instance_of(Pronto::Message)
    end

    it 'contains correct line' do
      expect(subject.line).to eq(line)
    end

    it 'contains correct level' do
      expect(subject.level).to eq(:warning)
    end

    it 'contains correct path' do
      expect(subject.path).to eq(path)
    end

    it 'contains correct commit_sha' do
      expect(subject.commit_sha).to eq(commit_sha)
    end

    it 'contains correct runner' do
      expect(subject.runner).to eq(Pronto::Punchlist)
    end

    it 'contains correct offense' do
      expect(subject.msg).to eq('Uncompleted punchlist item detected -' \
                                'consider resolving or moving this to ' \
                                'your issue tracker')
    end
  end
end
