class MainWindowLayout < MotionKit::WindowLayout

  THEME_TEST = {
      '1' => { 'bg' => 0xFF0000, 'fg' => 0x000000 },
      '2' => { 'bg' => 0x00FF00, 'fg' => 0x000000 },
      '3' => { 'bg' => 0x0000FF, 'fg' => 0x000000 },
      '4' => { 'bg' => 0xFF00FF, 'fg' => 0x000000 },
      '5' => { 'bg' => 0x00FFFF, 'fg' => 0x000000 },
  }

  # https://color.adobe.com/Beetle-Bus-goes-Jamba-Juice-color-theme-1435983/
  BEETLE_BUS_GOES_JAMBA_JUICE_ = {
      '1' => { 'bg' => 0x730046, 'fg' => 0x000000 },
      '2' => { 'bg' => 0xBFBB11, 'fg' => 0x000000 },
      '3' => { 'bg' => 0xFFC200, 'fg' => 0x000000 },
      '4' => { 'bg' => 0xE88801, 'fg' => 0x000000 },
      '5' => { 'bg' => 0xC93C00, 'fg' => 0x000000 },
  }

  # https://color.adobe.com/Pistachio-color-theme-16814/
  PISTACHIO_COLOR_THEME = {
      '1' => { 'bg' => 0xB0CC99, 'fg' => 0x000000 },
      '2' => { 'bg' => 0x677E52, 'fg' => 0x000000 },
      '3' => { 'bg' => 0xB7CA79, 'fg' => 0x000000 },
      '4' => { 'bg' => 0xF6E8B1, 'fg' => 0x000000 },
      '5' => { 'bg' => 0x89725B, 'fg' => 0x000000 },
  }

  PLAIN_THEME = {
      '1' => { 'bg' => 0xFFFFFF, 'fg' => 0x000000 },
      '2' => { 'bg' => 0xFFFFFF, 'fg' => 0x000000 },
      '3' => { 'bg' => 0xFFFFFF, 'fg' => 0x000000 },
      '4' => { 'bg' => 0xFFFFFF, 'fg' => 0x000000 },
      '5' => { 'bg' => 0xFFFFFF, 'fg' => 0x000000 },
  }

  THEME = PISTACHIO_COLOR_THEME

  def layout
    root( MyWindow, :window ) do
      full_screen
    end
  end

  def window_style
    title               App.name
    styleMask           NSBorderlessWindowMask#NSTitledWindowMask
    background_color    MyConstants::HIGHLIGHT_COLOR.nscolor

    setOpaque           false
    alpha_value         0.75
  end

  def text_view_scroller_styles( options = { } )
    hasVerticalScroller         true
    hasHorizontalScroller       false

    opaque                      true

    autoresizingMask            NSViewWidthSizable | NSViewHeightSizable
  end

  def text_view_styles( options = { } )
    background_color              ( options[ 'theme' ][ 'bg'] || 0xFF0000 ).nscolor

    textColor                     ( options[ 'theme' ][ 'fg'] || 0xFF0000 ).nscolor

    editable                      true
    selectable                    true
    automaticLinkDetectionEnabled true
    allowsUndo                    true
    richText                      false

    font                          NSFont.fontWithName( 'Helvetica Neue', size: 14 )

    insertionPointColor           NSColor.blueColor
  end

  def add_text_view( note )
    size   = note_to_size( note )

    origin = note_to_origin( note )

    context self.view do

      add MyScrollView, "text_view_#{ note.object_id }_scroller".to_sym do

        frame [ origin, size ]

        add( MyTextView, "text_view_#{ note.object_id }".to_sym ) do
          frame                                     [ [ 0, 0 ], size ]

          minSize                                   [ 0.0, size[ 1 ] ]
          maxSize                                   [ MyConstants::FLT_MAX, MyConstants::FLT_MAX ]

          textContainer.setContainerSize            [ MyConstants::FLT_MAX, MyConstants::FLT_MAX ]
          textContainer.setWidthTracksTextView      false#true

          translatesAutoresizingMaskIntoConstraints false

          note                                      note

          setString                                 note.content

          text_view_styles                          'theme' => theme( note )
        end

        documentView                              get( "text_view_#{ note.object_id }".to_sym )

        translatesAutoresizingMaskIntoConstraints false

        text_view_scroller_styles                 'theme' => theme( note )
      end

    end

  end

  def note_to_size( note )
    width  = 800
    height = 800

    adjusted_width  = width  - ( 2 * MyConstants::HALF_DIVIDER)
    adjusted_height = height - ( 2 * MyConstants::HALF_DIVIDER)

     [ ( adjusted_width  * ( note.width  / 8.0 ) ) - ( MyConstants::HALF_DIVIDER * 2 ),
       ( adjusted_height * ( note.height / 8.0 ) ) - ( MyConstants::HALF_DIVIDER * 2 ) ]
  end

  def note_to_origin( note )
    width  = 800
    height = 800

    adjusted_width  = width  - ( 2 * MyConstants::HALF_DIVIDER)
    adjusted_height = height - ( 2 * MyConstants::HALF_DIVIDER)

     [ ( adjusted_width  * ( note.x / 8.0 ) ) + MyConstants::HALF_DIVIDER + MyConstants::HALF_DIVIDER,
       ( adjusted_height * ( note.y / 8.0 ) ) + MyConstants::HALF_DIVIDER + MyConstants::HALF_DIVIDER]
  end

  def theme( note )
    THEME[ ( ( note.object_id % 4 ) + 1 ).to_s ]
  end

end