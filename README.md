[gem]: https://rubygems.org/gems/formalist
[travis]: https://travis-ci.org/icelab/formalist
[code_climate]: https://codeclimate.com/github/icelab/formalist
[inch]: http://inch-ci.org/github/icelab/formalist

# Formalist

[![Gem Version](https://img.shields.io/gem/v/formalist.svg)][gem]
[![Build Status](https://travis-ci.org/icelab/formalist.svg?branch=master)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/icelab/formalist.svg)][code_climate]
[![API Documentation Coverage](http://inch-ci.org/github/icelab/formalist.svg)][inch]

## Installation

Add these lines to your application’s `Gemfile`:

```ruby
gem "dry-validation", git: "https://github.com/dryrb/dry-validation", ref: "6447302f3b53766b29f29230831890a5cc3822e0"
gem "formalist"
```

The dry-validation dependency is a temporary lock to a version that offers the AST/error message structures we expect. You should be able to remove this after future releases of formalist and dry-validation.

Run `bundle` to install the gems.

## Contributing

Bug reports and pull requests are welcome on [GitHub](http://github.com/icelab/formalist).

## Credits

Formalist is developed and maintained by [Icelab](http://icelab.com.au/).

## License

Copyright © 2015-2016 [Icelab](http://icelab.com.au/). Formalist is free software, and may be redistributed under the terms specified in the [license](LICENSE.md).
