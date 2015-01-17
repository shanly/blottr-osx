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

  def add_note_view( note )
    note_layout = NoteLayout.new( root: self.view, note: note )
    element     = note_layout.build

    name_element( element, "note_view_#{ note.object_id }".to_sym )
  end

end