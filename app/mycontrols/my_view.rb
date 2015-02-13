class MyView < NSView

  def debug_highlight( color = '#ff00ff' )
    setWantsLayer             true
    layer.setBackgroundColor color.cgcolor
  end

end