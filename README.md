Burnside Mail Plugin
====================

The Burnside mail plugin adds a character count and twitter handle buttons to a toolbar in Apple Mail

Installation
------------

You can compile the plugin from source or grab a pre-compiled version from the Downloads section. Install it into $HOME/Library/Mail/Bundles. You'll need to execute the following two commands in Terminal to allow Mail to load the plugin.

	defaults write ~/Library/Containers/com.apple.mail/Data/Library/Preferences/com.apple.mail.plist EnableBundles -bool true
	defaults write ~/Library/Containers/com.apple.mail/Data/Library/Preferences/com.apple.mail.plist BundleCompatibilityVersion 4

You may need to execute these commands after each OS or Mail update.

Configuration
-------------

Currently there isn't any. The plugin only becomes active if you're replying to a message to a twitter+screename@something email address. This is the default username used in [burnside](https://github.com/panicinc/burnside).

Contributing
------------

Feel free to fork and send us pull requests.

Bug Reporting
-------------

Please file bugs at https://hive.panic.com in the [BurnsidePlugin](https://hive.panic.com/projects/burnside-plugin) project. You have to register first.
