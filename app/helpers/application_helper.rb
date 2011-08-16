module ApplicationHelper

  def logo
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end

  #return a title on a per-page basis
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def character_count(field_id, update_id, options = {})
    function = "$('#{update_id}').innerHTML = 140 - $F('#{field_id}').length;"
    out = javascript_tag(function) # set current length
    options = {:frequency => 0.1, :function => function}.merge(options) # default options
    out += observe_field(field_id, options) # and observe it
  end

  private
  def observe_field(field_id, options = {})
    if options[:frequency] && options[:frequency] > 0
      build_observer('Form.Element.Observer', field_id, options)
    else
      build_observer('Form.Element.EventObserver', field_id, options)
    end
  end

  def build_observer(klass, name, options = {})
    if options[:with] && (options[:with] !~ /[\{=(.]/)
      options[:with] = "'#{options[:with]}=' + encodeURIComponent(value)"
    else
      options[:with] ||= 'value' unless options[:function]
    end

    callback = options[:function] || remote_function(options)
    javascript  = "new #{klass}('#{name}', "
    javascript << "#{options[:frequency]}, " if options[:frequency]
    javascript << "function(element, value) {"
    javascript << "#{callback}}"
    javascript << ")"
    javascript_tag(javascript)
  end
end
