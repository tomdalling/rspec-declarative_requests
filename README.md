RSpec::DeclarativeRequests
==========================

A standardized structure for request specs in Rails.

```ruby
require 'rails_helper'

RSpec.describe 'Widgets' do
  describe 'GET /widgets/:id' do
    let(:id) { FactoryBot.create(:widget).id }
    it { is_expected.to have_http_status(:ok) }
  end
end
```

Setup
-----

Add to your `Gemfile` (probably in the `:test` group):

```ruby
# Gemfile
group :test do
  gem 'rspec-declarative_requests'
end
```

Include it in your RSpec config:

```ruby
# spec/rails_helper.rb
RSpec.configure do |config|
  # enabled for ALL request specs
  config.include RSpec::DeclarativeRequests, type: :request

  # OR: enable only for request specs tagged as :declarative
  config.include RSpec::DeclarativeRequests, type: :request, declarative: true
end
```

Or include it straight into the spec:

```ruby
# spec/requests/whatever_spec.rb
require 'rails_helper'

RSpec.describe 'Whatever' do
  include RSpec::DeclarativeRequests

  describe 'GET /whatevers' do
    # ...
  end
end
```


Using `subject`
---------------

This gem sets the RSpec subject to the _response_, after making the request.
This allows you do use `is_expected` or `expect(subject)` to check the response.

```ruby
describe 'GET /thing' do
  it { is_expected.to be_ok }

  # OR

  it "responds with 200 OK" do
    expect(subject).to have_http_status(:ok)
  end
end
```

Using `params`
--------------

There is a `let` for request params that starts as an empty Hash. You can
either override it:

```ruby
let(:params) do
  { my_param: 123 }
end
```

Or you can modify it in a `before` block:

```ruby
before do
  params[:my_param] = 123
end
```

Using `before` blocks, you can do nested contexts:

```ruby
context 'with a user' do
  before { params[:user] = { id: 123 } }

  context 'who is cool' do
    before { params[:user][:is_cool] = true }
    # ...
  end

  context 'who is not cool' do
    before { params[:user][:is_cool] = false }
    # ...
  end
end
```

Using `headers`
---------------

There is a `let` for request headers that starts as an empty Hash. This works
exactly the same as `params` described above.

```ruby
context 'requesting JSON' do
  before { headers['Accepts'] = 'application/json' }
  # ...
end
```

Path Interpolation
------------------

The path in the request description behaves _kind of_ like a Rails route.
Named segments that start with a `:` will be replaced by the value of the `let`
(or method) with the same name.

```ruby
describe 'POST /things/:thing_id' do
  let(:thing_id) { 4444 }
  # ...
end
```

It's common to want to use an attribute of an object that you already have a
`let` for. To do that, use the `#` character.

```ruby
describe 'POST /things/:thing#id' do
  let(:thing) { FactoryBot.create(:thing) }
  # ...
end
```

Attributes can be chained together.

```ruby
describe 'POST /things/:user#things#first#id' do
  let(:user) { FactoryBot.create(:user, :with_things) }
  # ...
end
```

`Hash`s can also be interpolated by their keys, which can be either strings or
symbols.

```ruby
describe 'POST /things/:user#things#first#id' do
  let(:user) do
    {
      things: [
        { id: 1 },
        { id: 2 },
      ]
    }
  end

  #...
end
```

License
-------

This gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
