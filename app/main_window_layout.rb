class MainWindowLayout < MyWindowLayout

  include ScreenHelper

  def layout
    root( MyWindow, :window ) do
      full_screen

      add MyPage, :page do
        frame   [ [ 0, 0 ],
                  [ screen_width, screen_height - MENU_HEIGHT ] ]
      end
    end
  end

  def window_style
    title               App.name
    styleMask           NSTitledWindowMask
    background_color    MyConstants::HIGHLIGHT_COLOR.nscolor

    setOpaque           false
    alpha_value         0.75
  end




  def text_view( note )
    note_view_layout( note ).get( note.text_view_ui_name )
  end

  def buttons_view( note )
    note_view_layout( note ).get( note.button_view_ui_name ) if note_view_layout( note )
  end

  def button_view( note, action )
    note_view_layout( note ).get( "#{ action }_button" )
  end

  def scroller_view( note )
    note_view_layout( note ).get( note.text_view_scroller_ui_name )
  end

  def note_view_layout( note )
    get( note.note_view_layout_ui_name )
  end



  def hide_buttons_for( note )
    buttons_view( note ).hidden = true  if buttons_view( note )
  end

  def show_buttons_for( note )
    buttons_view( note ).hidden = false if buttons_view( note )
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

  def show_window
    NSApp.activateIgnoringOtherApps( true )

    window.full_screen

    window.makeKeyAndOrderFront( self )
  end

  def toggle_window
    if window.isVisible
      hide_window
    else
      show_window
    end
  end


  def add_note_view( note, delegate )
    note_layout = NoteLayout.new( root:     get( :page ),
                                  note:     note,
                                  delegate: delegate )

    note_layout.build

    name_element( note_layout, note.note_view_layout_ui_name )

    note_layout.get( note.text_view_ui_name ).delegate = delegate
  end

  def clear_page

    context view do

      get( :page ).subviews.dup.each do | note_view |
        get( note_view.note.note_view_layout_ui_name ).get( note_view.note.text_view_ui_name ).delegate = nil
        get( note_view.note.note_view_layout_ui_name ).remove( note_view.note.text_view_ui_name )
        get( note_view.note.note_view_layout_ui_name ).remove( note_view.note.text_view_scroller_ui_name )

        forget( note_view.note.note_view_layout_ui_name )
      end
    end
  end

end