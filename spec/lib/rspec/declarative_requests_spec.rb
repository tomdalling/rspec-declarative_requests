require 'spec_helper'
require_relative '../../support/rails_app'
require 'rspec/rails'

RSpec.describe RSpec::DeclarativeRequests, type: :request do
  include described_class

  let(:response_json) { JSON.parse(subject.body, symbolize_names: true) }

  describe 'GET /test' do
    before do
      params[:user] = { name: 'johnny' }
      headers['X-Custom-Header'] = 'wawawa'
    end

    it "sets `subject` to the response from making the request" do
      is_expected.to have_http_status(:ok)
      expect(response_json).to match(
        params: { user: { name: 'johnny' } },
        headers: include(HTTP_X_CUSTOM_HEADER: 'wawawa'),
      )
    end
  end

  describe 'GET /:user_id/:widget_thing_id.html' do
    let(:user_id) { 123 }
    let(:widget_thing_id) { 456 }

    it 'interpolates lets into the path' do
      expect(response_json[:params]).to include(
        user_id: "123",
        widget_thing_id: "456",
      )
    end
  end

  describe 'GET /:user#id/:widget#thing#id.html' do
    let(:user) { double(id: 'u42') }
    let(:widget) { double(thing: double(id: 'w84')) }

    it 'interpolates lets into the path, calling methods' do
      expect(response_json[:params]).to include(
        user_id: "u42",
        widget_thing_id: "w84",
      )
    end
  end

  describe 'with the request in the example, instead of the group' do
    specify 'GET /test' do
      expect(subject).to be_ok
    end
  end

  it 'has a nice error message' do
    expect { subject }.to raise_error(described_class::Error) do |ex|
      expect(ex.message).to eq(<<~END_ERROR)
        Could not find an RSpec example group that looks like a request. The
        describe/context description must start with an uppercase HTTP verb
        like "GET" or "POST".

        Try something like:

          describe "GET /foo" do
            it { is_expected.to have_http_status(:ok) }
          end
      END_ERROR
    end
  end
end
