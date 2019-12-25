# frozen_string_literal: true

require 'pronto'
require_relative '../spec_helper'
require 'pronto/punchlist'

describe Pronto::Punchlist do
  let(:commit) { double('commit') }
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

    it { is_expected.not_to eq(nil) }

    it 'inherits from Pronto::Runner' do
      expect(described_class.superclass).to eq(Pronto::Runner)
    end
  end

  describe '#run' do
    subject { pronto_punchlist.run }

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
        expect(subject).to eq(messages)
        expect(patch_inspector).to have_received(:inspect_patch).with(patch)
      end
    end

    context 'with a single patch on a binary file' do
      let(:patches) { [patch] }

      before do
        allow(patch_validator).to receive(:valid_patch?).with(patch)
                                                        .and_return(false)
      end

      it 'does not run anything on file' do
        subject
      end

      xit 'return no offenses'
    end

    context 'with two patches, the second of which returns two issues' do
      let(:patch_1) { instance_double(Pronto::Git::Patch, 'patch_1') }
      let(:patch_2) { instance_double(Pronto::Git::Patch, 'patch_2') }
      let(:patches) { [patch_1, patch_2] }
      let(:message_a) { instance_double(Pronto::Message, 'message_a') }
      let(:message_b) { instance_double(Pronto::Message, 'message_b') }
      let(:messages_1) { [] }
      let(:messages_2) { [message_a, message_b] }

      before do
        allow(patch_validator).to receive(:valid_patch?).with(patch_1)
                                                        .and_return(true)
        allow(patch_validator).to receive(:valid_patch?).with(patch_2)
                                                        .and_return(true)
        allow(patch_inspector).to receive(:inspect_patch).with(patch_1) do
          messages_1
        end
        allow(patch_inspector).to receive(:inspect_patch).with(patch_2) do
          messages_2
        end
      end

      it 'returns messages passed back by inspector' do
        expect(subject).to eq([message_a, message_b])
        expect(patch_inspector).to have_received(:inspect_patch).with(patch_1)
        expect(patch_inspector).to have_received(:inspect_patch).with(patch_2)
      end
    end
  end
end
