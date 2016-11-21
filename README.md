## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redis-intervals', github: 'mrvovanness/redis-intervals'
```

And then execute:

    $ bundle

## Usage

Firstly, initialize new instance of `Invervals::Base`, optionally you can pass Redis instance and prefix for redis keys to constructor
Then, load intervals by specifying it inside array as hashes with range name as key and an array with lower and upper bounds as a value:
```ruby
i = Intervals::Base.new(Redis.new, 'my_prefix')
i.load([
  { rangeA: [1, 10] },
  { rangeB: [11, 20] },
  { rangeC: [8, 30] }}
])
```
Your ranges can intersect, one range name can be used several times.
Then your can find all ranges for specified number:
```ruby
i.find(9)
=> ['rangeA', 'rangeC']
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mrvovanness/redis-intervals.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
