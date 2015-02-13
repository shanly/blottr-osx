class Note < CDQManagedObject

  def to_debug
    "#{ object_id }: #{ content }"
  end

  def ui_name
    object_id.to_s
  end

  def text_view_ui_name
    "text_view_#{ self.ui_name }".to_sym
  end

  def note_view_ui_name
    "note_view_#{ self.ui_name }".to_sym
  end

  def note_view_layout_ui_name
    "note_view_layout_#{ self.ui_name }".to_sym
  end

  def text_view_scroller_ui_name
    "text_view_#{ self.note_view_ui_name }_scroller".to_sym
  end

  def button_view_ui_name
    "button_view_#{ self.note_view_ui_name }".to_sym
  end

  def to_debug_position
    "#{ object_id } | x: #{ x }, y: #{ y } - height: #{ height }, width: #{ width }"
  end

end
