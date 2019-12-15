# frozen_string_literal: true

require 'pronto'
require_relative 'spec_helper'
require 'pronto/punchlist'

describe Pronto::Punchlist do
  let(:pronto_punchlist) do
    Pronto::Punchlist.new(patches, commit,
                          source_file_globber: source_file_globber,
                          punchlist: punchlist)
  end
  let(:commit) { double('commit') }
  let(:punchlist) { double('punchlist') }
  let(:patches) { double('patches') }
  let(:patch) { double('patch') }
  let(:source_file_globber) { double('source_file_globber') }
  let(:filename) { double('filename') }
  before :each do
    allow(patch).to receive(:new_file_full_path) do
      filename
    end
  end

  describe '#inspect' do
    subject { pronto_punchlist.inspect(patch) }

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

    let(:patch) { double('patch') }
    let(:before_start_of_change_line) { 4 }
    let(:start_of_change_line) { 5 }
    let(:middle_of_change_line) { 6 }
    let(:end_of_change_line) { 7 }
    let(:after_end_of_change_line) { 8 }

    let(:start_of_change_line_obj) { double('start_of_change_line_obj') }
    let(:middle_of_change_line_obj) { double('middle_of_change_line_obj') }
    let(:end_of_change_line_obj) { double('end_of_change_line_obj') }

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
          should eq [offense_1, offense_2]
        end
      end

      context 'and only first related to patch' do
        let(:offense_1_line) { start_of_change_line }
        let(:offense_2_line) { after_end_of_change_line }

        it 'returns only first' do
          should eq [offense_1]
        end
      end

      context 'and only second related to patch' do
        let(:offense_1_line) { before_start_of_change_line }
        let(:offense_2_line) { middle_of_change_line }

        it 'returns only second' do
          should eq [offense_2]
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
