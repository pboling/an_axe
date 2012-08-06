ActiveRecord::Base.class_eval do
    include ActionView::Helpers::TagHelper, ActionView::Helpers::TextHelper, WhiteListHelper
    def self.format_attribute(*args)
      class << self; include ActionView::Helpers::TagHelper, ActionView::Helpers::TextHelper, WhiteListHelper; end
      @@formatted_fields = args
      @@formatted_fields.each do |field|
        field=field.to_s
        define_method(field.to_sym)           { read_attribute field }
        define_method("#{field}_html".to_sym) { read_attribute "#{field}_html" }
        define_method("#{field}_html=".to_sym){ |value| write_attribute "#{field}_html=", value }      
      end        
      before_save :format_content
    end

    def dom_id
      [self.class.name.downcase.pluralize.dasherize, id] * '-'
    end

  protected
  
    def format_content
      @@formatted_fields.each do |field|
        self["#{field.to_s}"].strip! if self["#{field.to_s}"].respond_to?(:strip!)
        self["#{field.to_s}_html"] = self["#{field.to_s}"].blank? ? '' : field_html_with_formatting(field)
      end      
    end
    
    def field_html_with_formatting(field)
      # field_html = auto_link eval("#{field.to_s}") { |text| truncate(text, 50) }
      # textilized = RedCloth.new(field_html, [ :hard_breaks ])
      # textilized = RedCloth.new(field_html)
      # textilized.hard_breaks = true if textilized.respond_to?("hard_breaks=")
      # white_list(textilized.to_html)
      white_list(eval("#{field.to_s}"))
    end
end


