class MainWindowLayout < MotionKit::WindowLayout

  include ScreenHelper

  def layout
    root( MyWindow, :window ) do
      full_screen
    end
  end

  def window_style
    title               App.name
    styleMask           NSBorderlessWindowMask#NSTitledWindowMask
    background_color    MyConstants::HIGHLIGHT_COLOR.nscolor

    setOpaque           false
    alpha_value         0.75
  end




  def text_view( note )
    note_view( note ).get( "text_view_#{ note.ui_name }".to_sym )
  end

  def scroller( note )
    note_view( note ).get( "text_view_#{ note.ui_name }_scroller".to_sym )
  end

  def buttons_view( note )
    note_view( note ).get( :button_container )
  end

  def note_view( note )
    get( "note_view_#{ note.ui_name }".to_sym )
  end

  def button_view( note, action )
    note_view( note ).get( "#{ action }_button" )
  end



  def hide_buttons_for( note )
    buttons_view( note ).hidden = true
  end

  def show_buttons_for( note )
    buttons_view( note ).hidden = false
  end


  def make_focus( note )
    window.makeFirstResponder( text_view( note ) )

    show_buttons_for( note )
  end



  def hide_window
    if window.isVisible
      window.orderOut( false )
    end
  end

  def toggle_window
    if window.isVisible
      hide_window
    else
      NSApp.activateIgnoringOtherApps( true )

      window.full_screen

      window.makeKeyAndOrderFront( self )
    end
  end


  def add_note_view( note, delegate )
    note_layout = NoteLayout.new( root: self.view, note: note )
    element     = note_layout.build

    name_element( element, "note_view_#{ note.ui_name }".to_sym )

    text_view( note ).delegate = delegate
  end

end