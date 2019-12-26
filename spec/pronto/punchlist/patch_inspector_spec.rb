# frozen_string_literal: true

require 'pronto'
require_relative '../../spec_helper'
require 'pronto/punchlist/patch_inspector'

describe Pronto::Punchlist::PatchInspector do
  subject { inspector.inspect_patch(patch) }

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
    allow(patch).to receive(:new_file_full_path) do
      filename
    end
    allow(punchlist_driver).to receive(:inspect_filename).with(filename) do
      offenses
    end
  end

  context 'when no offenses are in file' do
    let(:offenses) { [] }

    it { is_expected.to eq [] }
  end

  context 'when one offense in file' do
    let(:offense) { instance_double(Punchlist::Offense, 'offense') }
    let(:offenses) { [offense] }
    let(:offense_matcher) do
      instance_double(Pronto::Punchlist::OffenseMatcher)
    end

    before do
      allow(offense_matcher_class).to receive(:new).with(offense) do
        offense_matcher
      end
      allow(offense_matcher).to receive(:inspect_patch).with(patch) do
        message
      end
    end

    context 'when related to patch' do
      let(:message) { instance_double(Pronto::Message) }

      it { is_expected.to eq [message] }
    end

    context 'when unrelated to patch' do
      let(:offense_line) { after_end_of_change_line }
      let(:message) { nil }

      it { is_expected.to eq [] }
    end
  end
end
