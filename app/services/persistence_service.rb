class PersistenceService

  include CDQ

  def self.load_pages
    @instance.load_pages
  end

  def self.save
    @instance.save
  end

  def self.init
    @instance ||= PersistenceService.new
  end

  def initialize
    cdq.setup
  end

  def save
    cdq.save
  end

  def reset
    Note.all.each do | n |
      n.destroy
      cdq.save
    end

    Page.all.each do | p |
      p.destroy
      cdq.save
    end
  end

  def load_pages
    # reset

    ensure_starting_page

    Page.all.array
  end

  def ensure_starting_page
    if Page.all.size == 0
      p = Page.create( title: 'your first page' )
      p.notes.create( content: "111\n111\n111\n111\n111\n111\n", height: 4, width: 8, x: 0, y: 0 )
      p.notes.create( content: "111\n111\n111\n111\n111\n111\n", height: 4, width: 8, x: 0, y: 4 )

      p = Page.create( title: 'your second page' )
      p.notes.create( content: "222\n222\n222\n222\n", height: 4, width: 8, x: 0, y: 0 )
      p.notes.create( content: "222\n222\n222\n222\n", height: 4, width: 8, x: 0, y: 4 )

      p = Page.create( title: 'your third page' )
      p.notes.create( content: "333\n333\n333\n333\n", height: 4, width: 8, x: 0, y: 0 )
      p.notes.create( content: "333\n333\n333\n333\n", height: 4, width: 8, x: 0, y: 4 )
    end

    save
  end

end