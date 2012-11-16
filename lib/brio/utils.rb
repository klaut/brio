class Hash
  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end

# class String
#   def to_bool
#     return true   if self == true   || self =~ (/(true|t|yes|y|1)$/i)
#     return false  if self == false  || self.blank? || self =~ (/(false|f|no|n|0)$/i)
#     raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
#   end
# end