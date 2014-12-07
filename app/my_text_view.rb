class MyTextView < NSTextView

  def drawInsertionPointInRect( aRect, color: aColor, turnedOn: flag )
    # aRect.origin.y    -= 1
    # aRect.origin.x    -= 1
    # aRect.size.width  += 1
    # aRect.size.height += 1

    super
  end

  def _drawInsertionPointInRect( aRect, color: aColor, turnedOn: flag )
    # aRect.origin.y    -= 1
    # aRect.origin.x    -= 1
    # aRect.size.width  += 1
    # aRect.size.height += 1

    super
  end

end