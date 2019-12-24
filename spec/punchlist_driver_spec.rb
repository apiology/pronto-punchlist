# frozen_string_literal: true

require 'pronto'
require_relative 'spec_helper'
require 'pronto/punchlist/driver'
require 'punchlist'

describe Pronto::Punchlist::PunchlistDriver do
  let(:punchlist) { instance_double(Punchlist::Punchlist, 'punchlist') }
  let(:punchlist_driver) do
    Pronto::Punchlist::PunchlistDriver.new(punchlist: punchlist)
  end

  describe '#inspect_filename' do
    let(:path) { instance_double(String, 'path') }
  #   let(:commit_sha) { instance_double(String, 'commit_sha') }
  #   let(:line) do
  #     instance_double(Pronto::Git::Line, 'line', commit_sha: commit_sha)
    #   end

    before :each do
      expect(punchlist).to receive(:look_for_punchlist_items).with(path) do
        punchlist_response
      end
    end

    subject { punchlist_driver.inspect_filename(path) }

    context 'with no errors' do
      let(:punchlist_response) do
        []
      end

      it 'does not blow up' do
        expect { subject }.to_not raise_error
      end

      xit 'returns correct response'
    end

    context 'with one error' do
      let(:punchlist_response) do
        []
      end

      it 'does not blow up' do
        expect { subject }.to_not raise_error
      end

      xit 'returns correct response'
    end

    context 'with two errors' do
      let(:punchlist_response) do
        []
      end

      it 'does not blow up' do
        expect { subject }.to_not raise_error
      end

      xit 'returns correct response'
    end

    # TODO: Release new version of punchlist - after making sure circleci shows error

  #   it 'returns Message subclass' do
  #     should be_instance_of(Pronto::Message)
  #   end

  #   it 'contains correct line' do
  #     expect(subject.line).to eq(line)
  #   end

  #   it 'contains correct level' do
  #     expect(subject.level).to eq(:warning)
  #   end

  #   it 'contains correct path' do
  #     expect(subject.path).to eq(path)
  #   end

  #   it 'contains correct commit_sha' do
  #     expect(subject.commit_sha).to eq(commit_sha)
  #   end

  #   it 'contains correct runner' do
  #     expect(subject.runner).to eq(Pronto::Punchlist)
  #   end

  #   it 'contains correct offense' do
  #     expect(subject.msg).to eq('Uncompleted punchlist item detected -' \
  #                               'consider resolving or moving this to ' \
  #                               'your issue tracker')
  #   end
  end
end
