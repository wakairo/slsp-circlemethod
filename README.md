# SLSP::CircleMethod

[![Ruby](https://github.com/wakairo/slsp-circlemethod/actions/workflows/main.yml/badge.svg)](https://github.com/wakairo/slsp-circlemethod/actions/workflows/main.yml)

SLSP:: CircleMethod provides methods using the circle method for Sports League Scheduling Problems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slsp-circlemethod'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install slsp-circlemethod

## Usage

### each()

By using the circle method, SLSP::CircleMethod.each() computes schedules of matches of n teams considering rounds.

Example:
```ruby
require "slsp/circlemethod"

teams = %w(A B C D  E F G H)
enum = SLSP::CircleMethod.each_with_fair_break(teams.size)
enum.each_slice(teams.size/2).each_with_index do |x, i|
    puts "Round #{i}: " + x.map{|p,q| "#{teams[p]} vs #{teams[q]}"}.join(", ")
end
```

Output:
```
Round 0: A vs H, G vs B, C vs F, E vs D
Round 1: B vs H, A vs C, D vs G, F vs E
Round 2: H vs C, B vs D, E vs A, G vs F
Round 3: D vs H, C vs E, F vs B, A vs G
Round 4: H vs E, D vs F, G vs C, B vs A
Round 5: F vs H, E vs G, A vs D, C vs B
Round 6: H vs G, F vs A, B vs E, D vs C
```


### each_with_fair_break()

SLSP::CircleMethod.each_with_fair_break() computes the schedules also considering breaks. In Sports League Scheduling Problems, the break means "two consecutive home matches or two consecutive away matches". 
In the following example, team A, B, D, and F have "hh" (consecutive two home matches), and team C, E, G, and H have "aa" (consecutive two away matches). So, each team has one break fairly.

Example:
```ruby
require "slsp/circlemethod"

teams = %w(A B C D  E F G H)
puts "Team   : " + teams.join(" ")
enum = SLSP::CircleMethod.each_with_fair_break(teams.size)
enum.each_slice(teams.size/2).each_with_index do |round, i|
    a = []
    round.each do |home, away|
        a[home] = "h"
        a[away] = "a"
    end
    puts "Round #{i}: " + a.join(" ")
end
```

Output:
```
Team   : A B C D E F G H
Round 0: h a h a h a h a
Round 1: h h a h a h a a
Round 2: a h a a h a h h
Round 3: h a h h a h a a
Round 4: a h a h a a h h
Round 5: h a h a h h a a
Round 6: a h a h a h a h
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wakairo/slsp-circlemethod.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
