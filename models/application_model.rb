class ApplicationModel
  def to_hash # here is dynamcally generates hash from instance
    attrs = Hash.new
    self.instance_variables.each do |k|
      if instance_variable_get(k).kind_of?(Array) # if the instance has many nested objects here is converting it.
        attrs[k.to_s.delete('@').to_sym] = instance_variable_get(k).map{|v| v.to_hash}
      elsif instance_variable_get(k).class.ancestors.include?(ApplicationModel) # if the instance has one nested object here is converting it. ancestors is list of the class inheritance chain
        attrs[k.to_s.delete('@').to_sym] = instance_variable_get(k).to_hash # here calls here recursively if a class inherieted from here
      else
        attrs[k.to_s.delete('@').to_sym] = instance_variable_get(k)
      end
    end
    attrs
  end
end