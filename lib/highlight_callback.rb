class HighlightCallback
  def initialize(options)
    @color    = options[:color]
    @document = options[:document]
  end
  def render_behind(fragment)
    original_color       = @document.fill_color
    @document.fill_color = @color
    @document.fill_rectangle(fragment.top_left, fragment.width, fragment.height)
    @document.fill_color = original_color
  end
end

