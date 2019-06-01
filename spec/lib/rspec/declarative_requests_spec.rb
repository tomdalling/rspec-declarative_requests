require 'spec_helper'
require_relative '../../support/rails_app'
require 'rspec/rails'
require 'rspec/composable_json_matchers'

RSpec.describe RSpec::DeclarativeRequests, type: :request do
  include described_class
  include RSpec::ComposableJSONMatchers

  describe 'GET /test' do
    before do
      params[:user] = { name: 'johnny' }
      headers['X-Custom-Header'] = 'wawawa'
    end

    it "sets `subject` to the response from making the request" do
      is_expected.to have_attributes(
        status: 200,
        content_type: 'application/json',
        body: be_json(
          params: { user: { name: 'johnny' } },
          headers: including(HTTP_X_CUSTOM_HEADER: 'wawawa'),
        )
      )
    end
  end

  describe 'GET /:user_id/:widget_thing_id.html' do
    let(:user_id) { 123 }
    let(:widget_thing_id) { 456 }

    it 'interpolates lets into the path' do
      expect(subject.body).to be_json including(
        params: including(
          user_id: "123",
          widget_thing_id: "456",
        )
      )
    end
  end

  describe 'GET /4443/:widget#thing#id.html' do
    context 'with objects' do
      let(:widget) { double(thing: double(id: 'w84')) }
      it 'interpolates attributes into the path' do
        expect(subject.body).to be_json including(
          params: including(widget_thing_id: "w84")
        )
      end
    end

    context 'with hashes' do
      let(:widget) { { thing: { 'id' => 'bonza' } } }
      it 'interpolates attributes into the path' do
        expect(subject.body).to be_json including(
          params: including(widget_thing_id: "bonza")
        )
      end
    end

    context 'with hashes that are missing keys' do
      let(:widget) { { thing: {} } }
      it 'has a nice error' do
        expect { subject }.to raise_error(described_class::Error) do |ex|
          expect(ex.message).to eq("Couldn't find 'id' while interpolating ':widget#thing#id' in the request path")
        end
      end
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
