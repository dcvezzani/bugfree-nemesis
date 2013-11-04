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

  def self.generate(options={})
    report = WeeklyReportPdf.new(options)
    pdf = report.pdf

    the_entries = options[:entries]
    Rails.logger.debug(">>> pdf type: " + pdf.class.name)

    report.generate_stories(options[:stories], {})
    report.generate_entries(options[:entries], {})

    return pdf
  end


  def generate_stories(the_stories, options={})
    # STORIES

    pdf.text "Story Summary"
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
      end
    end
    pdf.move_down section_offset

    pdf.text "Weekly Entries"
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
      Rails.logger.debug(">>> starting new page")
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

