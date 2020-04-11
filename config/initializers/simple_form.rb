SimpleForm.setup do |config|
  config.wrappers :default, class: :input, hint_class: :field_with_hint, error_class: :field_with_errors do |b|
    b.use :html5
    b.use :placeholder

    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.use :label
    b.use :error, wrap_with: { tag: :span, class: :error }    
    b.use :input
    b.use :hint,  wrap_with: { tag: :span }
  end

  config.label_text = proc { |label, required| "#{label}" }
  config.default_wrapper = :default
  config.boolean_style = :nested
  config.button_class = 'btn'
  config.error_notification_tag = :div
  config.error_notification_class = 'alert alert-error'
  config.label_class = 'control-label'
  config.browser_validations = false
end
