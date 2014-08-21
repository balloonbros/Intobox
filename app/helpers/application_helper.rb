module ApplicationHelper
  def css(file)
    content_for :css do
      stylesheet_link_tag file
    end
  end

  def js(file)
    content_for :js do
      javascript_include_tag file
    end
  end

  def dialog(options)
    content_for :modal_dialog do
      render options
    end
  end
end
