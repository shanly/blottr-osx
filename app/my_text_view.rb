class MyTextView < NSTextView

  def note=( value )
    @note = value
    setString( value.content )
  end

end