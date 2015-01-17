class MyTextView < NSTextView

  def setNote( value )
    @note = value
    setString( value.content )
  end

end