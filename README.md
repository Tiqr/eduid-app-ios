# eduID

## Localizing eduID

eduID is available in a number of languages. To facilitate handling updates to the needed localizations Xcode Localization Catalogs (folder with .xcloc extension) are used. These can be edited with Xcode or any other text editor to update the localization.

To export localization catalogs use: 

    xcodebuild -exportLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations -includeScreenshots -exportLanguage da -exportLanguage de -exportLanguage en -exportLanguage es -exportLanguage fr -exportLanguage fy -exportLanguage hr -exportLanguage it -exportLanguage ja -exportLanguage nb -exportLanguage nl -exportLanguage pt -exportLanguage ro -exportLanguage sk -exportLanguage sl -exportLanguage sr -exportLanguage sv

To import localization catalogs use:

    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/da.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/de.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/en.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/es.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/fr.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/fy.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/hr.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/it.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/ja.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/nb.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/nl.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/pt.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/ro.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/sk.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/sl.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/sr.xcloc
    xcodebuild -importLocalizations -project eduID.xcodeproj -sdk iphoneos16.1 -localizationPath localizations/sv.xcloc

Note that Xcode provides these actions also in its UI, but omits the option to set the SDK which makes the export fail due to defaulting to macOS, which is unsupported.
