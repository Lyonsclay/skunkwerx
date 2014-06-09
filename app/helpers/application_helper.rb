module ApplicationHelper

  def stylesheet(*files)
    content_for(:head_stylesheet) { stylesheet_link_tag(*files, "data-turbolinks-track" => true) }
  end

  def javascript(*files)
    content_for(:head_javascript) { javascript_include_tag(*files, "data-turbolinks-track" => true) }
  end
end
