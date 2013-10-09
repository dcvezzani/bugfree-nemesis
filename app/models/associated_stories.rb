class AssociatedStories

    extend ActiveModel::Naming
 
    def to_model
      self
    end
 
    def valid?()      true end
    def new_record?() true end
    def destroyed?()  true end
    def to_key()  [:associated_stories] end
 
    def errors
      obj = Object.new
      def obj.[](key)         [] end
      def obj.full_messages() [] end
      obj
    end

  attr_accessor :story_ids

end
