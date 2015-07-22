Spree Banner [![Build Status](https://travis-ci.org/zaeznet/spree_zaez_banner.svg?branch=master)](https://travis-ci.org/zaeznet/spree_zaez_banner)
============

Adds a way to manage banners to Spree Commerce.


Installation
------------

1. Add the following to your Gemfile

```ruby
gem 'spree_zaez_banner'
```

2. Run `bundle install`

3. To copy and apply migrations run:

```
rails g spree_banner:install
```


Configuration
-------------

Preferences can be updated within the admin panel "Banner box settings".
Or you may set them with an initializer within your application:

```ruby
SpreeBanner::Config.tap do |config|
  config.banner_styles = {mini: "48x48>", small: "100x100>", large: "800x200#"}
  config.banner_default_style = 'small'
end
```


Banner use example
------------------

1. Add banner helper method in your view:

```erb
<%= insert_banner_box(category: "my_category") %>
```

2. Additional options:

```ruby
  class: 'my_class'
  style: 'my_style'
  carousel_id: 'carousel'
  buttons_carousel: true|false
  buttons_class: 'my_buttons_class'
  indicators_carousel: true|false
  image_class: 'my_image_class'
```

Copyright (c) 2015 Zaez Inovação Digital, released under the New BSD License
