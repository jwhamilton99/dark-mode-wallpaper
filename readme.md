# Dark Mode Wallpaper Switcher

This is a simple app that switches your wallpaper depending on if you're in light or dark mode.

Made with love by [Justin Hamilton](https://www.jwhamilton.co/).

![screenshot1](/images/1.png)
![screenshot2](/images/2.png)
![screenshot3](/images/3.png)

Get it for free on the [Mac App Store](https://apps.apple.com/us/app/dark-mode-wallpaper-switcher/id1488154568).

*NOTE*: The current version on the App Store is v1.1. v1.2 will be available to download soon.

For App Store reasons, you can view the privacy policy [here](https://github.com/jwhamilton99/dark-mode-wallpaper/blob/master/privacypolicy.md).

A few caveats:

* Due to macOS limitations, I can't change every space's wallpaper at once. Therefore, when you switch spaces, it updates the wallpaper on that space.
* It's a known bug that when updating the wallpaper using the same file URL that points to a different image, it doesn't use the updated image. I've created a workaround for this, and I wrote about it [here](https://medium.com/@jwhamilton99/updating-wallpaper-urls-in-swift-6b014792e8b).
* When using the fade animation, there's a delay between when the wallpaper URL is set and when the wallpaper actually appears on the desktop. I have no way of calculating this, so I added the ability to set each image's delay.

## v1.2 Changelog

New:
* Added proper Open At Login support
* Added an optional fade transition when changing the wallpaper
* Added the ability to adjust the fade delay for each image

Changed:

* Removed Open At Login alert since it's handled automatically
