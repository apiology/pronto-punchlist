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
        # TODO: This should return a list of objects which have a
        # .new_lineno method that returns the line
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

      middle_of_change_line_obj
      end_of_change_line_obj
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

    context 'no offenses are in file' do
      let(:offenses) { [] }
      it 'returns nothing' do
        should eq []
      end
    end

    context 'one offense in file' do
      let(:offense) { double('offense') }
      let(:offenses) { [offense] }
      before :each do
        allow(offense).to receive(:line) { offense_line }
      end

      context 'and related to patch' do
        let(:offense_line) { start_of_change_line }

        it 'returns offense' do
          expect(subject.map(&:line)).to eq [offense.line]
        end

        xit 'returns Message subclass' do
          subject.each do |message|
            expect(message).to be_instance_of(Pronto::Message)
          end
        end
      end

      context 'and unrelated to patch' do
        let(:offense_line) { after_end_of_change_line }

        it 'returns nothing' do
          should eq []
        end
      end
    end

    xit 'contains correct offense'
    xit 'contains correct line'
    xit 'contains correct level'
  end
end
