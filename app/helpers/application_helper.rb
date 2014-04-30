module ApplicationHelper

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end
end
