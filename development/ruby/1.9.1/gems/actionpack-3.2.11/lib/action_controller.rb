require 'abstract_controller'
require 'action_dispatch'

module ActionController
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Caching
  autoload :Metal
  autoload :Middleware

  autoload_under "metal" do
    autoload :Compatibility
    autoload :ConditionalGet
    autoload :Cookies
    autoload :DataStreaming
    autoload :Flash
    autoload :ForceSSL
    autoload :Head
    autoload :Helpers
    autoload :HideActions
    autoload :HttpAuthentication
    autoload :ImplicitRender
    autoload :Instrumentation
    autoload :MimeResponds
    autoload :ParamsWrapper
    autoload :RackDelegation
    autoload :Redirecting
    autoload :Renderers
    autoload :Rendering
    autoload :RequestForgeryProtection
    autoload :Rescue
    autoload :Responder
    autoload :SessionManagement
    autoload :Streaming
    autoload :Testing
    autoload :UrlFor
  end

  autoload :Integration,        'action_controller/deprecated/integration_test'
  autoload :IntegrationTest,    'action_controller/deprecated/integration_test'
  autoload :PerformanceTest,    'action_controller/deprecated/performance_test'
  autoload :UrlWriter,          'action_controller/deprecated'
  autoload :Routing,            'action_controller/deprecated'
  autoload :TestCase,           'action_controller/test_case'
  autoload :TemplateAssertions, 'action_controller/test_case'

  eager_autoload do
    autoload :RecordIdentifier
  end
end

# All of these simply register additional autoloads
require 'action_view'
require 'action_controller/vendor/html-scanner'

# Common Active Support usage in Action Controller
require 'active_support/concern'
require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/load_error'
require 'active_support/core_ext/module/attr_internal'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/name_error'
require 'active_support/core_ext/uri'
require 'active_support/inflector'
