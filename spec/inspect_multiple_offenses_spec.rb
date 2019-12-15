# frozen_string_literal: true

require 'pronto'
require_relative 'spec_helper'
require 'pronto/punchlist/inspector'

describe Pronto::Punchlist::Inspector do
  let(:inspector) do
    Pronto::Punchlist::Inspector.new(punchlist: punchlist)
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
    subject { inspector.inspect(patch) }

    before :each do
      expect(punchlist).to receive(:inspect_filename).with(filename) do
        offenses
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
    end

    let(:patch) { instance_double(Pronto::Git::Patch) }
    let(:before_start_of_change_line) { 4 }
    let(:start_of_change_line) { 5 }
    let(:middle_of_change_line) { 6 }
    let(:end_of_change_line) { 7 }
    let(:after_end_of_change_line) { 8 }
    let(:commit_sha) { instance_double(String) }

    let(:start_of_change_line_obj) do
      instance_double(Pronto::Git::Line, commit_sha: commit_sha)
    end
    let(:middle_of_change_line_obj) do
      instance_double(Pronto::Git::Line, commit_sha: commit_sha)
    end
    let(:end_of_change_line_obj) do
      instance_double(Pronto::Git::Line, commit_sha: commit_sha)
    end

    context 'two offenses in file' do
      let(:offense_1) { double('offense_1') }
      let(:offense_2) { double('offense_2') }
      let(:offenses) { [offense_1, offense_2] }
      before :each do
        allow(offense_1).to receive(:line) { offense_1_line }
        allow(offense_2).to receive(:line) { offense_2_line }
      end
      context 'and both related to patch' do
        let(:offense_1_line) { start_of_change_line }
        let(:offense_2_line) { middle_of_change_line }

        it 'returns both offenses' do
          expect(subject.map(&:line)).to eq [start_of_change_line_obj,
                                             middle_of_change_line_obj]
        end
      end

      context 'and only first related to patch' do
        let(:offense_1_line) { start_of_change_line }
        let(:offense_2_line) { after_end_of_change_line }

        it 'returns only first' do
          expect(subject.map(&:line)).to eq [start_of_change_line_obj]
        end
      end

      context 'and only second related to patch' do
        let(:offense_1_line) { before_start_of_change_line }
        let(:offense_2_line) { middle_of_change_line }

        it 'returns only second' do
          expect(subject.map(&:line)).to eq [middle_of_change_line_obj]
        end
      end

      context 'and both unrelated to patch' do
        let(:offense_1_line) { before_start_of_change_line }
        let(:offense_2_line) { after_end_of_change_line }

        it 'returns nothing' do
          should eq []
        end
      end
    end
  end
end
