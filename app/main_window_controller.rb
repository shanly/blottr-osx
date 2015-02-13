class MainWindowController < NSWindowController

  attr_accessor :pages, :current_page, :needs_saving, :selected_note

  def layout
    @layout ||= MainWindowLayout.new
  end

  def init
    super.tap do
      self.window = layout.window

      window.setDelegate( self )

      # Create and add toolbar.
      toolbar = NSToolbar.alloc.initWithIdentifier( 'MyToolbar' )
      toolbar.allowsUserCustomization = true
      toolbar.displayMode             = NSToolbarDisplayModeIconOnly
      toolbar.delegate                = self
      window.toolbar                  = toolbar

      load_pages

      display_current_page

      select_note( notes[ 0 ] )

      register_hotkey

      register_keyboard_listener

      start_saving_timer

      # layout.to_debug
    end
  end

  def display_current_page
    @title_view.cell.stringValue = current_page.title

    self.notes.each do | note |
      @layout.add_note( note, self )
    end
  end

  def clear_current_page
    @layout.clear_page
  end

  def load_pages
    self.pages        = PersistenceService.load_pages
    self.current_page = self.pages[ 0 ]
  end

  def notes
    self.current_page.notes.array
  end


  def next_page( arg )
    self.current_page = self.current_page.next_page.page

    clear_current_page
    display_current_page
  end

  def previous_page( arg )
    self.current_page = self.current_page.previous_page.page

    clear_current_page
    display_current_page
  end

  def new_page( arg )
    new_page = Page.create( title:         'your new page',
                            next_page:     NextPage.create,
                            previous_page: PreviousPage.create )

    new_page.next_page.page     = current_page.next_page.page
    new_page.previous_page.page = current_page

    new_page.notes.create( content: 'start your notes here', height: 8, width: 8, x: 0, y: 0 )

    current_page.next_page.page.previous_page.page = new_page
    current_page.next_page.page = new_page

    self.current_page = new_page

    save

    clear_current_page
    display_current_page
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
                                                                 action:        'show_window',
                                                                 object:        nil )
  end



  def show_window
    layout.show_window
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

      save
    end
  end


  def save
    PersistenceService.save
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

    %w( splitH splitV merge ).each_with_index do | action, index |
      buttonV = layout.button_view( note, action )
      buttonV.setFrameOrigin( NSMakePoint( size_for( note )[ 0 ] - ( 40 * index ) - 40,
                                           0 ) )
    end

    new_note = create_note( content: '...',
                            height: note.height, width: note.width,
                            x: old_x + note.width, y: note.y )

    post_split_actions( new_note )
  end

  def merge( merge_from )
    # sort them to be consistent
    # merge_to = notes.sort_by{ | n | n.x > merge_from.x }.detect do | n |
    merge_to = notes.detect do | n |
      mp "merge_from #{ merge_from.to_debug_position }"
      mp "n          #{ n.to_debug_position }"
      mp '--------------------------------------------'

      merge_from.x + merge_from.width  == n.x && n.height == merge_from.height && merge_from.y == n.y ||
      merge_from.x - merge_from.width  == n.x && n.height == merge_from.height && merge_from.y == n.y ||

      merge_from.y - merge_from.height == n.y && n.width  == merge_from.width  && merge_from.x == n.x ||
      merge_from.y + merge_from.height == n.y && n.width  == merge_from.width  && merge_from.x == n.x
    end

    mp "FOUND = #{merge_to.to_debug_position}"

    if (merge_to)
      if merge_from.height && merge_from.y == merge_to.y
        if merge_to.x < merge_from.x
          merge_to.width += merge_from.width
        else
          merge_to.width += merge_from.width
          merge_to.x     -= merge_from.width
        end
      elsif merge_from.width && merge_from.x == merge_to.x
        if merge_to.y < merge_from.y
          merge_to.height += merge_from.height
        else
          merge_to.height += merge_from.height
          merge_to.y      -= merge_from.height
        end
      end

      mp "width.........#{ merge_to.width }"
      mp "    x.........#{ merge_to.x }"

      layout.remove_note(merge_from)
      merge_from.destroy
      save

      reposition(merge_to)

      select_note(merge_to)
    end
  end


  def post_split_actions( new_note )
    layout.add_note( new_note, self )

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
    layout.scroller_view( note ).setFrameSize(   size_for(   note ) )
    layout.scroller_view( note ).setFrameOrigin( origin_for( note ) )

    layout.text_view( note ).setFrameSize(   size_for(   note ) )

    layout.buttons_view(note).setFrameSize(NSMakeSize(size_for(note).width,
                                                       40))

    layout.buttons_view( note ).setFrameOrigin( NSMakePoint( 0,
                                                             size_for( note )[ 1 ] - 40 ) )

    %w( splitH splitV merge ).each_with_index do | action, index |
      buttonV = layout.button_view( note, action )
      buttonV.setFrameOrigin( NSMakePoint( size_for( note )[ 0 ] - ( 40 * index ) - 40,
                                           0 ) )
    end

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
