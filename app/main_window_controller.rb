class MainWindowController < NSWindowController

  attr_accessor :notes, :needs_saving

  def layout
    @layout ||= MainWindowLayout.new
  end

  def init
    super.tap do
      self.window = self.layout.window

      window.setDelegate( self )

      load_notes

      notes.each do | note |
        @layout.add_text_view(note)

        text_view( note.object_id.to_s ).setDelegate( self )
      end

      register_hotkey

      register_keyboard_listener

      start_saving_timer
    end
  end

  def start_saving_timer
    5.second.every do
      if @needs_saving
        @needs_saving = false
        save_notes
      end
    end
  end

  def register_hotkey
    DDHotKeyCenter.sharedHotKeyCenter.registerHotKeyWithKeyCode( KVK_ANSI_N,
                                                                 modifierFlags: NSControlKeyMask | NSAlternateKeyMask,
                                                                 target:        self,
                                                                 action:        'toggle_window',
                                                                 object:        nil )
  end

  def register_other_hotkey
    @key_down_handler = Proc.new do | event |
      event
    end

    NSEvent.addGlobalMonitorForEventsMatchingMask( NSKeyDownMask, handler: @key_down_handler )
  end

  def toggle_window
    if window.isVisible
      window.orderOut( false )
    else
      NSApp.activateIgnoringOtherApps( true )

      window.full_screen

      window.makeKeyAndOrderFront( self )
    end
  end

  def register_keyboard_listener
    @key_down_handler = Proc.new do | event |
      @needs_saving = true

      if event.keyCode == 53
        toggle_window
        nil
      else
        event
      end
    end

    NSEvent.addLocalMonitorForEventsMatchingMask( NSKeyDownMask, handler: @key_down_handler )
  end

  def save_notes
    notes.each do | note |
      note.content = "#{ text_view( note.object_id ).string }"

      PersistenceService.save
    end
  end

  def load_notes
    self.notes = PersistenceService.load_notes

    puts "#{notes.size}"
  end

  def text_view( index )
    @layout.get( "text_view_#{ index }".to_sym )
  end

  def scroller( index )
    @layout.get( "text_view_#{ index }_scroller".to_sym )
  end

  def splitH
    text_view   = window.text_view
    scroller    = text_view.superview.superview
    note        = text_view.note

    return if note.height <= 1

    old_y       = note.y

    note.height = note.height / 2
    note.y      = note.y      + note.height

    new_size   = NSMakeSize( layout.note_to_size( note )[ 0 ],
                             layout.note_to_size( note )[ 1 ] )
    new_origin = NSMakePoint( layout.note_to_origin( note )[ 0 ],
                              layout.note_to_origin( note )[ 1 ] )

    scroller.setFrameSize(   new_size )
    scroller.setFrameOrigin( new_origin )

    new_note = create_note( content: '...',
                            height: note.height, width: note.width,
                            x: note.x, y: old_y )

    @layout.add_text_view( new_note )

    window.makeFirstResponder( text_view( new_note.object_id.to_s ) )

    save_notes
  end

  def splitV
    text_view   = window.text_view
    scroller    = text_view.superview.superview
    note        = text_view.note

    return if note.width <= 1

    old_x       = note.x

    note.width = note.width / 2

    new_size   = NSMakeSize( layout.note_to_size( note )[ 0 ],
                             layout.note_to_size( note )[ 1 ] )
    new_origin = NSMakePoint( layout.note_to_origin( note )[ 0 ],
                              layout.note_to_origin( note )[ 1 ] )

    scroller.setFrameSize(   new_size )
    scroller.setFrameOrigin( new_origin )

    new_note = create_note( content: '...',
                            height: note.height, width: note.width,
                            x: old_x + note.width, y: note.y )

    @layout.add_text_view( new_note )

    window.makeFirstResponder( text_view( new_note.object_id.to_s ) )

    save_notes
  end

  def create_note( attributes )
    new_note = Note.create( attributes )

    self.notes = self.notes.dup
    self.notes << new_note


    new_note
  end

  def log_layout
    notes.each_with_index do | note, index |
      scroller   = scroller( index + 1 )
      text_view  = text_view(  index + 1 )

      next if scroller.nil?

      puts '-----------------------------------------------'
      puts "#{ index + 1 } X       #{ scroller.frame.origin.x }"
      puts "#{ index + 1 } Y       #{ scroller.frame.origin.y }"
      puts "#{ index + 1 } WIDTH   #{ scroller.width }"
      puts "#{ index + 1 } HEIGHT  #{ scroller.height }"

      puts "#{ index + 1 } X       #{ text_view.frame.origin.x }"
      puts "#{ index + 1 } Y       #{ text_view.frame.origin.y }"
      puts "#{ index + 1 } WIDTH   #{ text_view.width }"
      puts "#{ index + 1 } HEIGHT  #{ text_view.height }"
    end

  end

end
