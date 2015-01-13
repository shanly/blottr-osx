class MyTextView < NSTextView

  attr_accessor :note

  def note=( value )
    @note = value
    setString( value.content )
  end

end