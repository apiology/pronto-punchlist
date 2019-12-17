# frozen_string_literal: true

require 'pronto'
require_relative 'spec_helper'
require 'pronto/punchlist/inspector'

describe Pronto::Punchlist::PatchInspector do
  let(:inspector) do
    Pronto::Punchlist::PatchInspector
      .new(punchlist: punchlist,
           message_creator_class: message_creator_class)
  end
  let(:message_creator_class) do
    class_double(Pronto::Punchlist::MessageCreator)
  end
  let(:punchlist) { double('punchlist') }
  let(:patch) { double('patch') }
  let(:filename) { double('filename') }
  before :each do
    allow(patch).to receive(:new_file_full_path) do
      filename
    end
  end

  describe '#inspect' do
    subject { inspector.inspect_patch(patch) }

    before :each do
      expect(punchlist).to receive(:inspect_filename).with(filename) do
        offenses
      end
    end

    let(:patch) { instance_double(Pronto::Git::Patch) }

    context 'no offenses are in file' do
      let(:offenses) { [] }
      it 'returns nothing' do
        should eq []
      end
    end

    context 'one offense in file' do
      let(:offense) { double('offense') }
      let(:offenses) { [offense] }
      let(:message_creator) { instance_double(Pronto::Punchlist::MessageCreator) }
      before :each do
        expect(message_creator_class).to receive(:new).with(offense) do
          message_creator
        end
        expect(message_creator).to receive(:inspect_patch).with(patch) do
          message
        end
      end

      context 'and related to patch' do
        let(:message) { instance_double(Pronto::Message) }

        it 'returns message' do
          should eq [message]
        end
      end

      context 'and unrelated to patch' do
        let(:offense_line) { after_end_of_change_line }
        let(:message) { nil }

        it 'returns nothing' do
          should eq []
        end
      end
    end
  end
end
