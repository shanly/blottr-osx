module ScreenHelper

  TITLE_HEIGHT    = 20
  SIZE            = 0.9

  def screen_width
    @screen_width = 800#||= NSScreen.mainScreen.frame.size.width * SIZE
  end

  def screen_height
    @screen_height = 800 #||= ( NSScreen.mainScreen.frame.size.height * SIZE) - TITLE_HEIGHT
  end

end