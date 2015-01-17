class NoteLayout < MotionKit::WindowLayout

  include ScreenHelper

  attr_accessor :note

  def initialize( options )
    self.note = options[ :note ]

    super
  end

  def layout
    size   = note_to_size( note )

    origin = note_to_origin( note )

    add MyScrollView, "text_view_#{ @note.object_id }_scroller".to_sym do

      frame [origin, size]

      add(MyTextView, "text_view_#{ @note.object_id }".to_sym) do
        frame [[0, 0], size]

        minSize [0.0, size[1]]
        maxSize [MyConstants::FLT_MAX, MyConstants::FLT_MAX]

        textContainer.setContainerSize [MyConstants::FLT_MAX, MyConstants::FLT_MAX]
        textContainer.setWidthTracksTextView false #true

        translatesAutoresizingMaskIntoConstraints false

        setNote   note
        setString note.content # does not take otherwise

        text_view_styles 'theme' => theme
      end

      add NSButton, :"#{ @note.object_id }_button".to_sym do
        frame                                     [ [ 0, size[ 1 ] - 100 ], [ 200, 100 ] ]

        button_style( "#{ @note.object_id }_button", 'splitH' )
      end

      documentView get("text_view_#{ @note.object_id }".to_sym)

      translatesAutoresizingMaskIntoConstraints false

      text_view_scroller_styles 'theme' => theme
    end

  end

  def button_style( title, action )
    setTarget window.delegate
    setAction action

    button_type NSMomentaryLightButton

    image_position  NSImageOnly
    # setShowsBorderOnlyWhileMouseInside true

    cell do
      background_color 0x999999.nscolor
      # title       title
      bezelStyle  NSSmallSquareBezelStyle
      image       'arrows-h_000000_64.png'.nsimage
      # alignment NSCenterTextAlignment
      bordered    true
      # setOpaque           false
      # alpha_value         0.75
    end
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

  def text_view_scroller_styles( options = { } )
    hasVerticalScroller         true
    hasHorizontalScroller       false

    opaque                      true

    autoresizingMask            NSViewWidthSizable | NSViewHeightSizable
  end


  THEME = {
      '1' => { 'bg' => 0xFFFFFF, 'fg' => 0x000000 },
      '2' => { 'bg' => 0xFFFFFF, 'fg' => 0x000000 },
      '3' => { 'bg' => 0xFFFFFF, 'fg' => 0x000000 },
      '4' => { 'bg' => 0xFFFFFF, 'fg' => 0x000000 },
      '5' => { 'bg' => 0xFFFFFF, 'fg' => 0x000000 },
  }

  def theme
    THEME[ ( ( @note.object_id % 4 ) + 1 ).to_s ]
  end

end