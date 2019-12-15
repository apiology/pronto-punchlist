# frozen_string_literal: true

require 'pronto'
require_relative 'spec_helper'
require 'pronto/punchlist'

describe Pronto::Punchlist do
  let(:patches) { double('patches') }
  let(:commit) { double('commit') }
  let(:inspector) { instance_double(Pronto::Punchlist::Inspector) }
  let(:pronto_punchlist) do
    Pronto::Punchlist.new(patches, commit,
                          source_file_globber: source_file_globber,
                          punchlist: punchlist,
                          inspector: inspector)
  end

  let(:source_file_globber) { double('source_file_globber') }
  let(:punchlist) { double('punchlist') }
  let(:patch) { double('patch') }
  let(:filename) { double('filename') }

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

  describe '#inspect' do
    subject { pronto_punchlist.inspect(patch) }

    let(:messages) { double('messages') }

    before :each do
      expect(inspector).to receive(:inspect).with(patch) { messages }
    end

    it 'calls into @inspector' do
      should be messages
    end
  end
end
