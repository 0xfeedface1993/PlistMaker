# PlistMaker
Create enterprise app distrubution plist file, large &amp; small image.

## Usage 

Just download my code, Command + R.

![satrt](http://oqedp1ccg.bkt.clouddn.com/startpage.png)

### Bundle Identifier

It should be `com.appple.app` like, name of ipa file is last component of Bundle Identifier, that mean `app` in `com.appple.app`.

### Image Name (图片名)

Any name you like, but without extension.

### App Name (应用名称)

Your app name, it will present to user when download app, not the app real name on desktop.

### IPA path & Image Path (ipa 文件夹路径 & 图片文件夹路径)

When download enterprise iOS app, developer need provide software-package (ipa file) & full-size-image & display-image URL path in plist file.
If your ipa path is `https://www.apple.com/enterprise/qq.ipa`, IPA path should be `https://www.apple.com/enterprise`.
If your image path is `https://www.apple.com/enterprise/img/qql.png`, IPA path should be `https://www.apple.com/enterprise/img`.

### App Icon (应用图标)

Drag jpeg or png file from Finder to plus image area.

![demo](http://oqedp1ccg.bkt.clouddn.com/dragdemogif.gif)

> if gif not show up, you can direct visit http://oqedp1ccg.bkt.clouddn.com/dragdemogif.gif.

## Export

This app will generate 1 plist file, 2 png file. 
If png file name suffix is `l`, it is 512x512 size large image(full-size-image).
If png file name suffix is `s`, it is 58x58 size small image(display-image).

Put this file in your server, all is well!

Have a good day!
