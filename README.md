# Weather

Welcome to Weather CLI! 

This is a small ruby CLI, which is going to help you to know the temperature for some Barcelona city. 


## Installation
You should have installed ruby 2.6.5

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install weather

## Usage

Run: `bin/eltiempo` to know all available commands. 

```ruby
Commands:
  eltiempo -av_max city    # will display the average max temperature for this week
  eltiempo -av_min city    # will display the average min temperature for this week
  eltiempo -today city     # will display the min and max temperature for today
  eltiempo help [COMMAND]  # Describe available commands or one specific command
```

EX:

```ruby
bin/eltiempo -today 'barcelona'

=> "For Today Domingo: Minimum: 9° | Maximum: 18°"
```

## TODO
- Get finished the Tests
- Adding a command to get all available cities
- Improve the `suggestion` method.
- Add a CACHE mechanism.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jvelez1/weather.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
