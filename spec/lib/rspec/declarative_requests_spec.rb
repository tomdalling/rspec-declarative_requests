require 'spec_helper'

RSpec.describe RSpec::DeclarativeRequests do
  include described_class::Helpers

  describe 'GET /hello' do
    before do
      params[:email] = 'johnny@example.com'
      headers['Accept'] = 'application/json'
    end

    it 'calls the request method' do
      expect(subject).to eq([
        :get,
        '/hello',
        params: { email: 'johnny@example.com' },
        headers: { 'Accept' => 'application/json' },
      ])
    end
  end

  describe 'GET /:user_id/:widget_thing_id.html' do
    let(:user_id) { 123 }
    let(:widget_thing_id) { 456 }
    it 'interpolates lets into the path' do
      expect(subject[1]).to eq('/123/456.html')
    end
  end

  describe 'GET /:user#id/:widget#thing#id.html' do
    let(:user) { double(id: 42) }
    let(:widget) { double(thing: double(id: 84)) }
    it 'interpolates lets into the path, calling methods' do
      expect(subject[1]).to eq('/42/84.html')
    end
  end

  %w(GET POST PUT PATCH DELETE HEAD OPTIONS).each do |http_method|
    describe "#{http_method} /test" do
      it "handles the '#{http_method}' HTTP method" do
        expect(subject[0..1]).to eq([http_method.downcase.to_sym, '/test'])
      end
    end
  end

  %i(get post put patch delete head options).each do |method_name|
    define_method(method_name) do |*args|
      @request = [method_name] + args
    end
  end

  def response
    @request
  end
end
