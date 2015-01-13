class AppDelegate

  def buildMenu
    @mainMenu = NSMenu.new

    appName   = App.name

    addMenu( appName ) do
      addItemWithTitle( "About #{ appName }",   action: 'orderFrontStandardAboutPanel:',  keyEquivalent: '' )

      addItem( NSMenuItem.separatorItem )

      addItemWithTitle( 'Preferences',          action: 'openPreferences:',               keyEquivalent: ',' )

      addItem( NSMenuItem.separatorItem )

      addItemWithTitle( "Quit #{appName}",      action: 'terminate:',                     keyEquivalent: 'q' )
    end

    addMenu( 'Edit' ) do
      addItemWithTitle( 'Undo',                 action: 'undo:',                          keyEquivalent: 'z' )
      addItemWithTitle( 'Redo',                 action: 'redo:',                          keyEquivalent: 'Z' )

      addItem( NSMenuItem.separatorItem )

      addItemWithTitle( 'Cut',                  action: 'cut:',                           keyEquivalent: 'x' )
      addItemWithTitle( 'Copy',                 action: 'copy:',                          keyEquivalent: 'c' )
      addItemWithTitle( 'Paste',                action: 'paste:',                         keyEquivalent: 'v' )
      addItemWithTitle( 'Delete',               action: 'delete:',                        keyEquivalent: '' )
      addItemWithTitle( 'Select All',           action: 'selectAll:',                     keyEquivalent: 'a' )
    end

    addMenu( 'Split' ) do
      addItemWithTitle( 'Split Horizontally',   action: 'splitH',                         keyEquivalent: '' )
      addItemWithTitle( 'Split Vertically',     action: 'splitV',                         keyEquivalent: '' )
      addItemWithTitle( 'Log',                  action: 'log_layout',                     keyEquivalent: '' )
    end

    NSApp.helpMenu = addMenu('Help') do
      addItemWithTitle( "#{appName} Help",      action: 'showHelp:',                      keyEquivalent: '?' )
    end.menu

    NSApp.mainMenu = @mainMenu
  end

  private

  def addMenu( title, &b )
    item = createMenu( title, &b )

    @mainMenu.addItem item

    item
  end

  def createMenu( title, &b )
    menu = NSMenu.alloc.initWithTitle( title )

    menu.instance_eval( &b ) if b

    item         = NSMenuItem.alloc.initWithTitle( title, action: nil, keyEquivalent: '' )
    item.submenu = menu

    item
  end

end