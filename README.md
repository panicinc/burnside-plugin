Burnside Mail Plugin
====================

The Burnside mail plugin adds a character count and twitter handle buttons to a toolbar in Apple Mail

Installation
------------

You can compile the plugin from source or grab a pre-compiled version from the Downloads section. Install it into $HOME/Library/Mail/Bundles. You'll need to execute the following two commands in Terminal to allow Mail to load the plugin.

	defaults write ~/Library/Containers/com.apple.mail/Data/Library/Preferences/com.apple.mail.plist EnableBundles -bool true
	defaults write ~/Library/Containers/com.apple.mail/Data/Library/Preferences/com.apple.mail.plist BundleCompatibilityVersion 4

You may need to execute these commands after each OS or Mail update.

The plugin only becomes active if you're replying to a message to a twitter+ email address. This is the default username used in [burnside](https://github.com/panicinc/burnside).

Configuration
-------------

	defaults write com.apple.Mail Burnside.signature.server " —J"

An example of the signature that's appended by the server. The plugin adds the length of this string to the character count.	

Contributing
------------

Feel free to fork and send us pull requests.

Bug Reporting
-------------

Please file bugs at https://hive.panic.com in the [BurnsidePlugin](https://hive.panic.com/projects/burnside-plugin) project. You have to register first.
