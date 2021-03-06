module Jets::SpecHelpers
  module Controllers
    include Jets::Router::Helpers # must be at the top because response is overridden later

    attr_reader :request, :response

    def initialize(*)
      super
      @request = Request.new(:get, '/', {}, Params.new)
      @response = nil # will be set after http_call
    end

    rest_methods = %w[get post put patch delete]
    rest_methods.each do |meth|
      define_method(meth) do |path, **params|
        http_call(method: meth, path: path, **params)
      end
      # Example:
      # def get(path, **params)
      #   http_call(method: :get, path: path, **params)
      # end
    end

    def http_call(method:, path:, **params)
      request.method = method.to_sym
      request.path = path
      request.headers.deep_merge!(params.delete(:headers) || {})

      request.params.body_params = params.delete(:params) || params || {}

      request.params.query_params = params.delete(:query)
      request.params.query_params ||= params if request.method == :get
      request.params.query_params ||= {}

      request.params.path_params = params

      @response = request.dispatch!
    end
  end
end
