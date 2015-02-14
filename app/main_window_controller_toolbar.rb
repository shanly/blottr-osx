class MainWindowController < NSWindowController

  NEXT_BUTTON         = 'next_page'
  PREV_BUTTON         = 'previous_page'
  NEW_PAGE_BUTTON     = 'new_page'
  DELETE_PAGE_BUTTON  = 'delete_page'

  TITLE_FIELD         = 'title'

  MENU_BUTTONS = [ NEXT_BUTTON, PREV_BUTTON, DELETE_PAGE_BUTTON, NEW_PAGE_BUTTON ]

  MENU_DEFINITIONS = {
    NEXT_BUTTON => {
      icon: 'next.png',
      action: 'next_page:'
    },
    PREV_BUTTON => {
      icon: 'previous.png',
      action: 'previous_page:'
    },
    NEW_PAGE_BUTTON => {
      icon: 'new_page.png',
      action: 'new_page:'
    },
    DELETE_PAGE_BUTTON => {
        icon: 'delete_page.png',
        action: 'delete_page:'
    },
  }

  def create_toolbar
    toolbar = NSToolbar.alloc.initWithIdentifier( 'MyToolbar' )

    toolbar.allowsUserCustomization = true
    toolbar.displayMode             = NSToolbarDisplayModeIconOnly
    toolbar.delegate                = self

    window.toolbar                  = toolbar
  end

  def toolbar( toolbar, itemForItemIdentifier: identifier, willBeInsertedIntoToolbar: flag )
    if identifier == TITLE_FIELD
      item          = NSToolbarItem.alloc.initWithItemIdentifier(identifier)
      @title_view   = MyTextField.alloc.initWithFrame(NSZeroRect)

      @title_view.delegate      = self

      @title_view.frame         = [ [0, 0], [ 400, 0 ] ]

      @title_view.setBezeled    true
      @title_view.setBezelStyle NSTextFieldRoundedBezel
      @title_view.setAlignment  NSCenterTextAlignment

      item.view = @title_view

      item
    elsif MENU_BUTTONS.include?( identifier )
      item          = NSToolbarItem.alloc.initWithItemIdentifier( identifier )
      view          = NSButton.alloc.initWithFrame( NSZeroRect )

      view.target   = self
      view.action   = MENU_DEFINITIONS[ identifier ][ :action ]

      view.frame    = [ [ 0, 0 ], [ 30, 30 ] ]

      view.cell.setBezelStyle NSTexturedRoundedBezelStyle

      view.setButtonType      NSMomentaryLightButton

      view.setImagePosition   NSImageOnly
      view.setImage           MENU_DEFINITIONS[ identifier ][ :icon ].nsimage

      item.view = view

      item
    end
  end

  def control( control, textShouldEndEditing: text )
    current_page.title = @title_view.stringValue

    true
  end

  def toolbarAllowedItemIdentifiers(toolbar)
    [ NEXT_BUTTON, PREV_BUTTON, DELETE_PAGE_BUTTON, NEW_PAGE_BUTTON, TITLE_FIELD,
      NSToolbarFlexibleSpaceItemIdentifier, NSToolbarSpaceItemIdentifier, NSToolbarShowFontsItemIdentifier, NSToolbarShowColorsItemIdentifier ]
  end

  def toolbarDefaultItemIdentifiers(toolbar)
    [ PREV_BUTTON, NEXT_BUTTON,
      NSToolbarFlexibleSpaceItemIdentifier, TITLE_FIELD, NSToolbarFlexibleSpaceItemIdentifier,
      DELETE_PAGE_BUTTON, NEW_PAGE_BUTTON ]
  end

  def icon( icon )
    icon = NSMutableAttributedString.alloc.initWithString( icon )

    icon.addAttribute( NSFontAttributeName,
                       value: NSFont.fontWithName( 'Linearicons', size:14 ),
                       range: NSMakeRange( 0, 1 ) )

    icon
  end

end
