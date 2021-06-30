# frozen_string_literal: true

require_relative '../feature_helper'
require 'rubygems' # TODO: remove
require 'bundler/setup' # TODO: remove
require 'pronto/punchlist'
require 'tmpdir'

describe Pronto::Punchlist do
  let(:env) do
    {
      # Avoid spurious deprecation warnings in things which are out of
      # our control
      'RUBYOPT' => '-W0',
    }
  end

  describe 'bundle exec pronto list' do
    let(:expected_output) do
      <<~OUTPUT
        punchlist
      OUTPUT
    end

    it 'lists this as a runner' do
      out, exit_code = Open3.capture2e(env, 'bundle exec pronto list')
      expect(out).to eq(expected_output)
      expect(exit_code).to eq(0)
    end
  end

  describe 'bundle exec pronto run --staged -r punchlist -f text' do
    let(:pronto_command) do
      'bundle exec pronto run --staged -r punchlist -f text'
    end

    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          system('git init')
          File.write('README.md', 'Initial commit contents')
          system('git add .')
          system('git commit -m "First commit"')
          example_files.each do |filename, contents|
            File.write(filename, contents)
          end
          system('git add .')
          example.run
        end
      end
    end

    context 'with no annotation comments' do
      let(:example_files) do
        {
          'boring.rb' => 'puts "hello world"',
        }
      end
      let(:expected_output) { '' }

      it 'runs and finds no files' do
        out, exit_code = Open3.capture2e(env, pronto_command)
        expect(out).to eq(expected_output)
        expect(exit_code).to eq(0)
      end
    end

    context 'with annotation comments' do
      let(:example_files) do
        {
          'more_interesting.rb' =>
          "puts 'hello world'\n# TOD" \
          "O: Write more code",
        }
      end

      let(:expected_output) do
        "more_interesting.rb:2 W: " \
          "Uncompleted punchlist item detected--consider resolving or " \
          "moving this to your issue tracker\n"
      end

      it 'runs and finds files to run' do
        out, exit_code = Open3.capture2e(env, pronto_command)
        expect(out).to end_with(expected_output)
        expect(exit_code).to eq(0)
      end
    end
  end
end
