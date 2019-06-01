module RSpec::DeclarativeRequests
  def self.included(example_class)
    example_class.let(:params) { {} }
    example_class.let(:headers) { {} }
    example_class.let(:subject) do
      PerformRequest.(self)
      response
    end
  end

  class Error < StandardError; end

  module PerformRequest
    extend self

    HTTP_METHODS = %w(CONNECT DELETE GET HEAD OPTIONS PATCH POST PUT TRACE)

    def call(example)
      group = ([RSpec.current_example] + example.class.parent_groups).find do |group|
        HTTP_METHODS.any? do |http_method|
          group.description.start_with?(http_method + ' ')
        end
      end

      if group.nil?
        raise Error, <<~END_ERROR
          Could not find an RSpec example group that looks like a request. The
          describe/context description must start with an uppercase HTTP verb
          like "GET" or "POST".

          Try something like:

            describe "GET /foo" do
              it { is_expected.to have_http_status(:ok) }
            end
        END_ERROR
      end

      method, _, path = group.description.partition(/\s+/)
      example.send(
        method.downcase,
        interpolate(path, example),
        params: example.params,
        headers: example.headers,
      )
    end

    def interpolate(path, example)
      path.gsub(/\:[a-z_#]+/) do |match|
        match[1..-1].split('#').reduce(example) do |value, attr|
          value.send(attr)
        end
      end
    end
  end
end
