require_relative './anonymizer'
require_relative './not_implemented_error'

module Anonymous
  # This module handles anonymization for ActiveRecord models. In order to
  # implement this module you must define a private #anonymization_definitions
  # method in your model.
  #
  # Retry Functionality:
  # When the model update fails because of an ActiveRecord::RecordNotUnique
  # exception the module will retry the update. This is in the event that the
  # anonymization_definitions randomly produce values that violate a unique
  # constraint in the database.
  module ActiveRecord
    def anonymize!
      anonymizer = Anonymizer.new(attributes, anonymization_definitions)
      update_model!(anonymizer.anonymized_attributes)
    rescue ::ActiveRecord::RecordNotUnique => e
      @anonymization_attempts ||= 0
      max_retries = Anonymous.configuration.max_anonymize_retries
      raise e if @anonymization_attempts >= max_retries

      @anonymization_attempts += 1
      retry
    end

    def anonymize
      anonymizer = Anonymizer.new(attributes, anonymization_definitions)
      update_model(anonymizer.anonymized_attributes)
    rescue ::ActiveRecord::RecordNotUnique => e
      @anonymization_attempts ||= 0
      max_retries = Anonymous.configuration.max_anonymize_retries
      raise e if @anonymization_attempts >= max_retries

      @anonymization_attempts += 1
      retry
    end

    private

    def update_model(anonymized_attributes)
      if (Gem::Version.new(::ActiveRecord::VERSION::STRING) >= Gem::Version.new("6.0.0"))
        update(anonymized_attributes)
      else
        update_attributes(anonymized_attributes)
      end
    end

    def update_model!(anonymized_attributes)
      if (Gem::Version.new(::ActiveRecord::VERSION::STRING) >= Gem::Version.new("6.0.0"))
        update!(anonymized_attributes)
      else
        update_attributes!(anonymized_attributes)
      end
    end

    def anonymization_definitions
      message = "Class #{self.class.name} must implement an #anonymization_definitions method to use the Anonymous::ActiveRecord functionality."

      raise NotImplementedError, message
    end
  end
end
