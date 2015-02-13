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
    backup
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
      p.notes.create( content: "111\n111\n111\n111\n111\n111\n", height: 8, width: 2, x: 0, y: 0 )
      p.notes.create( content: "111\n111\n111\n111\n111\n111\n", height: 8, width: 2, x: 2, y: 0 )
      p.notes.create( content: "111\n111\n111\n111\n111\n111\n", height: 8, width: 2, x: 4, y: 0 )
      p.notes.create( content: "111\n111\n111\n111\n111\n111\n", height: 8, width: 2, x: 6, y: 0 )

      p = Page.create( title: 'your second page' )
      p.notes.create( content: "222\n222\n222\n222\n", height: 4, width: 8, x: 0, y: 0 )
      p.notes.create( content: "222\n222\n222\n222\n", height: 4, width: 8, x: 0, y: 4 )

      p = Page.create( title: 'your third page' )
      p.notes.create( content: "333\n333\n333\n333\n", height: 4, width: 8, x: 0, y: 0 )
      p.notes.create( content: "333\n333\n333\n333\n", height: 2, width: 8, x: 0, y: 4 )
      p.notes.create( content: "333\n333\n333\n333\n", height: 2, width: 8, x: 0, y: 6 )
    end

    save
  end


  def backup_path
    # mp App.documents_path

    File.join( App.documents_path, "backup-#{ Time.now.to_i }.xml" )
  end

  def backup
    file = File.open( self.backup_path, 'w' )

    file.write( backup_xml )
    file.flush
    file.close

    file = nil
  end

  def backup_xml
    backup = '<pages>'

    Page.all.each do |p|
      backup += '<page>'

      backup += "<title><![CDATA[#{ p.title }]]></title>"

      p.notes.each do |n|
        backup += '<note>'

        backup += "<x>#{ n.x }></x>"
        backup += "<y>#{ n.y }></y>"

        backup += "<width>#{ n.width }></width>"
        backup += "<height>#{ n.height }></height>"

        backup += "<content><![CDATA[#{ n.content }]]></content>"

        backup += '</note>'
      end

      backup += '</page>'
    end

    backup += '</pages>'

    backup
  end

end