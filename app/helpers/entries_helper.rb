module EntriesHelper
  def format_date(date, format="%Y-%m-%d")
    return "" if date.nil?

    format ||= "%Y-%m-%d"

    begin
      date.strftime(format)
    rescue Exception => e
      Rails.logger.warn "unable to print non-nil date in the format \"#{format}\": #{date.inspect}"
      ""
    end
  end

  def format_log(content)
    out = if(content.match(/<[^>]+>/))
      content
    else
      items = content.split(/\n/).map { |item|
        "<li>#{item}<\/li>"
      }

      "<ul>\n#{items.join("\n")}\n<\/ul>"

    end

    raw(out)
  end

  def format_text(content)
    out = if(content.match(/<[^>]+>/))
      content
    else
      items = content.split(/\r\n\r\n/).map { |item|
        "<p>#{item}<\/p>"
      }

      "<div class=\"story-description\">\n#{items.join("\n")}\n<\/div>"

    end

    raw(out)
  end

end
