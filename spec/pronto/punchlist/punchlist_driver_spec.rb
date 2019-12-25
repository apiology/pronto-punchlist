# frozen_string_literal: true

require 'pronto'
require_relative '../../spec_helper'
require 'pronto/punchlist/driver'
require 'punchlist'

describe Pronto::Punchlist::PunchlistDriver do
  let(:inspector_class) do
    class_double(Punchlist::Inspector, 'inspector_class')
  end
  let(:punchlist_driver) do
    described_class.new(punchlist_line_regexp, inspector_class: inspector_class)
  end
  let(:punchlist_line_regexp) do
    instance_double(Regexp, 'punchlist_line_regexp')
  end

  describe '#inspect_filename' do
    subject { punchlist_driver.inspect_filename(path) }

    before do
      allow(inspector_class).to receive(:new).with(punchlist_line_regexp,
                                                   path) do
        inspector
      end
      allow(inspector).to receive(:run).with no_args do
        inspector_response
      end
    end

    let(:inspector) { instance_double(Punchlist::Inspector, 'inspector') }
    let(:path) { instance_double(String, 'path') }
    let(:inspector_response) { instance_double(Array, 'inspector_response') }

    it 'delegates to punchlist inspector class' do
      expect(subject).to eq inspector_response
      expect(inspector_class).to have_received(:new)
        .with(punchlist_line_regexp, path)
      expect(inspector).to have_received(:run)
    end
  end
end
