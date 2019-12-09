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
    Pronto::Punchlist.new(patches, commit)
  end
  # let(:client) { double('client') }

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
    let(:patch) { double('patch') }
    context 'with an empty patch' do
      before :each do
        allow(patch).to receive(:additions) { 0 }
      end
      it 'rejects' do
        should be false
      end
    end
    context 'with a valid file' do
      before :each do
        allow(patch).to receive(:additions) { 1 }
      end

      context 'in the Ruby language' do
        it 'accepts' do
          should be true
        end
      end
      context 'which is binary' do
        xit 'rejects'
      end
      context 'which is a markdown file' do
        xit 'accepts'
      end
    end
  end

  describe '#inspect' do
    xit 'returns nothing when there are no offenses in file'
    xit 'returns nothing when offenses are in file, but not related to patch'
    xit 'returns something when offenses are in file, and related to patch'
  end

  describe '#new_message' do
    xit 'returns a Method subclass'
    xit 'contains correct offense'
    xit 'contains correct line'
    xit 'contains correct level'
  end

  # describe '#recent' do
  #   subject { twittersource.recent }
  #   let(:search_results) { double('search_results') }
  #   let(:search_results_hash) do
  #     {
  #       statuses:
  #       [
  #         {
  #           id: 1,
  #           text: "mumble\nmumble",
  #           user: {
  #             screen_name: 'oscar',
  #             lang: 'en',
  #           },
  #           created_at: '1978-02-24 09:01am US/Eastern',
  #         },
  #         {
  #           id: 2,
  #           text: 'nom nom',
  #           user: {
  #             screen_name: 'cookie_monster',
  #             lang: 'en',
  #           },
  #           created_at: '1978-02-24 09:00am US/Eastern',
  #         },
  #         {
  #           id: 3,
  #           text: 'RT nom nom',
  #           user: {
  #             screen_name: 'bert',
  #             lang: 'en',
  #           },
  #           created_at: '1978-02-24 09:02am US/Eastern',
  #         }
  #       ]
  #     }
  #   end

  #   context 'when tweets exist' do
  #     before :each do
  #       allow(logger).to receive(:puts) # log that we are pulling messages...
  #       allow(client).to receive(:search)
  #         .with(TwitterSource.query_string,
  #               count: TwitterSource.search_limit,
  #               result_type: 'recent')
  #         .and_return(search_results)
  #       allow(search_results).to receive(:to_h).and_return(search_results_hash)
  #     end

  #     it 'is not empty' do
  #       should_not be_empty
  #     end

  #     it 'contains correct text' do
  #       should eq [{ text: 'mumble mumble - @oscar, twitter',
  #                    url: 'https://twitter.com/oscar/status/1' },
  #                  { text: 'nom nom - @cookie_monster, twitter',
  #                    url: 'https://twitter.com/cookie_monster/status/2' }]
  #     end

  #     context 'when multiple days of out of order tweets exist' do
  #       let(:search_results_hash) do
  #         {
  #           statuses:
  #           [
  #             {
  #               id: 1,
  #               text: 'day 1a',
  #               user: {
  #                 screen_name: 'foo',
  #                 lang: 'en',
  #               },
  #               created_at: '1978-02-24 01:00am US/Eastern',
  #             },
  #             {
  #               id: 2,
  #               text: 'day 1b',
  #               user: {
  #                 screen_name: 'bar',
  #                 lang: 'en',
  #               },
  #               created_at: '1978-02-24 02:00am US/Eastern',
  #             },
  #             {
  #               id: 3,
  #               text: 'day 2a',
  #               user: {
  #                 screen_name: 'baz',
  #                 lang: 'en',
  #               },
  #               created_at: '1978-02-23 08:59am US/Eastern',
  #             },
  #             {
  #               id: 4,
  #               text: 'le tweet',
  #               user: {
  #                 screen_name: 'bing',
  #                 lang: 'fr',
  #               },
  #               created_at: '1978-02-24 02:00am US/Eastern',
  #             }

  #           ]
  #         }
  #       end
  #       it 'contains only English tweets' do
  #         french_tweets = twittersource.recent.select do |tweet|
  #           tweet.include? 'le tweet'
  #         end
  #         expect(french_tweets.size).to be == 0
  #       end
  #       it 'contains only current days tweets' do
  #         expect(twittersource.recent.size).to eq 2
  #       end
  #       it 'comes out most recent first' do
  #         should eq [{ text: 'day 1b - @bar, twitter',
  #                      url: 'https://twitter.com/bar/status/2' },
  #                    { text: 'day 1a - @foo, twitter',
  #                      url: 'https://twitter.com/foo/status/1' }]
  #       end
  #     end
  #     context 'when a medium volume of tweets from today exist' do
  #       let(:search_results_hash) do
  #         { statuses: statuses }
  #       end
  #       let(:statuses) do
  #         one_status = {
  #           text: 'day 1a',
  #           user: {
  #             screen_name: 'foo',
  #             lang: 'en',
  #           },
  #           created_at: '1978-02-24 01:00am US/Eastern',
  #         }
  #         arr = []
  #         (0..(TwitterSource.search_limit)).each { |i| arr[i] = one_status }
  #         arr
  #       end
  #       it "Shouldn't pretend to handle more than it can" do
  #         # https://dev.twitter.com/docs/api/1.1/get/search/tweets
  #         #
  #         # count: The number of tweets to return per page, up to a
  #         # maximum of 100. Defaults to 15
  #         expect(TwitterSource.search_limit).to be <= 100
  #       end
  #       it 'blows up instead of truncating' do
  #         expect { twittersource.recent }.to raise_error
  #       end
  #     end
  #     it 'reflects full days results on very large-sized days', wip: true
  #     it "doesn't pick up french dudes named Arvest", wip: true
  #   end
  # end
end
