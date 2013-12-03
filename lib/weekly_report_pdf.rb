class WeeklyReportPdf
  include ReportPdf
  include EntriesHelper

  attr_accessor :pdf, :p1, :section_offset

  def initialize(options={})
    @pdf = Prawn::Document.new
    @p1 = lambda{|entry, yesterdays_log, entry_notes, story_notes, cursor, options|
    }
    @section_offset = 20
  end

  # def highlight
  #   @highlight ||= lambda{|the_pdf|HighlightCallback.new(:color => 'FFFFAA', :document => the_pdf)}
  #   @highlight.call(pdf)
  # end  

  def self.generate(options={})
    report = WeeklyReportPdf.new(options)
    pdf = report.pdf

    the_entries = options[:entries]
    Rails.logger.debug(">>> pdf type: " + pdf.class.name)

    report.generate_stories(options[:stories], {})

    hrs_worked = options[:hrs_worked]
    report.pdf.formatted_text([{text: "Total hours worked for the week: "}, {text: hrs_worked.to_s, size: 14, styles: [:bold]}])#{hrs_worked}"
    report.pdf.move_down report.section_offset
    
    # TODO: need to do checks based on accomplishments
    # and then on each individual note and related story note.
    # Otherwise there is some very strange wrapping between pages.
    report.pdf.start_new_page 
    report.generate_entries(options[:entries], {})

    return pdf
  end


  def generate_stories(the_stories, options={})
    # STORIES

    pdf.font("Helvetica", size: 16, style: :bold) do
      pdf.text "Story Summary"
    end
    # pdf.stroke do; pdf.horizontal_rule; end
    pdf.move_down section_offset

    story_summary = the_stories.map do |story|
      out = []
      out << story.title.capitalize
      out << story.due_on or "none"
      out << story.hours_est
      out << story.hours_worked
      out << story.hours_todo
    end

    pdf.table([ 
      ["Story or task name", "Due on", "Hr Est", "Hr Wrk", "Hr Todo"], 
      *story_summary
    ], :column_widths => {1 => 75}) do
      cells.style do |c|
        if(c.row == 0)
          c.background_color = "D8D8D8"
          
        elsif(c.row > 0 and !the_stories[c.row-1].is_open?)
          c.background_color = "AAFFAA"
        end

        if(c.column >= 2)
          c.align = :right
        end
      end
    end
    pdf.move_down section_offset

    pdf.font("Helvetica", size: 16, style: :bold) do
      pdf.text "Weekly Entries"
    end
    # pdf.stroke do; pdf.horizontal_rule; end
    pdf.move_down section_offset

    pdf
  end

  def generate_entry(entry, options={})
    scratch = Prawn::Document.new
    block_height_plus_offset = 0

    scratch.transaction do
      b = render_entry(scratch, entry, options, &p1)
      block_height_plus_offset = (b.height + section_offset)
      scratch.rollback
    end

    Rails.logger.debug(">>> pdf.cursor, block_height_plus_offset: (#{pdf.cursor} < #{block_height_plus_offset})")
    if(pdf.cursor < block_height_plus_offset)
      Rails.logger.debug(">>> starting new page: #{entry.class.name}, #{entry.id}")
      pdf.start_new_page 
    end

    render_entry(pdf, entry, options, &p1)

    pdf
  end

  def generate_entries(the_entries, options={})
    # ENTRIES
    #
    page_width = 520
    pad = 10
    entry_col_1 = 150
    entry_col_2 = page_width - (entry_col_1 - pad)
    options = {entry_col_1: entry_col_1, entry_col_2: entry_col_2, pad: pad}

    the_entries.each do |entry|
      generate_entry(entry, options, &p1)
    end

    pdf
  end
end


#     Rails.logger.debug(">>> cursor: #{cursor}")
# 
#     scratch = Prawn::Document.new
#     b = render_entry(scratch, entry, options, &p1)
#     Rails.logger.debug(">>> b.height: #{b.height}")
# 
#     pdf.start_new_page if(b.height > cursor)
#     render_entry(self, entry, options, &p1)


#   @roll = pdf.transaction do 
#     b = render_entry(entry, options, &p1)
#     #Rails.logger.debug(">>> page_count: #{pdf.page_count}, cursor_pos: #{cursor}, b.height: #{b.height}");
#     pdf.rollback if cursor < 0 #>
#   end
# 
#   if @roll == false
#     pdf.start_new_page
#     render_entry(entry, options, &p1)
#   end

