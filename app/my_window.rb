class MyWindow < NSWindow

  attr_accessor :text_view

  include ScreenHelper

  DIVIDER         = 4

  DIVIDERx1       = DIVIDER * 1
  DIVIDERx2       = DIVIDER * 2
  DIVIDERx3       = DIVIDER * 3
  DIVIDERx4       = DIVIDER * 4

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

  def drawRectangle( rect, color = NSColor.redColor )
    color.set
    NSFrameRectWithWidth( rect, DIVIDERx1 )
  end

  def makeFirstResponder( responder )
    super

    puts responder

    if responder.class == MyTextView
      contentView.subviews.each do | v |
        drawRectangle( adjustedRectangle( v.frame ),
                       0x999999.nscolor )
      end

      highlightTextView( responder )

      self.text_view = responder
    end
  end

  def adjustedRectangle( frame )
    NSMakeRect( frame.origin.x    - DIVIDERx1,
                frame.origin.y    - DIVIDERx1,
                frame.size.width  + DIVIDERx2,
                frame.size.height + DIVIDERx2 )
  end

  def highlightTextView( textView, color = 0x79d2f8.nscolor )
    drawRectangle( adjustedRectangle( textView.superview.superview.frame ),
                   color )
  end

end