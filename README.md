# Pronto::Punchlist

[![CircleCI](https://circleci.com/gh/apiology/pronto-punchlist.svg?style=svg)](https://circleci.com/gh/apiology/pronto-punchlist)

Performs incremental quality reporting for the punchlist gem.

Punchlist reports on any 'TOD O'-style comments in code; this gem plugs
in with the 'pronto' gem, which does incremental reporting using a
variety of quality tools.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pronto-punchlist'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install pronto-punchlist
```

## Usage

This is typically used either as part a custom
[pronto](https://github.com/prontolabs/pronto) rigging, sometimes as
part of general use of the
[quality](https://github.com/apiology/quality) gem.

## Development

After checking out the repo, run `bin/setup` to install
dependencies. You can also run `bin/console` for an interactive prompt
that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will
create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on
[GitHub](https://github.com/apiology/pronto-punchlist). This project
is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pronto::Punchlist project’s codebases,
issue trackers, chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/[USERNAME]/pronto-punchlist/blob/main/CODE_OF_CONDUCT.md).

## Contributions

This project, as with all others, rests on the shoulders of a broad
ecosystem supported by many volunteers doing thankless work, along
with specific contributors.

In particular I'd like to call out:

* [Audrey Roy Greenfeld](https://github.com/audreyfeldroy) for the
  cookiecutter tool and associated examples, which keep my many
  projects building with shared boilerplate with a minimum of fuss.
