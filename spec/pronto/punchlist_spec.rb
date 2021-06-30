# frozen_string_literal: true

require 'pronto'
require_relative '../spec_helper'
require 'pronto/punchlist'

describe Pronto::Punchlist do
  let(:commit) { instance_double(String, 'commit') }
  let(:patch_inspector) { instance_double(Pronto::Punchlist::PatchInspector) }
  let(:patch_validator) { instance_double(Pronto::Punchlist::PatchValidator) }
  let(:pronto_punchlist) do
    described_class.new(patches, commit,
                        punchlist_driver: punchlist_driver,
                        patch_inspector: patch_inspector,
                        patch_validator: patch_validator)
  end

  let(:punchlist_driver) do
    instance_double(Pronto::Punchlist::PunchlistDriver,
                    'punchlist_driver')
  end
  let(:patch) { instance_double(Pronto::Git::Patch, 'patch') }
  let(:filename) { instance_double(String, 'filename') }

  describe '#new' do
    subject { pronto_punchlist }

    let(:patches) { instance_double(Array, 'patches') }

    it 'inherits from Pronto::Runner' do
      expect(described_class.superclass).to eq(Pronto::Runner)
    end
  end

  describe '#run' do
    subject(:pronto_report) { pronto_punchlist.run }

    context 'with a single patch which returns issues' do
      let(:patches) { [patch] }
      let(:message_a) { instance_double(Pronto::Message, 'message_a') }
      let(:message_b) { instance_double(Pronto::Message, 'message_b') }
      let(:messages) { [message_a, message_b] }

      before do
        allow(patch_validator).to receive(:valid_patch?).with(patch)
          .and_return(true)
        allow(patch_inspector).to receive(:inspect_patch).with(patch) do
          messages
        end
      end

      it 'passes back output of inspector' do
        aggregate_failures 'message and side effects' do
          expect(pronto_report).to eq(messages)
          expect(patch_inspector).to have_received(:inspect_patch).with(patch)
        end
      end
    end

    context 'with a single patch on a binary file' do
      let(:patches) { [patch] }

      before do
        allow(patch_validator).to receive(:valid_patch?).with(patch)
          .and_return(false)
      end

      it { is_expected.to eq([]) }
    end

    context 'with two patches, the second of which returns two issues' do
      let(:patch1) { instance_double(Pronto::Git::Patch, 'patch1') }
      let(:patch2) { instance_double(Pronto::Git::Patch, 'patch2') }
      let(:patches) { [patch1, patch2] }
      let(:message_a) { instance_double(Pronto::Message, 'message_a') }
      let(:message_b) { instance_double(Pronto::Message, 'message_b') }
      let(:messages1) { [] }
      let(:messages2) { [message_a, message_b] }

      before do
        allow(patch_validator).to receive(:valid_patch?).with(patch1)
          .and_return(true)
        allow(patch_validator).to receive(:valid_patch?).with(patch2)
          .and_return(true)
        allow(patch_inspector).to receive(:inspect_patch).with(patch1) do
          messages1
        end
        allow(patch_inspector).to receive(:inspect_patch).with(patch2) do
          messages2
        end
      end

      it 'returns messages passed back by inspector' do
        aggregate_failures 'message and side-effects' do
          expect(pronto_report).to eq([message_a, message_b])
          expect(patch_inspector).to have_received(:inspect_patch).with(patch1)
          expect(patch_inspector).to have_received(:inspect_patch).with(patch2)
        end
      end
    end
  end
end
