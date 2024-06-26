# Kaigyo

A formatter for SQL

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kaigyo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kaigyo

## Usage

```
irb(main):001:0> puts "select a,b from foo inner join bar on foo.id = bar.id where a = 1 group by c order by d".kaigyo
select a,b
from foo
inner join bar on foo.id = bar.id
where a = 1
group by c
order by d
=> nil
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/satoakick/kaigyo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Kaigyo project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/satoakick/kaigyo/blob/master/CODE_OF_CONDUCT.md).
