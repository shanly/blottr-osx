class MainWindowController < NSWindowController

  attr_accessor :notes, :needs_saving

  def layout
    @layout ||= MainWindowLayout.new
  end

  def init
    super.tap do
      self.window = self.layout.window

      window.setDelegate( self )

      ( 1..5 ).to_a.each do | index |
        text_view( index ).setDelegate( self )
      end

      register_hotkey

      load_notes

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
    ( 1..5 ).each do | index |
      self.notes[ index - 1 ].content = "#{ text_view( index ).string }"

      PersistenceService.save
    end
  end

  def load_notes
    self.notes = PersistenceService.load_notes

    ( 1..5 ).to_a.each do | index |
      text_view( index ).setString( self.notes[ index - 1 ].content )
    end
  end

  def text_view( index )
    @layout.get( "text_view_#{ index }".to_sym )
  end

end
