module ReportPdf

  def parse_log(content)
    #need to remove tags and produce list of text lines that will be shoved into
    #bullet table
    content.gsub!(/<[^>]+>/, "")
    content.split(/[\n\r]+/)
  end

  def render_entry(the_pdf, entry, options={}, &p1)
    page_width = 520
    entry_col_1 = options[:entry_col_1]
    entry_col_2 = options[:entry_col_2]
    pad = options[:pad]


    work_intervals = entry.sorted_work_intervals.map do |interval|
      if interval.is_active?
        ["#{format_time_interval(interval.started_at)} - #{format_time_interval(current_time)}", "#{interval.delta(current_time)} hrs"]
      else
        ["#{format_time_interval(interval.started_at)} - #{format_time_interval(interval.ended_at)}", "#{interval.delta} hrs"]
      end
    end
    work_intervals.push ["Total hrs", "(#{entry.total_hours_worked({estimate: true})} hrs)"]
   

    tomorrow = entry.next_work_day
    yesterdays_log = unless tomorrow.nil?
      parse_log(tomorrow.yesterdays_log).map{|x| ["-", x]}
    end

    entry_notes = entry.notes
    if !entry_notes.blank?
      entry_notes = entry_notes.map do |note|
        ["-", note.content]
      end
    else
      entry_notes = []
    end

    story_notes = entry.story_notes
    if !story_notes.blank?
      story_notes =story_notes.map do |note|
        ["-", note.content]
      end
    else
      story_notes = []
    end

    b = []

    the_pdf.text entry.recorded_for.strftime("%a, %Y-%m-%d"), style: :bold
    the_pdf.text entry.title.capitalize
    the_pdf.move_down 20

    outer_b = the_pdf.bounding_box([0, the_pdf.cursor], width: page_width) do

      the_pdf.float do
        b << the_pdf.bounding_box([0, the_pdf.cursor], width: entry_col_1) do
          summary_interval_pos = work_intervals.size-1
          the_pdf.table(work_intervals) do
            cells.style do |c|
              if(c.row == summary_interval_pos)
                c.background_color = "D8D8D8"
                c.font_style = :bold
              end
            end
          end
          
          # the_pdf.transparent(0.5) { the_pdf.stroke_bounds }
        end
      end

      # b << p1.call(entry, yesterdays_log, entry_notes, story_notes, cursor, options)
      b << the_pdf.bounding_box([entry_col_1 + pad, the_pdf.cursor], width: entry_col_2) do
        highlighted_text the_pdf, "Accomplishments", options
        the_pdf.stroke do; the_pdf.horizontal_rule; end
        the_pdf.table(yesterdays_log, cell_style: {border_width: 0})
        the_pdf.text " "

        if(!entry_notes.blank?)
          highlighted_text the_pdf, "Notes", options
          the_pdf.stroke do; the_pdf.horizontal_rule; end
          the_pdf.table(entry_notes, cell_style: {border_width: 0})
          the_pdf.text " "
        end
 
        if(!story_notes.blank?)
          highlighted_text the_pdf, "Related Story Notes", options
          the_pdf.stroke do; the_pdf.horizontal_rule; end
          the_pdf.table(story_notes, cell_style: {border_width: 0})
          #text " "
        end
 
        #the_pdf.transparent(0.5) { the_pdf.stroke_bounds }
      end

      # the_pdf.transparent(0.5) { the_pdf.stroke_bounds }
    end
    
    height_diff = (b[0].height > b[1].height) ? b[0].height - b[1].height : b[1].height - b[0].height
    the_pdf.move_down(height_diff + 20)

    return outer_b
  end

  # the_pdf.formatted_text [{text: "Related Story Notes", callback: highlight}]
  def highlighted_text(the_pdf, text_content, options={})
    entry_col_1 = options[:entry_col_1]
    entry_col_2 = options[:entry_col_2]
    pad = options[:pad]

    the_pdf.float do
      original_color = the_pdf.fill_color
      the_pdf.fill_color = "FFFFAA"
      the_pdf.fill_rectangle([-3.0, the_pdf.cursor+3], entry_col_2+3, (section_offset-5))
      the_pdf.fill_color = original_color
    end
    the_pdf.text text_content
  end
end
