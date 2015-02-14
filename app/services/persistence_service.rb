class PersistenceService

  include CDQ

  def self.load_pages
    @instance.load_pages
  end

  def self.save
    @instance.save
  end

  def self.backup
    @instance.backup
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
    [ Page, Note, NextPage, PreviousPage ].each do | clazz |
      clazz.all.each do | model |
        model.destroy
      end
    end

    save
  end

  def load_pages
    reset

    ensure_starting_page

    Page.all.array
  end

  def ensure_starting_page
    if Page.all.size == 0
      start_data
    end

    save
  end

  def start_data
    p = Page.create(title: 'your first page', page_marker: true )
    p.notes.create(content: 'your first note...', height: 8, width: 8, x: 0, y: 0)

    p.next_page      = NextPage.create( page: p )
    p.previous_page  = PreviousPage.create( page: p )
  end

  def test_data
    p1 = Page.create(title: 'your first page', page_marker: true )
    p1.notes.create(content: "111\n111\n111\n111\n111\n111\n", height: 8, width: 2, x: 0, y: 0)
    p1.notes.create(content: "111\n111\n111\n111\n111\n111\n", height: 8, width: 2, x: 2, y: 0)
    p1.notes.create(content: "111\n111\n111\n111\n111\n111\n", height: 8, width: 2, x: 4, y: 0)
    p1.notes.create(content: "111\n111\n111\n111\n111\n111\n", height: 8, width: 2, x: 6, y: 0)


    p2 = Page.create(title: 'your second page')
    p2.notes.create(content: "222\n222\n222\n222\n", height: 4, width: 8, x: 0, y: 0)
    p2.notes.create(content: "222\n222\n222\n222\n", height: 4, width: 8, x: 0, y: 4)

    p3 = Page.create(title: 'your third page')
    p3.notes.create(content: "333\n333\n333\n333\n", height: 4, width: 8, x: 0, y: 0)
    p3.notes.create(content: "333\n333\n333\n333\n", height: 2, width: 8, x: 0, y: 4)
    p3.notes.create(content: "333\n333\n333\n333\n", height: 2, width: 8, x: 0, y: 6)

    p1.next_page     = NextPage.create( page: p2 )
    p1.previous_page = PreviousPage.create( page: p3 )

    p2.next_page     = NextPage.create( page: p3 )
    p2.previous_page = PreviousPage.create( page: p1 )

    p3.next_page     = NextPage.create( page: p1 )
    p3.previous_page = PreviousPage.create( page: p2 )
  end

  def backup_path
    File.join(App.documents_path, "blottr-backup-#{ Time.now.to_i }.json")
  end

  def backup
    file = File.open(self.backup_path, 'w')

    file.write(backup_json)
    file.flush
    file.close

    file = nil
  end

  def backup_json
    pages = [ ]

    Page.all.each do | p |
      page = { title: p.title,
               notes: [] }

      p.notes.each do | n |
        page[ :notes ] << {
            x:       n.x,
            y:       n.y,
            width:   n.width,
            height:  n.height,
            content: n.content,
        }
      end

      pages << page
    end

    BW::JSON.generate(pages)
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