# frozen_string_literal: true

require 'pronto'
require_relative 'spec_helper'
require 'pronto/punchlist'

describe Pronto::Punchlist do
  # let(:client_class) { double('client_class') }
  let(:patches) { double('patches') }
  let(:commit) { double('commit') }
  # let(:config) do
  #   {
  #     'consumer_key' => 'my_consumer_key',
  #     'consumer_secret' => 'my_consumer_secret',
  #     'oauth_token' => 'my_access_token',
  #     'oauth_token_secret' => 'my_access_token_secret',
  #   }
  # end
  # let(:current_time) { Time.parse('1978-02-24 09:00am US/Eastern') }
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

  # before :each do
  #   allow(client_class).to receive(:new).and_return(client)
  # end

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
        xit 'accepts'
      end
    end
  end

  describe '#inspect' do
    subject { pronto_punchlist.inspect(patch) }

    before :each do
      expect(punchlist).to receive(:inspect_filename).with(filename) do
        offenses
      end
      allow(patch).to receive(:added_lines) do
        [start_of_change_line, middle_of_change_line, end_of_change_line]
      end
    end

    let(:patch) { double('patch') }
    let(:start_of_change_line) { 5 }
    let(:middle_of_change_line) { 6 }
    let(:end_of_change_line) { 7 }
    let(:after_end_of_change_line) { 8 }

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
        expect(offense).to receive(:line) { offense_line }
      end
      context 'and related to patch' do
        let(:offense_line) { start_of_change_line }

        it 'returns offense' do
          should eq [offense]
        end
      end

      context 'and unrelated to patch' do
        let(:offense_line) { after_end_of_change_line }

        it 'returns nothing' do
          should eq []
        end
      end
    end
    xit 'multiple offenses in file'
    xit 'multiple offenses in file'
    xit 'returns a Message subclass'
    xit 'contains correct offense'
    xit 'contains correct line'
    xit 'contains correct level'
  end
end
