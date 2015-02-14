class Book #< CDQManagedObject

  attr_accessor :current_page

  def initialize( current_page )
    self.current_page = current_page
  end

  def ui_name
    object_id.to_s
  end

  def new_page
    new_page = Page.create( title:         'your new page',
                            next_page:     NextPage.create,
                            previous_page: PreviousPage.create )

    new_page.next_page.page     = current_page.next_page.page
    new_page.previous_page.page = current_page

    new_page.notes.create( content: 'start your notes here', height: 8, width: 8, x: 0, y: 0 )

    current_page.next_page.page.previous_page.page = new_page
    current_page.next_page.page = new_page

    new_page
  end

  def delete_page
    previous_page = current_page.previous_page.page
    next_page     = current_page.next_page.page

    previous_page.next_page.page = next_page
    next_page.previous_page.page = previous_page

    current_page.next_page.destroy
    current_page.previous_page.destroy
    current_page.destroy

    previous_page
  end

  def last_page?
    current_page.previous_page.page == current_page
  end

end
