class Note < CDQManagedObject

  def to_debug
    "#{ object_id }: #{ content }"
  end

  def ui_name
    object_id.to_s
  end

end
