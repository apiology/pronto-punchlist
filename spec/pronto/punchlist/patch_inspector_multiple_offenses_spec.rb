# frozen_string_literal: true

require 'pronto'
require_relative '../../spec_helper'
require 'pronto/punchlist/patch_inspector'

describe Pronto::Punchlist::PatchInspector do
  let(:inspector) do
    described_class.new(punchlist_driver: punchlist_driver,
                        offense_matcher_class: offense_matcher_class)
  end
  let(:offense_matcher_class) do
    class_double(Pronto::Punchlist::OffenseMatcher)
  end
  let(:punchlist_driver) do
    instance_double(Pronto::Punchlist::PunchlistDriver,
                    'punchlist_driver')
  end
  let(:patch) { instance_double(Pronto::Git::Patch) }
  let(:filename) { instance_double(String, 'filename') }

  before do
    allow(patch).to receive(:new_file_full_path) { filename }
  end

  describe '#inspect' do
    subject { inspector.inspect_patch(patch) }

    before do
      allow(punchlist_driver).to receive(:inspect_filename).with(filename) do
        offenses
      end
      allow(offense_matcher_class).to receive(:new).with(offense_1) do
        offense_matcher_1
      end
      allow(offense_matcher_class).to receive(:new).with(offense_2) do
        offense_matcher_2
      end
      allow(offense_matcher_1).to receive(:inspect_patch).with(patch) do
        offense_1_results
      end
      allow(offense_matcher_2).to receive(:inspect_patch).with(patch) do
        offense_2_results
      end
    end

    let(:patch) { instance_double(Pronto::Git::Patch, 'patch') }
    let(:offense_1) { instance_double(Punchlist::Offense, 'offense_1') }
    let(:offense_2) { instance_double(Punchlist::Offense, 'offense_2') }
    let(:message_1) { instance_double(Pronto::Message, 'message_1') }
    let(:message_2) { instance_double(Pronto::Message, 'message_2') }
    let(:offense_matcher_1) do
      instance_double(Pronto::Punchlist::OffenseMatcher, 'offense_matcher_1')
    end
    let(:offense_matcher_2) do
      instance_double(Pronto::Punchlist::OffenseMatcher, 'offense_matcher_2')
    end
    let(:offenses) { [offense_1, offense_2] }

    context 'when two_files related to patch' do
      let(:offense_1_results) { message_1 }
      let(:offense_2_results) { message_2 }

      it { is_expected.to eq [message_1, message_2] }
    end

    context 'when only first file related to patch' do
      let(:offense_1_results) { message_1 }
      let(:offense_2_results) { nil }

      it { is_expected.to eq [message_1] }
    end

    context 'when only second file related to patch' do
      let(:offense_1_results) { nil }
      let(:offense_2_results) { message_2 }

      it { is_expected.to eq [message_2] }
    end

    context 'when both files unrelated to patch' do
      let(:offense_1_results) { nil }
      let(:offense_2_results) { nil }

      it { is_expected.to eq [] }
    end
  end
end
