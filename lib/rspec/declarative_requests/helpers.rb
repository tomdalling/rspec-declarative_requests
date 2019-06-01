module RSpec::DeclarativeRequests
  module Helpers
    def self.included(example_class)
      example_class.let(:params) { {} }
      example_class.let(:headers) { {} }
      example_class.let(:subject) do
        PerformRequest.(self)
        response
      end
    end
  end

  module PerformRequest
    extend self

    HTTP_METHODS = %w(GET POST PUT PATCH DELETE HEAD OPTIONS)

    def call(example)
      group = example.class.parent_groups.find do |group|
        HTTP_METHODS.any? do |http_method|
          group.description.start_with?(http_method + ' ')
        end
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
