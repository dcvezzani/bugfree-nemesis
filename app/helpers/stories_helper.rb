module StoriesHelper
  def completion_status(story)
    if(story.is_open?)
      format_date(story.due_on)
    else
      "DONE!"
    end
  end
end
