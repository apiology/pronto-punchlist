# frozen_string_literal: true

require_relative 'feature_helper'
require 'pronto/punchlist'
require 'tmpdir'

# http://www.puzzlenode.com/puzzles/13-chess-validator

describe Pronto::Punchlist do
  it 'includes pronto as a dependency' do
    expected_output = <<~OUTPUT
      Commands:
        pronto help [COMMAND]   # Describe available commands or one specific command
        pronto list             # Lists pronto runners that are available to be used
        pronto run [PATH]       # Run Pronto
        pronto verbose-version  # Display verbose version
        pronto version          # Display version

    OUTPUT
    env = {
      # Avoid spurious deprecation warnings in things which are out of
      # our control
      'RUBYOPT' => '-W0',
    }
    out, exit_code = Open3.capture2e(env, 'bundle exec pronto')
    expect(out).to eq(expected_output)
    expect(exit_code).to eq(0)
  end

  it 'lists this as a runner' do
    expected_output = <<~OUTPUT
      punchlist
    OUTPUT
    env = {
      # Avoid spurious deprecation warnings in things which are out of
      # our control
      'RUBYOPT' => '-W0',
    }
    out, exit_code = Open3.capture2e(env, 'bundle exec pronto list')
    expect(out).to eq(expected_output)
    expect(exit_code).to eq(0)
  end

  context 'in a repo' do
    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          system('git init')
          example_files.each do |filename, contents|
            File.write(filename, contents)
          end
          system('git add .')
          system('git commit -m "First commit"')
          example.run
        end
      end
    end

    context 'with a boring dummy repo' do
      let(:example_files) do
        {
          'boring.rb' => 'puts "hello world"',
        }
      end

      it 'runs and finds no files' do
        expected_output = ''
        env = {
          # Avoid spurious deprecation warnings in things which are out of
          # our control
          'RUBYOPT' => '-W0',
        }
        out, exit_code = Open3.capture2e(env, 'bundle exec pronto run -r punchlist -f text')
        expect(out).to eq(expected_output)
        expect(exit_code).to eq(0)
      end
    end

    context 'with a more interesting dummy repo' do
      let(:example_files) do
        {
          'more_interesting.rb' => "puts 'hello world'\n# TODO: Write more code",
        }
      end

      it 'runs and finds files to run' do
        expected_output = '123'
        env = {
          # Avoid spurious deprecation warnings in things which are out of
          # our control
          'RUBYOPT' => '-W0',
        }
        out, exit_code = Open3.capture2e(env, 'bundle exec pronto run -r punchlist -f text')
        expect(out).to eq(expected_output)
        expect(exit_code).to eq(1)
      end
    end
  end
end
