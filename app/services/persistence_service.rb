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
    ensure_starting_notes

    Note.all.array
  end

  def ensure_starting_notes
    if Note.all.size < 5
      ( 5 - notes.size ).times do | i |
        Note.create( content: '...' )
        cdq.save
      end
    end
  end

end