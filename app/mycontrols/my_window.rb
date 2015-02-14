class MyWindow < NSWindow

  attr_accessor :text_view

  include ScreenHelper

  def canBecomeKeyWindow
    true
  end

  def full_screen
    setFrame [ [ 0, 0 ], [ screen_width, screen_height ] ],
             display: true

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

    super
  end

  def drawRectangle( rect, color = NSColor.redColor )
    color.set
    NSFrameRectWithWidth( rect, MyConstants::DIVIDERx1 )
  end

  def text_views
    contentView.subviews.first.subviews
  end

  def makeFirstResponder( responder )
    super

    if responder.class == MyTextView
      draw_borders

      highlightTextView( responder )

      self.text_view = responder
    end
  end

  def draw_borders
    text_views.each do | v |
      drawRectangle( adjustedRectangle( v.frame ),
                     MyConstants::BORDER_COLOR.nscolor )
    end
  end

  def adjustedRectangle( frame )
    NSMakeRect( frame.origin.x    - MyConstants::DIVIDERx1,
                frame.origin.y    - MyConstants::DIVIDERx1,
                frame.size.width  + MyConstants::DIVIDERx2,
                frame.size.height + MyConstants::DIVIDERx2 )
  end

  def highlightTextView( textView, color = MyConstants::HIGHLIGHT_COLOR.nscolor )
    drawRectangle( adjustedRectangle( textView.superview.superview.frame ),
                   color )
  end

end