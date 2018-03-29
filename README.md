# Trot

Trot will help you to quickly build, test and run projects in c/c++.

The trot philosophy is to require a minimal config specification.
This means that trot makes some assumptions about how to build/test/run unless you tell it to do otherwise.

without any config, trot assumes the following:
+ in this directory, there is probably some source code for a c project
+ you probably want to compile and link that project

so just type `trot build` (or simply `trot`).

or type `trot run` to run it

## Installation

```shell
gem install -g trot
```

## Usage

the `trot` command can take an optional verb and an optional noun.
```shell
trot [verb] [target]
```

```shell
trot
trot build
trot build my-target
trot run
trot run my-target
trot run my-target [foo bar]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thomgray/trot.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
