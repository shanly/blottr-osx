class Page < CDQManagedObject

  def to_debug
    "#{ object_id }: #{ title }"
  end

  def ui_name
    object_id.to_s
  end

end
