class MyTextField < NSTextField

  def becomeFirstResponder
    result = super

    currentEditor.setSelectedRange( [ self.stringValue.length, self.stringValue.length  ] )

    result
  end

end