# frozen_string_literal: true

require 'pronto'
require_relative 'spec_helper'
require 'pronto/punchlist'

describe Pronto::Punchlist do
  let(:patches) { double('patches') }
  let(:commit) { double('commit') }
  let(:pronto_punchlist) do
    Pronto::Punchlist.new(patches, commit,
                          source_file_globber: source_file_globber,
                          punchlist: punchlist)
  end

  let(:source_file_globber) { double('source_file_globber') }
  let(:punchlist) { double('punchlist') }
  let(:patch) { double('patch') }
  let(:filename) { double('filename') }
  before :each do
    allow(patch).to receive(:new_file_full_path) do
      filename
    end
  end

  describe '#new' do
    subject { pronto_punchlist }
    it 'initializes' do
      should_not eq(nil)
    end

    it 'inherits from Pronto::Runner' do
      expect(subject.class.superclass).to eq(Pronto::Runner)
    end
  end

  describe '#run' do
    subject { pronto_punchlist.run }

    it 'returns' do
      should_not eq(nil)
    end

    xit 'coordinates with other methods'
  end

  describe '#valid_patch?' do
    subject { pronto_punchlist.valid_patch?(patch) }

    context 'with an empty patch' do
      before :each do
        expect(patch).to receive(:additions) { 0 }
      end
      it 'rejects' do
        should be false
      end
    end

    context 'with a valid file' do

      before :each do
        expect(patch).to receive(:additions) { 1 }
        expect(source_file_globber).to receive(:is_non_binary?)
          .with(filename) { !file_is_binary }
      end

      context 'in the Ruby language' do
        let(:file_is_binary) { false }

        it 'accepts' do
          should be true
        end
      end

      context 'which is binary' do
        let(:file_is_binary) { true }

        before :each do
          # TODO - do something like this: https://github.com/apiology/quality/blob/master/lib/quality/linguist_source_file_globber.rb - should I export to its own repo?  Maybe import for now and just test that this calls into that interface?
          allow(patch).to receive(:patch) { '/foo/bar/baz.bin' }
        end

        it 'rejects' do
          should be false
        end
      end

      context 'which is a markdown file' do
        # TODO: Get xit added to punchlist list
        xit 'accepts'
      end
    end
  end
end