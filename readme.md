# Dark Mode Wallpaper Switcher

This is a simple app that switches your wallpaper depending on if you're in light or dark mode.

Made with love by [Justin Hamilton](https://www.jwhamilton.co/).

![screenshot1](/images/1.png)
![screenshot2](/images/2.png)
![screenshot3](/images/3.png)

Get it for free on the [Mac App Store](https://apps.apple.com/us/app/dark-mode-wallpaper-switcher/id1488154568).

For App Store reasons, you can view the privacy policy [here](https://github.com/jwhamilton99/dark-mode-wallpaper/blob/master/privacypolicy.md).

A few caveats:

* Due to macOS limitations, I can't change every space's wallpaper at once. Therefore, when you switch spaces, it updates the wallpaper on that space.
* It's a known bug that when updating the wallpaper using the same file URL that points to a different image, it doesn't use the updated image. I've created a workaround for this, and I wrote about it [here](https://medium.com/@jwhamilton99/updating-wallpaper-urls-in-swift-6b014792e8b).
* When using the fade animation, there's a delay between when the wallpaper URL is set and when the wallpaper actually appears on the desktop. I have no way of calculating this, so I added the ability to set each image's delay.

## v1.3.1 Changelog

Dark Mode Wallpaper Switcher is now compiled for both Intel and Apple Silicon processors, and will run natively on both. This update also includes improvements for Big Sur.

Added:
- Redesigned the icon to fit better in Big Sur
- Added native Apple Silicon support

Changed:
- Redesigned the About window
- Removed placeholder assets that were left in the app

## License

Copyright 2021 Justin Hamilton

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
