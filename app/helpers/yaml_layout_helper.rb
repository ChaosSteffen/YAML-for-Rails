=begin rdoc
== yaml_for_rails

YAML for Rails is a Rails Plugin, that provides a set of helper methods to
deal with the great CSS-Framwork YAML (http://www.yaml.de).

For a documentation of the YAML Framework see the official documentation:
http://www.yaml.de/en/documentation.html

Supported Features:

* Subtemplates / Subcolumns
* Form Construction Kit
* Navigation Components
  
=== License
YAML for Rails is licensed under MIT License
  
=== Thanks to
Dirk Jesse, for creation of the YAML-Framework.
  
== Subtemplates / Subcolumns

With the +subcolumns+ and +column+ helpers you can create subtempletes. 
You can nest the into each other recursively with unlimited depth.
  
=== How to use

   <% subcolumns do %>
     <% column :c50l, :subcl do %>
       content of first comlumn
     <% end %>
     <% column :c50r, :subcr do %>
       content of second comlumn
     <% end -%>
   <% end -%>
   # => "<div class="subcolumns">
   #       <div class="c50l">
   #         <div class="subcl">
   #           content of first comlumn
   #         </div>
   #       </div>
   #       <div class="c50r">
   #         <div class="subcr">
   #           content of second comlumn
   #         </div>
   #       </div>
   #     </div>"

== Form Construction Kit
  
One of the most time-saving features of YAML is the Form Construction Kit.
But, it needs a lot of HTML boilerplate code to, so you hopefully enjoy the following
helpers for form construction:
  
* fieldset
* type_text
* type_text_area
* type_select
* type_check
* type_radio
* buttonset

=== How to use

 <% form_for @user, :html  => { :class => :yform } do |f| -%>
   <% fieldset "User Data" do %>
     <%= type_text @user, :name, "Username" %>
   <% end %>
   <% buttonset do %>
     <%= f.submit "save" %>
   <% end %>
 <% end -%>
 # => "<form action="/user/1" class="yform" id="edit_user_1" method="post">
 #       <fieldset>
 #         <legend>User Data</legend>
 #         <div class="type-text">
 #           <label for="user_name">Username</label>
 #           <input id="user_name" name="user_name" type="text" value="John Doe" />
 #         </div>
 #       </fieldset>
 #       <div class="type-button">
 #         <input id="user_submit" name="commit" type="submit" value="save" />
 #       </div>
 #     </form>"

== Navigation Components

=== How tu use

 <% navigation "Main Navigation" do %>
   <%= item 'One', start_url %>
   <%= item 'Two', :controller => 'user', :action => 'edit' %>
   <% subnav 'Three' do %>
     <%= item 'Three-One', 'http://www.example.org' %>
     <%= item 'Three-Two', logout_url %>
   <% end %>
   <%= item 'Four', signup_url %>
 <% end %>
 # => "<h6>Main Navigation</h6>
 #     <ul>
 #       <li><a href="http://localhost:3000/start">One</a></li>
 #       <li><a href="/user/edit">Two</a></li>
 #       <li><span>Three</span>
 #         <ul>
 #         <li><a href="http://www.example.org">Three-One</a></li>
 #         <li><a href="http://localhost:3000/logout">Three-Two</a></li>
 #         </ul>
 #       </li>
 #       <li><a href="http://localhost:3000/signup">Four</a></li>
 #     </ul>"

=end
module YamlLayoutHelper
  
  # Genrates subcolumns template
  #
  # ==== Example
  #    <% subcolumns do %>
  #      insert columns here
  #    <% end -%>
  #    # => "<div class="subcolumns">
  #    #       insert columns here
  #    #     </div>"
  #
  # ==== Options
  # * +equalize+ - if set, the columns height will be equalized
  #
  #    <% subcolumns true do %>
  #      insert columns here
  #    <% end -%>
  #    # => "<div class="subcolumns equalize">
  #    #       insert columns here
  #    #     </div>"
  def subcolumns equalize=false, &block
    css_class = equalize ? :"subcolumns equalize" : :subcolumns
    concat content_tag(:div, :class => css_class) {
      capture(&block)
    }
  end
  
  # Generates column template
  #
  # ==== Parameters
  # * +container_class+ - sets the class of the outer <div>
  # * +content_class+ - sets the class of the inner <div>
  #
  # ==== Example
  #    <% column :c50l, :subcl do %>
  #      content of first comlumn
  #    <% end %>
  #    # => "<div class="c50l">
  #    #       <div class="subcl">
  #    #         content of first comlumn
  #    #       </div>
  #    #     </div>"
  def column container_class, content_class, &block
    concat content_tag(:div, :class => container_class) {
      content_tag(:div, :class => content_class) {
        capture(&block)
      }
    }
  end

  # Generates fieldset for Form Construction Kit
  #
  # ==== Example
  #
  #    <% fieldset do %>
  #      form content here
  #    <% end -%>
  #    # => "<fieldset>
  #    #       form content here
  #    #     </fieldset>"
  #
  # ==== Options
  # * <tt>legend</tt> - if set, creates a legend for fieldset
  #
  #    <% fieldset "Infos" do %>
  #      form content here
  #    <% end -%>
  #    # => "<fieldset>
  #    #       <legend>Infos</legend>
  #    #       form content here
  #    #     </fieldset>"
  def fieldset legend, &block
    concat content_tag(:fieldset) {
      output = String.new
      output << content_tag(:legend, legend) unless legend.blank?
      output << capture(&block)
    } 
  end
  
  # Generates HTML Blocks for Textfield Element
  #
  # ==== Parameters
  # * object - takes the object
  # * method - takes a hash of which attribute should be used
  # * label_text
  #
  # ==== Example
  #
  #    <%= type_text @user, :city, "Location" %>
  #    # => "<div class="type-text">
  #    #       <label for="user_city">Location</label>
  #    #       <input id="user_city" name="user_city" type="text" value="Berlin" />
  #    #     </div>"
  #
  def type_text object, method, label_text
    content_tag :div, :class => :"type-text" do
      attr_id = "#{object.class.to_s.downcase}_#{method}".to_sym
      output = String.new
      output << content_tag(:label, label_text, :for => attr_id) unless label_text.blank?
      output << text_field_tag(attr_id, object.read_attribute(method))
    end
  end
  
  # Generates HTML Blocks for Textarea Element
  #
  # ==== Parameters
  # * object - takes the object
  # * method - takes a hash of which attribute should be used
  # * label_text
  #
  # ==== Example
  #
  #    <%= type_text_area @user, :about, "About me" %>
  #    # => "<div class="type-text">
  #    #       <label for="user_about">About me</label>
  #    #       <textarea id="user_about" name="user_about">Lorem ipsum dolor sit amet</textarea>
  #    #     </div>"
  #
  def type_text_area object, method, label_text
    content_tag :div, :class => :"type-text" do
      attr_id = "#{object.class.to_s.downcase}_#{method}".to_sym
      output = String.new
      output << content_tag(:label, label_text, :for => attr_id) unless label_text.blank?
      output << text_area_tag(attr_id, object.read_attribute(method))
    end
  end
  
  # Generates HTML Block for Select Element
  #
  # ==== Parameters
  # * object - takes the object
  # * method - takes a hash of which attribute should be used
  # * label_text
  # * options - takes the options_string, use Rails's options_for_select()
  #
  # ==== Example
  #
  #    <%= type_select @user, :city, "Wohnort", options_for_select([["Berlin", "BER"],["Munich", "MUC"]]) %>
  #    # => "<div class="type-select">
  #    #       <label for="user_city">Wohnort</label>
  #    #       <select id="user_city" name="user_city">
  #    #         <option value="BER">Berlin</option>
  #    #         <option value="MUC">Munich</option>
  #    #       </select>
  #    #     </div>"
  #
  def type_select object, method, label_text, options
    content_tag :div, :class => :"type-select" do
      attr_id = "#{object.class.to_s.downcase}_#{method}".to_sym
      output = String.new
      output << content_tag(:label, label_text, :for => attr_id) unless label_text.blank?
      output << select_tag(attr_id, options)
    end
  end
  
  # Generates HTML Block for Checkbox Element
  #
  # ==== Parameters
  # * object - takes the object
  # * method - takes a hash of which attribute should be used
  # * label_text
  #
  # ==== Example
  #
  #    <%= type_check @user, :adult, "I'm older than 18 years" %>
  #    # => "<div class="type-check">
  #    #       <input id="user_adult" name="user_adult" type="checkbox" />
  #    #       <label for="user_adult">I'm older than 18 years</label>
  #    #     </div>"
  #
  def type_check object, method, label_text
    content_tag :div, :class => :"type-check" do
      attr_id = "#{object.class.to_s.downcase}_#{method}".to_sym
      output = String.new
      output << check_box_tag(attr_id, object.read_attribute(method))
      output << content_tag(:label, label_text, :for => attr_id) unless label_text.blank?
    end
  end
  
  # Generates HTML Block for Checkbox Element
  #
  # ==== Parameters
  # * object - takes the object
  # * method - takes a hash of which attribute should be used
  # * label_text
  # * value - which value does this checkbox stand for
  #
  # ==== Example
  #
  #    <p>Sex<br />
  #      <%= type_radio @user, :sex, "male", "m" %>
  #      <%= type_radio @user, :sex, "female", "f" %>
  #    </p>
  #    # => "<p>Sex<br />
  #    #       <div class="type-check">
  #    #         <input id="user_sex_m" name="user_sex" type="radio" value="m" />
  #    #         <label for="user_sex">male</label>
  #    #       </div>
  #    #       <div class="type-check">
  #    #         <input id="user_sex_f" name="user_sex" type="radio" value="f" />
  #    #         <label for="user_sex">female</label>
  #    #       </div>
  #    #     </p>"
  #
  def type_radio object, method, label_text, value
    content_tag :div, :class => :"type-check" do
      attr_id = "#{object.class.to_s.downcase}_#{method}".to_sym
      output = String.new
      output << radio_button_tag(attr_id, value, object.read_attribute(method)==value )
      output << content_tag(:label, label_text, :for => attr_id) unless label_text.blank?
    end
  end
  
  # Generates HTML Block for a set of buttons
  #
  # ==== Example
  #
  #    <% buttonset do %>
  #      <%= f.submit "save" %>
  #    <% end %>
  #    # => "<div class="type-button">
  #    #       <input id="user_submit" name="commit" type="submit" value="save" />
  #    #     </div>"
  #
  def buttonset &block
    concat content_tag(:div, :class => :"type-button") {
      capture(&block)
    } 
  end
  
  # Generates the root elements of a Navigation
  #
  # ==== Example
  #
  #    <% navigation do %>
  #      Insert links here
  #    <% end %>
  #    # => "<ul>
  #    #       Insert links here
  #    #     </ul>"
  #
  # ==== Options
  # * +title+ - if set, displays a title for the Navigation
  # * +title_tag+ - you can specify the tag for the title
  #
  #   <% navigation "Main Navigation" do %>
  #     Insert links here
  #   <% end %>
  #    # => "<h6>Main Navigation</h6>
  #    #     <ul>
  #    #       Insert links here
  #    #     </ul>"
  #
  def navigation title = nil, title_tag = :h6, &block
    output = String.new()
    output << content_tag( title_tag, title ) unless title.nil?
    output << content_tag(:ul) do
      capture(&block)
    end
    concat output
  end
  
  # Generates a navigation item and links to a given url.
  # If the link's location is the current_page? then it sets <li = class="active">
  #
  # ==== Parameters
  # * +title+ - set the title of the link
  # * +link+ - pass a path, hash, url
  #
  # ==== Example
  #
  # Use with path
  #
  #    <%= item 'One', start_path %>
  #    # => "<li><a href="http://localhost:3000/start">One</a></li>"
  #
  # Use with hash
  #
  #    <%= item 'Two', :controller => 'user', :action => 'edit' %>
  #    # => "<li><a href="/user/edit">Two</a></li>"
  #
  # Use with URL
  #
  #    <%= item 'Three', 'http://www.example.org' %>
  #    # => "<li><a href="http://www.example.org">Three</a></li>"
  #
  # If your current site is the link, it sets <li class="active"> and
  # wraps the the title with <strong>
  #
  #    <%= item 'One', current_site_path %>
  #    # => "<li class="active"><strong>One</strong></li>"
  #
  def item title, link
    unless current_page? link
      content_tag :li, link_to(title, link)
    else
      content_tag(:li, :class => :active){
        content_tag :strong, title
      }
    end
  end
  
  # Generates a sub-navigation level
  #
  # ==== Options
  # * +title+ - takes the title of the sub-navigation level
  #
  # ==== Example
  #
  #    <% subnav 'Three' do %>
  #      <%= item 'Three-One', 'http://www.example.org' %>
  #      <%= item 'Three-Two', logout_url %>
  #    <% end %>
  #    # => "<li>
  #    #       <span>Three</span>
  #    #       <ul>
  #    #         <li><a href="http://www.example.org">Three-One</a></li>
  #    #         <li><a href="http://localhost:3000/logout">Three-Two</a></li>
  #    #       </ul>
  #    #     </li>"
  #
  def subnav title = nil, &block
    concat content_tag(:li) {
      output = String.new()
      output << content_tag( :span, title ) unless title.nil?
      output << navigation(&block)
    }
  end
  
end