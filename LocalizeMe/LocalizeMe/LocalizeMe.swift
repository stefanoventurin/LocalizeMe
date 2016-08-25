//
//  LocalizeMe.swift
//  LocalizeMe
//
//  Created by Stefano Venturin on 04/08/16.
//  Copyright (c) 2016 Stefano Venturin. All rights reserved.
//
/* Written in Swift 3.0 */

import Foundation

// Base bundle as fallback.
let LCLBaseBundle = "Base"
// Current language
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"
// Default language is English. Defaults to base localization if English is unavailable.
let LCLDefaultLanguage = "en"
// Name for language change notification
public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"


// MARK: - Language Functions
public class LocalizeMe: NSObject {
    
    /// List of available languages, returns an Array of the available languages,
    /// If excludeBase = true, don't show 'Base' in available languages.
    public class func availableLanguage(_ excludeBase: Bool = false) -> [String] {
        var availableLanguage = Bundle.main.localizations
        if let indexOfBase = availableLanguage.index(of: "Base"), excludeBase == true {
            availableLanguage.remove(at: indexOfBase)
        }
        return availableLanguage
    }
    
    /// Return the current language
    public class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    /// Change the current language, parameter language: Desired language.
    public class func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguage().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        }
    }
    
    /// Returns the apps default language.
    public class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguage()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        } else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    /// Resets the current language to default.
    public class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    /// Returns a localized string for a specified language code.
    /// Eg: for "it" --> "Italian".
    public class func displayNameForLanguage(language: String) -> String {
        let locale : Locale = Locale(identifier: currentLanguage())
        if let displayName = locale.localizedString(forLanguageCode: language) {
            return displayName
        }
        return String()
    }
}


// MARK: - Extension
public extension String {
 
    /// Return the localized string
    func localizeMe() -> String {
        if let path = Bundle.main.path(forResource: LocalizeMe.currentLanguage(), ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        else if let path = Bundle.main.path(forResource: LCLBaseBundle, ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return self
    }
    
    /// Returns the formatted localized string with arguments
    func localizedFormat(arguments: CVarArg...) -> String {
        return String(format: localizeMe(), arguments: arguments)
    }
}
