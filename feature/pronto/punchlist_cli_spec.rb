# frozen_string_literal: true

require_relative '../feature_helper'
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

  describe 'bundle exec pronto' do
    let(:expected_output) do
      <<~OUTPUT
        Commands:
          pronto help [COMMAND]   # Describe available commands or one specific command
          pronto list             # Lists pronto runners that are available to be used
          pronto run [PATH]       # Run Pronto
          pronto verbose-version  # Display verbose version
          pronto version          # Display version

      OUTPUT
    end

    it 'includes pronto as a dependency' do
      out, exit_code = Open3.capture2e(env, 'bundle exec pronto')
      expect(out).to eq(expected_output)
      expect(exit_code).to eq(0)
    end
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

  context 'with a repo' do
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

      it 'runs and finds no files' do
        expected_output = ''
        out, exit_code =
             Open3.capture2e(env,
                             'bundle exec pronto run --staged -r punchlist -f text')
        expect(out).to eq(expected_output)
        expect(exit_code).to eq(0)
      end
    end

    context 'with annotation comments' do
      let(:example_files) do
        {
          'more_interesting.rb' =>
          "puts 'hello world'\n# TODO: Write more code",
        }
      end

      it 'runs and finds files to run' do
        expected_output =\
        "more_interesting.rb:2 W: " \
        "Uncompleted punchlist item detected--consider resolving or " \
        "moving this to your issue tracker\n"
        out, exit_code = Open3.capture2e(env,
                                         'bundle exec pronto run --staged -r punchlist -f text')
        expect(out).to end_with(expected_output)
        expect(exit_code).to eq(0)
      end
    end
  end
end
