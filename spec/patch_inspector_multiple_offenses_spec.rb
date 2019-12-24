# frozen_string_literal: true

require 'pronto'
require_relative 'spec_helper'
require 'pronto/punchlist/patch_inspector'

describe Pronto::Punchlist::PatchInspector do
  let(:inspector) do
    Pronto::Punchlist::PatchInspector
      .new(punchlist_driver: punchlist_driver,
           offense_matcher_class: offense_matcher_class)
  end
  let(:offense_matcher_class) do
    class_double(Pronto::Punchlist::OffenseMatcher)
  end
  let(:punchlist_driver) do
    instance_double(Pronto::Punchlist::PunchlistDriver,
                    'punchlist_driver')
  end
  let(:patch) { double('patch') }
  let(:filename) { double('filename') }
  before :each do
    allow(patch).to receive(:new_file_full_path) { filename }
  end

  describe '#inspect' do
    subject { inspector.inspect_patch(patch) }

    before :each do
      expect(punchlist_driver).to receive(:inspect_filename).with(filename) do
        offenses
      end
    end

    let(:patch) { instance_double(Pronto::Git::Patch, 'patch') }

    context 'two offenses in file' do
      let(:offense_1) { double('offense_1') }
      let(:offense_2) { double('offense_2') }
      let(:message_1) { instance_double(Pronto::Message, 'message_1') }
      let(:message_2) { instance_double(Pronto::Message, 'message_2') }
      let(:offense_matcher_1) do
        instance_double(Pronto::Punchlist::OffenseMatcher, 'offense_matcher_1')
      end
      let(:offense_matcher_2) do
        instance_double(Pronto::Punchlist::OffenseMatcher, 'offense_matcher_2')
      end
      let(:offenses) { [offense_1, offense_2] }

      before :each do
        expect(offense_matcher_class).to receive(:new).with(offense_1) do
          offense_matcher_1
        end
        expect(offense_matcher_class).to receive(:new).with(offense_2) do
          offense_matcher_2
        end
        expect(offense_matcher_1).to receive(:inspect_patch).with(patch) do
          offense_1_results
        end
        expect(offense_matcher_2).to receive(:inspect_patch).with(patch) do
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
