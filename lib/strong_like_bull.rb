require "strong_like_bull/version"

module StrongLikeBull
  def log_suggested_strong_parameters_format(key)
    Rails.logger.info "STRONG PARAMETERS: #{self.class}##{action_name} - suggested format: params.require(:#{key}).permit  #{suggested_strong_parameters_format key}"
  end

  def suggested_strong_parameters_format(key)
    hash = params[key]
    recursive_suggested_strong_parameters_format(hash) if hash
  end

  private
  def recursive_suggested_strong_parameters_format(object)
    if object.is_a? Hash
      if object.keys.first.match(/^\d+$/)
        hash = {}
        object.values.each do |value|
          hash.deep_merge!(value)
        end
        ret = recursive_suggested_strong_parameters_format(hash)
        ret << :id unless ret.include?(:id)
        ret
      else
        permitted_params = []
        object.each do |key, value|
          if value.is_a?(Hash) || value.is_a?(Array)
            permitted_params << {:"#{key}" => recursive_suggested_strong_parameters_format(value)}
          else
            permitted_params << :"#{key}"
          end
        end
        permitted_params
      end
    elsif object.is_a?(Array)
      if object.first.is_a?(Hash)
        hash = {}
        object.each do |value|
          hash.deep_merge!(value)
        end
        recursive_suggested_strong_parameters_format(hash)
      else
        []
      end
    end
  end
end
