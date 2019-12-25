# frozen_string_literal: true

require 'pronto'
require_relative '../../spec_helper'
require 'pronto/punchlist/message_creator'

describe Pronto::Punchlist::MessageCreator do
  let(:message_creator) do
    described_class.new
  end

  describe '#inspect_patch' do
    subject(:message) { message_creator.create(path, line) }

    let(:path) { instance_double(String, 'path') }
    let(:commit_sha) { instance_double(String, 'commit_sha') }
    let(:line) do
      instance_double(Pronto::Git::Line, 'line', commit_sha: commit_sha)
    end

    it 'returns Message subclass' do
      expect(message).to be_instance_of(Pronto::Message)
    end

    it 'contains correct line' do
      expect(message.line).to eq(line)
    end

    it 'contains correct level' do
      expect(message.level).to eq(:warning)
    end

    it 'contains correct path' do
      expect(message.path).to eq(path)
    end

    it 'contains correct commit_sha' do
      expect(message.commit_sha).to eq(commit_sha)
    end

    it 'contains correct runner' do
      expect(message.runner).to eq(Pronto::Punchlist)
    end

    it 'contains correct offense' do
      expect(message.msg).to eq('Uncompleted punchlist item detected--' \
                                'consider resolving or moving this to ' \
                                'your issue tracker')
    end
  end
end
