class MyTextField < NSTextField

  def becomeFirstResponder
    super.tap do
      currentEditor.setSelectedRange( [ self.stringValue.length,
                                        self.stringValue.length  ] )
    end
  end

end