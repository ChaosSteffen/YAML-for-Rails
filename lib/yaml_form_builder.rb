=begin rdoc
== YamlFormBuilder

Helps to use the YAML Form Construction Kit and replaces the +type_text+, +type_text_area+, +type_check+ and +type_radio+ methods in the YamlLayoutHelper.

====Deprecation notice:
The +type_text+, +type_text_area+, +type_check+ and +type_radio+ methods still work, but are deprecated.
Use the new YamlFormBuilder-methods insted. If you still use the old methods former yaml_for_rails methods may can break your application.

===USAGE
Use them like the normal FormBuilder-methods, BUT the second argument is always the label-text:

You need to set the YamlFormBuilder as your builder in the form statement:

 <% form_for @user, :html => { :class => :yform }, :builder => YamlFormBuilder do |f| -%>

Then you can use the new Builder transparently:

Old:
 <div class="type-text">
   <%= f.label :login, "Login" %>
   <%= f.text_field :login %>
 </div>

New:
 <%= f.text_field :login, 'Login' %>

=end
class YamlFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(attribute, label_text, options={})
    @template.content_tag :div, :class => :"type-text" do
      label(attribute, label_text) +
      super(attribute, options)
    end
  end
  
  def text_area(attribute, label_text, options={})
    @template.content_tag :div, :class => :"type-text" do
      label(attribute, label_text) +
      super(attribute, options)
    end
  end
  
  def password_field(attribute, label_text, options={})
    @template.content_tag :div, :class => :"type-text" do
      label(attribute, label_text) +
      super(attribute, options)
    end
  end
  
  def file_field(attribute, label_text, options={})
    @template.content_tag :div, :class => :"type-text" do
      label(attribute, label_text) +
      super(attribute, options)
    end
  end
  
  def check_box(attribute, label_text, options={}, checked_value = "1", unchecked_value = "0")
    @template.content_tag :div, :class => :"type-check" do
      super(attribute, options, checked_value, unchecked_value) +
      label(attribute, label_text)
    end
  end
  
  def radio_button(attribute, label_text, tag_value, options)
    @template.content_tag :div, :class => :"type-check" do
      super(attribute, tag_value, options) +
      label(attribute, label_text)
    end
  end
end
