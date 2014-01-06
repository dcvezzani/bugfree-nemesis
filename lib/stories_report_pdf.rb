class StoriesReportPdf
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

    the_stories = options[:stories]
    Rails.logger.debug(">>> pdf type: " + pdf.class.name)

    report.pdf.formatted_text([{text: "Listing stories", size: 20, styles: [:bold]}, {text: " (as of #{Time.zone.now.to_date})", size: 14, styles: [:normal]}])
    # report.pdf.indent 20 do
    #   report.pdf.formatted_text([{text: "as of #{Time.zone.now.to_date}", size: 14, styles: [:normal]}])
    # end

    report.pdf.move_down report.section_offset

    report.pdf.formatted_text([{text: "TOC", size: 14, styles: [:normal]}])
    report.pdf.indent 20 do
      the_stories.each do |story|
        report.pdf.formatted_text([{text: "- #{story.title}", size: 10, styles: [:normal]}])
      end
    end
    
    report.pdf.move_down report.section_offset

    the_stories.each do |story|
      report.pdf.formatted_text([{text: story.title.capitalize, size: 14, styles: [:normal]}])

      report.pdf.indent 20 do
        report.pdf.formatted_text([{text: story.description, size: 10, styles: [:normal]}])
      end

      report.pdf.move_down report.section_offset
    end

    return pdf
  end
end

