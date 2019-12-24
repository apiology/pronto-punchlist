# frozen_string_literal: true

require 'pronto'
require_relative 'spec_helper'
require 'pronto/punchlist'

describe Pronto::Punchlist do
  let(:commit) { double('commit') }
  let(:patch_inspector) { instance_double(Pronto::Punchlist::PatchInspector) }
  let(:patch_validator) { instance_double(Pronto::Punchlist::PatchValidator) }
  let(:pronto_punchlist) do
    Pronto::Punchlist.new(patches, commit,
                          punchlist_driver: punchlist_driver,
                          patch_inspector: patch_inspector,
                          patch_validator: patch_validator)
  end

  let(:punchlist_driver) do
    instance_double(Pronto::Punchlist::PunchlistDriver,
                    'punchlist_driver')
  end
  let(:patch) { double('patch') }
  let(:filename) { double('filename') }

  describe '#new' do
    subject { pronto_punchlist }

    let(:patches) { double('patches') }

    it 'initializes' do
      should_not eq(nil)
    end

    it 'inherits from Pronto::Runner' do
      expect(subject.class.superclass).to eq(Pronto::Runner)
    end
  end

  describe '#run' do
    subject { pronto_punchlist.run }

    context 'with no patches' do
      let(:patches) { nil }

      it 'returns' do
        should eq([])
      end
    end

    context 'with a single patch which returns issues' do
      let(:patches) { [patch] }
      let(:messages) { double('messages') }

      before :each do
        expect(patch_inspector).to receive(:inspect_patch).with(patch) do
          messages
        end
      end

      context 'which is valid' do
        it 'passes back output of inspector' do
          should be messages
        end
      end
    end
  end

  describe '#inspect_patch' do
    subject { pronto_punchlist.inspect_patch(patch) }

    let(:messages) { double('messages') }
    let(:patches) { double('patches') }

    before :each do
      expect(patch_inspector).to receive(:inspect_patch).with(patch) { messages }
    end

    it 'calls into @inspector' do
      should be messages
    end
  end

  describe '#valid_patch?' do
    subject { pronto_punchlist.valid_patch?(patch) }

    let(:messages) { double('messages') }
    let(:patches) { double('patches') }
    let(:validator_return) { double('validator_return') }

    before :each do
      expect(patch_validator).to receive(:valid_patch?).with(patch) do
        validator_return
      end
    end

    it 'calls into @inspector' do
      should be validator_return
    end
  end
end
