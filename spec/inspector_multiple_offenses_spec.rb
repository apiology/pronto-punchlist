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
    allow(patch).to receive(:new_file_full_path) do
      filename
    end
  end

  describe '#inspect' do
    subject { inspector.inspect_patch(patch) }

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
    let(:commit_sha) { instance_double(String) }

    context 'two offenses in file' do
      context 'and both related to patch' do
        xit 'returns both offenses'
      end

      context 'and only first related to patch' do
        xit 'returns only first'
      end

      context 'and only second related to patch' do
        xit 'returns only second'
      end

      context 'and both unrelated to patch' do
        xit 'returns nothing' do
          should eq []
        end
      end
    end
  end
end
