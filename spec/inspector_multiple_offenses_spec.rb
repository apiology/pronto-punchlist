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
    allow(patch).to receive(:new_file_full_path) { filename }
  end

  describe '#inspect' do
    subject { inspector.inspect_patch(patch) }

    before :each do
      expect(punchlist).to receive(:inspect_filename).with(filename) do
        offenses
      end
    end

    let(:patch) { instance_double(Pronto::Git::Patch, 'patch') }

    context 'two offenses in file' do
      let(:offense_1) { double('offense_1') }
      let(:offense_2) { double('offense_2') }
      let(:message_1) { instance_double(Pronto::Message, 'message_1') }
      let(:message_2) { instance_double(Pronto::Message, 'message_2') }
      let(:message_creator_1) do
        instance_double(Pronto::Punchlist::MessageCreator, 'message_creator_1')
      end
      let(:message_creator_2) do
        instance_double(Pronto::Punchlist::MessageCreator, 'message_creator_2')
      end
      let(:offenses) { [offense_1, offense_2] }

      before :each do
        expect(message_creator_class).to receive(:new).with(offense_1) do
          message_creator_1
        end
        expect(message_creator_class).to receive(:new).with(offense_2) do
          message_creator_2
        end
        expect(message_creator_1).to receive(:inspect_patch).with(patch) do
          offense_1_results
        end
        expect(message_creator_2).to receive(:inspect_patch).with(patch) do
          offense_2_results
        end
      end

      context 'and both related to patch' do
        let(:offense_1_results) { message_1 }
        let(:offense_2_results) { message_2 }

        it 'returns both offenses' do
          should eq [message_1, message_2]
        end
      end

      context 'and only first related to patch' do
        let(:offense_1_results) { message_1 }
        let(:offense_2_results) { nil }

        it 'returns only first' do
          should eq [message_1]
        end
      end

      context 'and only second related to patch' do
        let(:offense_1_results) { nil }
        let(:offense_2_results) { message_2 }

        it 'returns only second' do
          should eq [message_2]
        end
      end

      context 'and both unrelated to patch' do
        let(:offense_1_results) { nil }
        let(:offense_2_results) { nil }

        it 'returns nothing' do
          should eq []
        end
      end
    end
  end
end
