class AppDelegate

  attr_accessor :status_menu, :application_name

  def applicationDidFinishLaunching( notification )
    @application_name = App.name

    PersistenceService.init

    buildMenu

    @controller = MainWindowController.alloc.init
    @controller.showWindow(self)
    @controller.window.orderFrontRegardless
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
    @controller.hide_window
  end

end
