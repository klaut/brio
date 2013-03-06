class Hash
  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end

module Brio
  module Utils
    def self.set_highline_colors
      HighLine.color_scheme = HighLine::ColorScheme.new do |cs|
        # Used in Condensed
        cs[:time]     = [:yellow]
        cs[:citation] = [:blue]
        cs[:text]     = [:white]
        # Used in Pretty
        cs[:username] = [:red]
        cs[:mention]  = [:black, :on_white]
        cs[:end_line] = [:yellow]
      end
    end
  end
end
