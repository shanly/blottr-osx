class NoteLayout < MyWindowLayout#MotionKit::WindowLayout

  include ScreenHelper

  def initialize( options )
    @note     = options[ :note ]
    @delegate = options[ :delegate ]

    super
  end

  def layout
    size   = note_to_size( @note )

    origin = note_to_origin( @note )

    scroller_name     = @note.text_view_scroller_ui_name
    text_view_name    = @note.text_view_ui_name
    button_view_name  = @note.button_view_ui_name


    add MyScrollView, scroller_name do
      frame [ origin, size ]

      note            @note

      add MyTextView, text_view_name do
        frame   [ [ 0, 0 ], size ]

        minSize [ 0.0, size[ 1 ] ]
        maxSize [ MyConstants::FLT_MAX, MyConstants::FLT_MAX ]

        textContainer.setContainerSize            [ MyConstants::FLT_MAX, MyConstants::FLT_MAX ]
        textContainer.setWidthTracksTextView      false

        note      @note
        setString @note.to_debug_position#content # does not take otherwise

        text_view_styles 'theme' => theme

      end

      add NSView, button_view_name do
        frame           [ [ 0,         size[ 1 ] - 40 ],
                          [ size[ 0 ], 40 ] ]

        setWantsLayer             true
        layer.setBackgroundColor '#ff00ff'.cgcolor

        %w( splitH splitV merge ).each_with_index do | action, index |

          add MyButton, "#{ action }_button"  do
            frame           [ [ size[ 0 ] - ( 40 * index ) - 40, 0 ],
                              [ 40,                              40 ] ]

            button_style    @note, action

            note            @note

            setTarget       self
            setAction       action
          end

        end

        hidden              true
      end

      documentView                              get( "text_view_#{ @note.object_id }".to_sym )

      translatesAutoresizingMaskIntoConstraints false

      text_view_scroller_styles                 'theme' => theme
    end
  end

  def splitH
    @delegate.splitH( @note )
  end

  def splitV
    @delegate.splitV( @note )
  end

  def merge
    @delegate.merge( @note )
  end

  def button_style( note, action )
    button_type     NSMomentaryLightButton

    image_position  NSImageOnly
    # title               note.ui_name

    cell do
      background_color  0x999999.nscolor
      bezelStyle        NSSmallSquareBezelStyle
      image             "#{ action }.png".nsimage
      alignment         NSCenterTextAlignment
      bordered          true
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