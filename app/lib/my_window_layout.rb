class MyWindowLayout < MotionKit::WindowLayout

  def to_debug
    mp debug_elements
  end

  def debug_elements
    result = @elements.map do | k,v |
      [ k, Array( v ).size, Array( v ).map { | o | o.class < MyWindowLayout ? o.debug_elements : "#{ o.class.to_s } #{ ' < ' + o.tag.to_s + ' ' + o.superview.class.to_s if o.class < NSView }" } ]
    end

    result
  end

end