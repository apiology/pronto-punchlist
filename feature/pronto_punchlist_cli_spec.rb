# frozen_string_literal: true

require_relative 'feature_helper'
require 'pronto/punchlist'

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

  xit 'pronto runs and finds no files'
    # TODO: Finish out knowledge from https://kevinjalbert.com/create-your-own-pronto-runner/

  xit 'pronto runs and finds files to run'
end
