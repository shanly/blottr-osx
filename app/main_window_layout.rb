class MainWindowLayout < MotionKit::WindowLayout

  DIVIDER         = 6

  DIVIDERx1       = DIVIDER * 1
  DIVIDERx2       = DIVIDER * 2
  DIVIDERx3       = DIVIDER * 3
  DIVIDERx4       = DIVIDER * 4

  FLT_MAX         = 999999999 # 3.40282347E+38

  view :text_view_1
  view :text_view_2
  view :text_view_3
  view :text_view_4
  view :text_view_5

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

  THEME = PLAIN_THEME

  def layout
    root( MyWindow, :window ) do
      full_screen

      add_text_view( '1',
                     origin: [ DIVIDERx1, DIVIDERx1 ],
                     size:   [ window_size.width * 0.5 - DIVIDERx2, window_size.height - DIVIDERx2 - 2 ] )

      add_text_view( '2',
                     origin: [ window_size.width * 0.5, window_size.height * 0.5 + DIVIDERx2 ],
                     size:   [ window_size.width * 0.5 - DIVIDERx1, window_size.height * 0.5 - DIVIDERx3 - 2 ] )

      add_text_view( '3',
                     origin: [ window_size.width * 0.50, DIVIDERx1 ],
                     size:   [ window_size.width * 0.25 - DIVIDERx1, window_size.height * 0.5 ] )

      add_text_view( '4',
                     origin: [ window_size.width * 0.75, DIVIDERx1 ],
                     size:   [ window_size.width * 0.25 - DIVIDERx1, window_size.height * 0.25 - DIVIDERx1 ] )

      add_text_view( '5',
                     origin: [ window_size.width * 0.75, window_size.height * 0.25 + DIVIDERx1 ],
                     size:   [ window_size.width * 0.25 - DIVIDERx1, window_size.height * 0.25 ] )
    end
  end


  def add_text_view( identifier, options )
    add NSScrollView, "text_view_#{ identifier }_scroller".to_sym do

      frame [ options[ :origin ], options[ :size ] ]

      add( MyTextView, "text_view_#{ identifier }".to_sym ) do
        frame                                 [ [ 0, 0 ], options[ :size ] ]

        minSize                               [ 0.0, options[ :size ][ 1 ] ]
        maxSize                               [ FLT_MAX, FLT_MAX ]

        textContainer.setContainerSize        [ options[ :size ][ 0 ], FLT_MAX ]
        textContainer.setWidthTracksTextView  false#true
      end

      documentView get( "text_view_#{ identifier }".to_sym )
    end
  end

  def window_style
    title               App.name
    styleMask           NSBorderlessWindowMask#NSTitledWindowMask
    background_color    0x999999.nscolor#NSColor.blackColor
  end

  def text_view_1_style
    text_view_styles( 'theme' => THEME[ '1' ] )
  end

  def text_view_2_style
    text_view_styles( 'theme' => THEME[ '2' ] )
  end

  def text_view_3_style
    text_view_styles( 'theme' => THEME[ '3' ] )
  end

  def text_view_4_style
    text_view_styles( 'theme' => THEME[ '4' ] )
  end

  def text_view_5_style
    text_view_styles( 'theme' => THEME[ '5' ] )
  end

  def text_view_1_scroller_style
    text_view_scroller_styles( 'theme' => THEME[ '1' ] )
  end

  def text_view_2_scroller_style
    text_view_scroller_styles( 'theme' => THEME[ '2' ] )
  end

  def text_view_3_scroller_style
    text_view_scroller_styles( 'theme' => THEME[ '3' ] )
  end

  def text_view_4_scroller_style
    text_view_scroller_styles( 'theme' => THEME[ '4' ] )
  end

  def text_view_5_scroller_style
    text_view_scroller_styles( 'theme' => THEME[ '5' ] )
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

    font                          NSFont.fontWithName( 'Helvetica Neue', size: 14 )

    insertionPointColor           NSColor.blueColor
  end

end