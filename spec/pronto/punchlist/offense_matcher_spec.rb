# frozen_string_literal: true

require 'pronto'
require 'punchlist'
require_relative '../../spec_helper'
require 'pronto/punchlist/offense_matcher'

describe Pronto::Punchlist::OffenseMatcher do
  let(:message_creator) do
    instance_double(Pronto::Punchlist::MessageCreator, 'message_creator')
  end
  let(:offense_matcher) do
    described_class.new(offense, message_creator: message_creator)
  end
  let(:offense) { instance_double(Punchlist::Offense, 'offense') }

  describe '#inspect_patch' do
    subject { offense_matcher.inspect_patch(patch) }

    let(:message) { instance_double(Pronto::Message, 'message') }
    let(:patch) { instance_double(Pronto::Git::Patch, 'patch') }
    let(:start_of_change_line) { 5 }
    let(:middle_of_change_line) { 6 }
    let(:end_of_change_line) { 7 }
    let(:after_end_of_change_line) { 8 }
    let(:commit_sha) { instance_double(String, 'commit_sha') }
    let(:new_file_full_path) { instance_double(String, 'new_file_full_path') }

    let(:start_of_change_line_obj) do
      instance_double(Pronto::Git::Line,
                      'start_of_change_line_obj',
                      commit_sha: commit_sha)
    end
    let(:middle_of_change_line_obj) do
      instance_double(Pronto::Git::Line,
                      'middle_of_change_line_obj',
                      commit_sha: commit_sha)
    end
    let(:end_of_change_line_obj) do
      instance_double(Pronto::Git::Line,
                      'end_of_change_line_obj',
                      commit_sha: commit_sha)
    end
    let(:after_end_of_change_line_obj) do
      instance_double(Pronto::Git::Line,
                      'after_end_of_change_line_obj',
                      commit_sha: commit_sha)
    end

    before do
      allow(message_creator).to receive(:create).with(new_file_full_path,
                                                      patch_line_obj) do
        message
      end

      allow(patch).to receive(:added_lines) do
        [
          start_of_change_line_obj,
          middle_of_change_line_obj,
          end_of_change_line_obj,
        ]
      end
      allow(start_of_change_line_obj).to receive(:new_lineno) do
        start_of_change_line
      end
      allow(middle_of_change_line_obj).to receive(:new_lineno) do
        middle_of_change_line
      end
      allow(end_of_change_line_obj).to receive(:new_lineno) do
        end_of_change_line
      end
      allow(offense).to receive(:line_num) { offense_line }
      allow(offense).to receive(:filename) { new_file_full_path }
      allow(patch).to receive(:new_file_full_path) { new_file_full_path }
    end

    context 'when related to patch' do
      let(:offense_line) { start_of_change_line }
      let(:patch_line_obj) { start_of_change_line_obj }

      it { is_expected.to eq(message) }
    end

    context 'when unrelated to patch' do
      let(:offense_line) { after_end_of_change_line }
      let(:patch_line_obj) { after_end_of_change_line_obj }

      it { is_expected.to eq(nil) }
    end
  end
end
