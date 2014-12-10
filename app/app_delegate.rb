class AppDelegate

  attr_accessor :status_menu, :application_name

  def applicationDidFinishLaunching( notification )
    @application_name = App.name

    PersistenceService.init

    # trustApplication

    buildMenu

    @controller = MainWindowController.alloc.init
    @controller.showWindow(self)
    @controller.window.orderFrontRegardless
  end

  def trustApplication
    keys = Pointer.new( :object )
    keys.assign( KAXTrustedCheckOptionPrompt )

    values = Pointer.new( :object )
    values.assign( true )

    options = CFDictionaryCreate( KCFAllocatorDefault,
                                  keys,
                                  values,
                                  1,
                                  nil,
                                  nil )

    puts "trusted: #{ AXIsProcessTrustedWithOptions( options ) }"
  end

  # def build_menu
  #   @status_menu = NSMenu.new
  #
  #   @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength).init
  #   @status_item.setMenu(status_menu)
  #   @status_item.setHighlightMode(true)
  #   @status_item.setTitle(application_name)
  #
  #   @status_menu.addItem createMenuItem( "About #{ application_name }", 'orderFrontStandardAboutPanel:')
  #   @status_menu.addItem createMenuItem( 'Custom Action',               'pressAction', 'c'  )
  #   @status_menu.addItem createMenuItem( 'Quit',                        'terminate:' )
  # end

  def pressAction
    puts 'pressAction'
  end

  def createMenuItem( name, action, keyEquivalent = '' )
    NSMenuItem.alloc.initWithTitle( name, action: action, keyEquivalent: keyEquivalent )
  end

  def applicationDidResignActive( notification )
    @controller.toggle_window
  end

end
