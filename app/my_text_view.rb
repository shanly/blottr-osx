class MyTextView < NSTextView

  def note=( value )
    @note = value
    setString( value.content )
  end

  def mouseDown( event )
    super

    delegate.select_note( @note )
  end

end