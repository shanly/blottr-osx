class Book #< CDQManagedObject

  attr_accessor :current_page

  def initialize( current_page )
    self.current_page = current_page
  end

  def ui_name
    object_id.to_s
  end

end
