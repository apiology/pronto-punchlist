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
          expect(subject.map(&:line)).to eq [start_of_change_line_obj]
        end

        it 'returns Message subclass' do
          subject.each do |message|
            expect(message).to be_instance_of(Pronto::Message)
          end
        end

        it 'contains correct line' do
          subject.each do |message|
            expect(message.line.new_lineno).to eq(offense_line)
          end
        end

        it 'contains correct offense' do
          subject.each do |message|
            expect(message.msg).to eq('Uncompleted punchlist item detected -' \
                                      'consider resolving or moving this to ' \
                                      'your issue tracker')
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

    xit 'contains correct level'
  end
end
