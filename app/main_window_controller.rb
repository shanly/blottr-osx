class MainWindowController < NSWindowController

  attr_accessor :pages, :current_page_index, :needs_saving, :selected_note

  def layout
    @layout ||= MainWindowLayout.new
  end

  def init
    super.tap do
      self.window = layout.window

      window.setDelegate( self )


      # Create and add toolbar.
      toolbar = NSToolbar.alloc.initWithIdentifier('MyAwesomeToolbar')
      toolbar.allowsUserCustomization = true
      toolbar.displayMode             = NSToolbarDisplayModeIconOnly
      toolbar.delegate                = self
      window.toolbar                  = toolbar

      load_pages

      display_current_page

      # mp window
      # mp window.contentView
      # mp window.contentView.subviews
      # mp window.contentView.subviews[ 0 ].subviews


      # layout.to_debug


      select_note( notes[ 0 ] )

      register_hotkey

      register_keyboard_listener

      start_saving_timer
    end
  end

  def display_current_page
    self.notes.each do | note |
      @layout.add_note_view( note, self )
    end
  end

  def clear_current_page
    @layout.clear_page
  end

  def load_pages
    self.pages              = PersistenceService.load_pages
    self.current_page_index = 0
  end

  def current_page
    self.pages[ current_page_index ]
  end

  def notes
    current_page.notes.array
  end


  def next_page( arg )
    if current_page_index >= pages.size - 1
      self.current_page_index = 0
    else
      self.current_page_index += 1
    end

    clear_current_page
    display_current_page
  end



  NEXT_BUTTON = 'NextButton'
  PREV_BUTTON = 'PrevButton'


  def toolbar(toolbar, itemForItemIdentifier:identifier, willBeInsertedIntoToolbar:flag)
    if identifier == NEXT_BUTTON || identifier == PREV_BUTTON
      item          = NSToolbarItem.alloc.initWithItemIdentifier(identifier)
      item.label    = 'Search Flickr'

      view = NSButton.alloc.initWithFrame(NSZeroRect)
      view.setTitle  'xxxxx'
      view.target   = self
      view.action   = :"next_page:"
      view.frame    = [[0, 0], [30, 30]]

      item.view     = view
      item
    end
  end

  def toolbarAllowedItemIdentifiers(toolbar)
    [ NEXT_BUTTON, PREV_BUTTON, NSToolbarFlexibleSpaceItemIdentifier, NSToolbarSpaceItemIdentifier, NSToolbarShowFontsItemIdentifier, NSToolbarShowColorsItemIdentifier ]
  end

  def toolbarDefaultItemIdentifiers(toolbar)
    [ NEXT_BUTTON, PREV_BUTTON, NSToolbarFlexibleSpaceItemIdentifier ]
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
    current_page.notes.create( attributes )
  end

  def select_note( note )
    if self.selected_note
      layout.hide_buttons_for ( selected_note )
    end

    self.selected_note = note

    layout.make_focus( note )
  end

end
