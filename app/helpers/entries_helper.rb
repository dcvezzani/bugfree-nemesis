module EntriesHelper

  def hide_if?(expr)
    (expr) ? raw(" style=\"display: none;\"") : ""
  end

  def format_date(date, format="%Y-%m-%d")
    return "" if date.nil?

    begin
      date.strftime(format)
    rescue Exception => e
      Rails.logger.warn "unable to print non-nil date in the format \"#{format}\": #{date.inspect}"
      ""
    end
  end

  def format_time_interval(time, format="%H:%M")
    format_time(time, format)
  end

  def in_time_zone(time)
    (time) ? time.in_time_zone : ""
  end

  def format_time(time, format="%H:%M:%S")
    return "" if time.nil?

    begin
      in_time_zone(time).strftime(format)
    rescue Exception => e
      Rails.logger.warn "unable to print non-nil time in the format \"#{format}\": #{time.inspect}"
      ""
    end
  end

  def format_float(float)
    number_with_precision(float, :precision => 1) || 0
  end

  def format_log(content)
    out = if(content.match(/<[^>]+>/))
      content
    else
      items = content.split(/[\n\r]+/).map { |item|
        "<li>#{item}<\/li>"
      }

      "<ul>\n#{items.join("\n")}\n<\/ul>"

    end

    raw(out)
  end

  def format_text(content)
    return "" if(content.blank?)

    out = if(content.match(/<[^>]+>/))
      content
    else
      items = content.split(/\r\n\r\n/).map { |item|
        "<p>#{item}<\/p>"
      }

      # "<div class=\"story-description\">\n#{items.join("\n")}\n<\/div>"
      "<div class=\"description-paragraphs\">\n#{items.join("\n")}\n<\/div>"

    end

    raw(out)
  end

end
