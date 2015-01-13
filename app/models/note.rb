class Note < CDQManagedObject

  def to_debug
    "#{ object_id }: #{ content }"
  end

end
