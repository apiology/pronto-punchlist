# frozen_string_literal: true

require 'pronto'
require_relative '../../spec_helper'
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
  before do
    allow(patch).to receive(:new_file_full_path) do
      filename
    end
  end

  describe '#inspect' do
    subject { inspector.inspect_patch(patch) }

    before do
      expect(punchlist_driver).to receive(:inspect_filename).with(filename) do
        offenses
      end
    end

    let(:patch) { instance_double(Pronto::Git::Patch) }

    context 'when no offenses are in file' do
      let(:offenses) { [] }
      it 'returns nothing' do
        should eq []
      end
    end

    context 'when one offense in file' do
      let(:offense) { double('offense') }
      let(:offenses) { [offense] }
      let(:offense_matcher) do
        instance_double(Pronto::Punchlist::OffenseMatcher)
      end
      before do
        expect(offense_matcher_class).to receive(:new).with(offense) do
          offense_matcher
        end
        expect(offense_matcher).to receive(:inspect_patch).with(patch) do
          message
        end
      end

      context 'and related to patch' do
        let(:message) { instance_double(Pronto::Message) }

        it 'returns message' do
          should eq [message]
        end
      end

      context 'when unrelated to patch' do
        let(:offense_line) { after_end_of_change_line }
        let(:message) { nil }

        it 'returns nothing' do
          should eq []
        end
      end
    end
  end
end
