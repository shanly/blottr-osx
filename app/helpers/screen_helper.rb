module ScreenHelper

  MENU_HEIGHT = 22

  SIZE        = 0.9

  def screen_width
    # @screen_width ||= 800
    @screen_width ||= NSScreen.mainScreen.frame.size.width * SIZE
    # NSScreen.mainScreen.frame.size.width * SIZE
  end

  def screen_height
    # @screen_height ||= 800
    @screen_height ||= ( NSScreen.mainScreen.frame.size.height * SIZE )# - TITLE_HEIGHT
    # ( NSScreen.mainScreen.frame.size.height * SIZE ) - MENU_HEIGHT
  end

  def note_to_size( note )
    width  = screen_width
    height = screen_height

    adjusted_width  = width  - ( 2 * MyConstants::HALF_DIVIDER)
    adjusted_height = height - ( 2 * MyConstants::HALF_DIVIDER) - MENU_HEIGHT

    [ ( adjusted_width  * ( note.width  / 8.0 ) ) - ( MyConstants::HALF_DIVIDER * 2 ),
      ( adjusted_height * ( note.height / 8.0 ) ) - ( MyConstants::HALF_DIVIDER * 2 ) ]
  end

  def note_to_origin( note )
    width  = screen_width
    height = screen_height

    adjusted_width  = width  - ( 2 * MyConstants::HALF_DIVIDER )
    adjusted_height = height - ( 2 * MyConstants::HALF_DIVIDER ) - MENU_HEIGHT

    [ ( adjusted_width  * ( note.x / 8.0 ) ) + MyConstants::HALF_DIVIDER + MyConstants::HALF_DIVIDER,
      ( adjusted_height * ( note.y / 8.0 ) ) + MyConstants::HALF_DIVIDER + MyConstants::HALF_DIVIDER ]
  end

end