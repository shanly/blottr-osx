class PersistenceService

  include CDQ

  def self.load_notes
    @instance.loadNotes
  end

  def self.save
    @instance.save
  end

  def self.init
    @instance ||= PersistenceService.new
  end

  def initialize
    cdq.setup
    # reset
  end

  def save
    cdq.save
  end

  def reset
    Note.all.each do |n|
      n.destroy
      cdq.save
    end
  end

  def loadNotes
    # reset

    ensure_starting_note

    Note.all.array
  end

  def ensure_starting_note
    if Note.all.size == 0
      Note.create( content: 'your first note, add instructions', height: 8, width: 8, x: 0, y: 0 )

      # Note.create( content: '222', height: 8, width: 4, x: 4, y: 0 )

      # Note.create( content: '222', height: 4, width: 4, x: 4, y: 4 )
      # Note.create( content: '333', height: 4, width: 2, x: 4, y: 0 )
      # Note.create( content: '444', height: 2, width: 2, x: 6, y: 2 )
      # Note.create( content: '555', height: 2, width: 2, x: 6, y: 0 )

      save
    end
  end

end