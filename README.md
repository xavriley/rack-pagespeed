# rack-pagespeed

Please refer to [the instructions manual](http://rack-pagespeed.heroku.com) for details. GitHub ain't stylish enough.

# License

It's as free as sneezing. Just [give me credit](http://twitter.com/julio_ody) if you make some extraordinary out of this.

# Rack seo

Work in progress.
- brew install glib
- brew install libxml2
- gem install summarize

clone this repo, cd into dir and `rake install`

in the Gemfile

`gem 'rack-pagespeed', :file => '/path/to/gem/repo'`

in the config.ru

```
require 'rack/utils'
require 'rack/pagespeed'
use Rack::PageSpeed, :public => File.expand_path("../public", __FILE__)
do
  store :disk => Dir.tmpdir # require 'tmpdir'
  seo_meta
end
```
