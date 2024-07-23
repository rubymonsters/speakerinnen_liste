Rails.application.config.after_initialize do
  require 'active_storage'

  ActiveStorage::Transformers::ImageProcessingTransformer.class_eval do
    private
      def operations
        transformations.each_with_object([]) do |(name, argument), list|
          Rails.logger.debug "Processing transformation: #{name} with argument: #{argument}"
          if name.to_s == "combine_options"
            Rails.logger.debug "Handling combine_options transformation"
            list.concat argument.keep_if { |key, value| value.present? and key.to_s != "host" }.to_a
          elsif argument.present?
            list << [ name, argument ]
          end
        end
      end
  end
end
