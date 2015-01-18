class MainWindowController < NSWindowController

  attr_accessor :notes, :needs_saving, :selected_note

  def layout
    @layout ||= MainWindowLayout.new
  end

  def init
    super.tap do
      self.window = layout.window

      window.setDelegate( self )

      load_notes

      notes.each do | note |
        @layout.add_note_view( note, self )
      end

      select_note( notes[ 0 ] )

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



  def hide_window
    layout.hide_window
  end

  def toggle_window
    layout.toggle_window
  end


  def register_keyboard_listener
    @key_down_handler = Proc.new do | event |
      @needs_saving = true

      if event.keyCode == 53
        hide_window
        nil
      else
        event
      end
    end

    NSEvent.addLocalMonitorForEventsMatchingMask( NSKeyDownMask, handler: @key_down_handler )
  end

  def save_notes
    notes.each do | note |
      note.content = "#{ layout.text_view( note ).string }"

      PersistenceService.save
    end
  end

  def load_notes
    self.notes = PersistenceService.load_notes
  end








  def splitH( note )
    return if note.height <= 1

    buttons     = layout.buttons_view( note )

    old_y       = note.y

    note.height = note.height / 2
    note.y      = note.y      + note.height

    reposition( note )

    buttons.setFrameOrigin( NSMakePoint( 0,
                                         size_for( note )[ 1 ] - 40 ) )

    new_note = create_note( content: '...',
                            height: note.height, width: note.width,
                            x: note.x, y: old_y )

    post_split_actions( new_note )
  end

  def splitV( note )
    return if note.width <= 1

    old_x       = note.x

    note.width = note.width / 2

    reposition( note )

    %w( splitH splitV ).each_with_index do | action, index |
      buttonV = layout.button_view( note, action )
      buttonV.setFrameOrigin( NSMakePoint( size_for( note )[ 0 ] - ( 40 * index ) - 40,
                                           0 ) )
    end

    new_note = create_note( content: '...',
                            height: note.height, width: note.width,
                            x: old_x + note.width, y: note.y )

    post_split_actions( new_note )
  end



  def post_split_actions( new_note )
    layout.add_note_view( new_note, self )

    select_note( new_note )

    save_notes
  end

  def size_for( note )
     NSMakeSize( layout.note_to_size( note )[ 0 ],
                 layout.note_to_size( note )[ 1 ] )
  end

  def origin_for( note )
    NSMakePoint( layout.note_to_origin( note )[ 0 ],
                 layout.note_to_origin( note )[ 1 ] )
  end

  def reposition( note )
    layout.scroller( note ).setFrameSize(   size_for(   note ) )
    layout.scroller( note ).setFrameOrigin( origin_for( note ) )
  end

  def create_note( attributes )
    new_note = Note.create( attributes )

    self.notes = self.notes.dup
    self.notes << new_note

    new_note
  end

  def select_note( note )
    if self.selected_note
      layout.hide_buttons_for ( selected_note )
    end

    self.selected_note = note

    layout.make_focus( note )
  end

end
