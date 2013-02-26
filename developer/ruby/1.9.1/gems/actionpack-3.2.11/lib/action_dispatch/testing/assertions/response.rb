require 'active_support/core_ext/object/inclusion'

module ActionDispatch
  module Assertions
    # A small suite of assertions that test responses from \Rails applications.
    module ResponseAssertions
      extend ActiveSupport::Concern

      # Asserts that the response is one of the following types:
      #
      # * <tt>:success</tt>   - Status code was 200
      # * <tt>:redirect</tt>  - Status code was in the 300-399 range
      # * <tt>:missing</tt>   - Status code was 404
      # * <tt>:error</tt>     - Status code was in the 500-599 range
      #
      # You can also pass an explicit status number like <tt>assert_response(501)</tt>
      # or its symbolic equivalent <tt>assert_response(:not_implemented)</tt>.
      # See Rack::Utils::SYMBOL_TO_STATUS_CODE for a full list.
      #
      # ==== Examples
      #
      #   # assert that the response was a redirection
      #   assert_response :redirect
      #
      #   # assert that the response code was status code 401 (unauthorized)
      #   assert_response 401
      #
      def assert_response(type, message = nil)
        validate_request!

        if type.in?([:success, :missing, :redirect, :error]) && @response.send("#{type}?")
          assert_block("") { true } # to count the assertion
        elsif type.is_a?(Fixnum) && @response.response_code == type
          assert_block("") { true } # to count the assertion
        elsif type.is_a?(Symbol) && @response.response_code == Rack::Utils::SYMBOL_TO_STATUS_CODE[type]
          assert_block("") { true } # to count the assertion
        else
          flunk(build_message(message, "Expected response to be a <?>, but was <?>", type, @response.response_code))
        end
      end

      # Assert that the redirection options passed in match those of the redirect called in the latest action.
      # This match can be partial, such that <tt>assert_redirected_to(:controller => "weblog")</tt> will also
      # match the redirection of <tt>redirect_to(:controller => "weblog", :action => "show")</tt> and so on.
      #
      # ==== Examples
      #
      #   # assert that the redirection was to the "index" action on the WeblogController
      #   assert_redirected_to :controller => "weblog", :action => "index"
      #
      #   # assert that the redirection was to the named route login_url
      #   assert_redirected_to login_url
      #
      #   # assert that the redirection was to the url for @customer
      #   assert_redirected_to @customer
      #
      def assert_redirected_to(options = {}, message=nil)
        assert_response(:redirect, message)
        return true if options == @response.location

        redirect_is       = normalize_argument_to_redirection(@response.location)
        redirect_expected = normalize_argument_to_redirection(options)

        if redirect_is != redirect_expected
          flunk "Expected response to be a redirect to <#{redirect_expected}> but was a redirect to <#{redirect_is}>"
        end
      end

      private
        # Proxy to to_param if the object will respond to it.
        def parameterize(value)
          value.respond_to?(:to_param) ? value.to_param : value
        end

        def normalize_argument_to_redirection(fragment)
          case fragment
          when %r{^\w[A-Za-z\d+.-]*:.*}
            fragment
          when String
            @request.protocol + @request.host_with_port + fragment
          when :back
            raise RedirectBackError unless refer = @request.headers["Referer"]
            refer
          else
            @controller.url_for(fragment)
          end.gsub(/[\0\r\n]/, '')
        end

        def validate_request!
          unless @request.is_a?(ActionDispatch::Request)
            raise ArgumentError, "@request must be an ActionDispatch::Request"
          end
        end
    end
  end
end
