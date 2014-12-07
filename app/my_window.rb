class MyWindow < NSWindow

  include ScreenHelper

  def canBecomeKeyWindow
    true
  end

  def full_screen
    setFrame [ [ 0, 0 ], [ screen_width, screen_height ] ], display: true

    self.center
  end

  def window_size
    frame.size
  end

  def drawInsertionPointInRect( aRect, color: aColor, turnedOn: flag )
    aRect.origin.y    -= 5
    aRect.origin.x    -= 5
    aRect.size.width  += 5
    aRect.size.height += 5

    # [super drawInsertionPointInRect:aRect color:aColor turnedOn:flag];
    #
    # }
    super
  end


end