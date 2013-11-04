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

    the_pdf.text entry.recorded_for.strftime("%a, %Y-%m-%d")
    the_pdf.text entry.title.capitalize
    the_pdf.move_down 20

    outer_b = the_pdf.bounding_box([0, the_pdf.cursor], width: page_width) do

      the_pdf.float do
        b << the_pdf.bounding_box([0, the_pdf.cursor], width: entry_col_1) do
          the_pdf.table(work_intervals)
          #the_pdf.transparent(0.5) { the_pdf.stroke_bounds }
        end
      end

      # b << p1.call(entry, yesterdays_log, entry_notes, story_notes, cursor, options)
      b << the_pdf.bounding_box([entry_col_1 + pad, the_pdf.cursor], width: entry_col_2) do
        the_pdf.text "Accomplishments"
        the_pdf.table(yesterdays_log, cell_style: {border_width: 0})
        the_pdf.text " "

        if(!entry_notes.blank?)
          the_pdf.text "Notes"
          the_pdf.table(entry_notes, cell_style: {border_width: 0})
          the_pdf.text " "
        end
 
        if(!story_notes.blank?)
          the_pdf.text "Related Story Notes"
          the_pdf.table(story_notes, cell_style: {border_width: 0})
          #text " "
        end
 
        #the_pdf.transparent(0.5) { the_pdf.stroke_bounds }
      end

      the_pdf.transparent(0.5) { the_pdf.stroke_bounds }
    end
    
    height_diff = (b[0].height > b[1].height) ? b[0].height - b[1].height : b[1].height - b[0].height
    the_pdf.move_down(height_diff + 20)

    return outer_b
  end
end
