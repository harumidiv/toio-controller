//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
    fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
    fileprivate static let hostingBundle = Bundle(for: R.Class.self)

    static func validate() throws {
        try intern.validate()
    }

    /// This `R.file` struct is generated, and contains static references to 2 files.
    struct file {
        /// Resource file `448-ripple-loading-animation.json`.
        static let rippleLoadingAnimationJson = Rswift.FileResource(bundle: R.hostingBundle, name: "448-ripple-loading-animation", pathExtension: "json")
        /// Resource file `Settings.bundle`.
        static let settingsBundle = Rswift.FileResource(bundle: R.hostingBundle, name: "Settings", pathExtension: "bundle")

        /// `bundle.url(forResource: "448-ripple-loading-animation", withExtension: "json")`
        static func rippleLoadingAnimationJson(_: Void = ()) -> Foundation.URL? {
            let fileResource = R.file.rippleLoadingAnimationJson
            return fileResource.bundle.url(forResource: fileResource)
        }

        /// `bundle.url(forResource: "Settings", withExtension: "bundle")`
        static func settingsBundle(_: Void = ()) -> Foundation.URL? {
            let fileResource = R.file.settingsBundle
            return fileResource.bundle.url(forResource: fileResource)
        }

        fileprivate init() {}
    }

    /// This `R.image` struct is generated, and contains static references to 1 images.
    struct image {
        /// Image `setting`.
        static let setting = Rswift.ImageResource(bundle: R.hostingBundle, name: "setting")

        /// `UIImage(named: "setting", bundle: ..., traitCollection: ...)`
        static func setting(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
            return UIKit.UIImage(resource: R.image.setting, compatibleWith: traitCollection)
        }

        fileprivate init() {}
    }

    /// This `R.nib` struct is generated, and contains static references to 5 nibs.
    struct nib {
        /// Nib `ConnectViewController`.
        static let connectViewController = _R.nib._ConnectViewController()
        /// Nib `ControlViewController`.
        static let controlViewController = _R.nib._ControlViewController()
        /// Nib `InformationViewController`.
        static let informationViewController = _R.nib._InformationViewController()
        /// Nib `SettingViewController`.
        static let settingViewController = _R.nib._SettingViewController()
        /// Nib `WebViewController`.
        static let webViewController = _R.nib._WebViewController()

        /// `UINib(name: "ConnectViewController", in: bundle)`
        @available(*, deprecated, message: "Use UINib(resource: R.nib.connectViewController) instead")
        static func connectViewController(_: Void = ()) -> UIKit.UINib {
            return UIKit.UINib(resource: R.nib.connectViewController)
        }

        /// `UINib(name: "ControlViewController", in: bundle)`
        @available(*, deprecated, message: "Use UINib(resource: R.nib.controlViewController) instead")
        static func controlViewController(_: Void = ()) -> UIKit.UINib {
            return UIKit.UINib(resource: R.nib.controlViewController)
        }

        /// `UINib(name: "InformationViewController", in: bundle)`
        @available(*, deprecated, message: "Use UINib(resource: R.nib.informationViewController) instead")
        static func informationViewController(_: Void = ()) -> UIKit.UINib {
            return UIKit.UINib(resource: R.nib.informationViewController)
        }

        /// `UINib(name: "SettingViewController", in: bundle)`
        @available(*, deprecated, message: "Use UINib(resource: R.nib.settingViewController) instead")
        static func settingViewController(_: Void = ()) -> UIKit.UINib {
            return UIKit.UINib(resource: R.nib.settingViewController)
        }

        /// `UINib(name: "WebViewController", in: bundle)`
        @available(*, deprecated, message: "Use UINib(resource: R.nib.webViewController) instead")
        static func webViewController(_: Void = ()) -> UIKit.UINib {
            return UIKit.UINib(resource: R.nib.webViewController)
        }

        static func connectViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> UIKit.UIView? {
            return R.nib.connectViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
        }

        static func controlViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> UIKit.UIView? {
            return R.nib.controlViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
        }

        static func informationViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> UIKit.UIView? {
            return R.nib.informationViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
        }

        static func settingViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> UIKit.UIView? {
            return R.nib.settingViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
        }

        static func webViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> UIKit.UIView? {
            return R.nib.webViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
        }

        fileprivate init() {}
    }

    /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
    struct storyboard {
        /// Storyboard `LaunchScreen`.
        static let launchScreen = _R.storyboard.launchScreen()
        /// Storyboard `Main`.
        static let main = _R.storyboard.main()

        /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
        static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
            return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
        }

        /// `UIStoryboard(name: "Main", bundle: ...)`
        static func main(_: Void = ()) -> UIKit.UIStoryboard {
            return UIKit.UIStoryboard(resource: R.storyboard.main)
        }

        fileprivate init() {}
    }

    /// This `R.string` struct is generated, and contains static references to 3 localization tables.
    struct string {
        /// This `R.string.launchScreen` struct is generated, and contains static references to 0 localization keys.
        struct launchScreen {
            fileprivate init() {}
        }

        /// This `R.string.localizeString` struct is generated, and contains static references to 19 localization keys.
        struct localizeString {
            /// en translation: Bluetooth Permission
            ///
            /// Locales: en, ja
            static let connectionAlertBluetooth = Rswift.StringResource(key: "connection.alert.bluetooth", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: Bluetooth permission is required to use the controller
            ///
            /// Locales: en, ja
            static let connectionAlertMessage = Rswift.StringResource(key: "connection.alert.message", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: Find cube
            ///
            /// Locales: en, ja
            static let connectionSearchbutton = Rswift.StringResource(key: "connection.searchbutton", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: Go to settings
            ///
            /// Locales: en, ja
            static let connectionAlertButton = Rswift.StringResource(key: "connection.alert.button", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: Information
            ///
            /// Locales: en, ja
            static let navigationInformation = Rswift.StringResource(key: "navigation.information", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: Privacypolicy
            ///
            /// Locales: en, ja
            static let navigationPrivacypolicy = Rswift.StringResource(key: "navigation.privacypolicy", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: Scanning...
            ///
            /// Locales: en, ja
            static let navigationbarConnection = Rswift.StringResource(key: "navigationbar.connection", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: Search again
            ///
            /// Locales: en, ja
            static let connectionButtonRescan = Rswift.StringResource(key: "connection.button.rescan", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: Searching for nearby cubes
            ///
            /// Locales: en, ja
            static let connectionDescriotionScanning = Rswift.StringResource(key: "connection.descriotion.scanning", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: Setting
            ///
            /// Locales: en, ja
            static let navigationSetting = Rswift.StringResource(key: "navigation.setting", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: The bluetooth setting is off  Switch to non
            ///
            /// Locales: en, ja
            static let connectionAlertBluetoothMessage = Rswift.StringResource(key: "connection.alert.bluetooth.message", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: Turn on the cube  and press search button
            ///
            /// Locales: en, ja
            static let connectionDescriptionPrev = Rswift.StringResource(key: "connection.description.prev", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: about toio
            ///
            /// Locales: en, ja
            static let informationListAboutToio = Rswift.StringResource(key: "information.list.aboutToio", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: close
            ///
            /// Locales: en, ja
            static let connectionAlertBluetoothClose = Rswift.StringResource(key: "connection.alert.bluetooth.close", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: close
            ///
            /// Locales: en, ja
            static let connectionAlertLessbatteryClose = Rswift.StringResource(key: "connection.alert.lessbattery.close", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: controller setting
            ///
            /// Locales: en, ja
            static let informationListControllerSetting = Rswift.StringResource(key: "information.list.controllerSetting", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: iPhone is low on charge  nPlease charge before playing
            ///
            /// Locales: en, ja
            static let connectionAlertLessbatteryMessage = Rswift.StringResource(key: "connection.alert.lessbattery.message", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: privacypolisy
            ///
            /// Locales: en, ja
            static let informationListPrivacypolicy = Rswift.StringResource(key: "information.list.privacypolicy", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)
            /// en translation: toio
            ///
            /// Locales: en, ja
            static let navigationAbountToio = Rswift.StringResource(key: "navigation.abountToio", tableName: "Localize.string", bundle: R.hostingBundle, locales: ["en", "ja"], comment: nil)

            /// en translation: Bluetooth Permission
            ///
            /// Locales: en, ja
            static func connectionAlertBluetooth(_: Void = ()) -> String {
                return NSLocalizedString("connection.alert.bluetooth", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Bluetooth permission is required to use the controller
            ///
            /// Locales: en, ja
            static func connectionAlertMessage(_: Void = ()) -> String {
                return NSLocalizedString("connection.alert.message", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Find cube
            ///
            /// Locales: en, ja
            static func connectionSearchbutton(_: Void = ()) -> String {
                return NSLocalizedString("connection.searchbutton", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Go to settings
            ///
            /// Locales: en, ja
            static func connectionAlertButton(_: Void = ()) -> String {
                return NSLocalizedString("connection.alert.button", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Information
            ///
            /// Locales: en, ja
            static func navigationInformation(_: Void = ()) -> String {
                return NSLocalizedString("navigation.information", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Privacypolicy
            ///
            /// Locales: en, ja
            static func navigationPrivacypolicy(_: Void = ()) -> String {
                return NSLocalizedString("navigation.privacypolicy", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Scanning...
            ///
            /// Locales: en, ja
            static func navigationbarConnection(_: Void = ()) -> String {
                return NSLocalizedString("navigationbar.connection", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Search again
            ///
            /// Locales: en, ja
            static func connectionButtonRescan(_: Void = ()) -> String {
                return NSLocalizedString("connection.button.rescan", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Searching for nearby cubes
            ///
            /// Locales: en, ja
            static func connectionDescriotionScanning(_: Void = ()) -> String {
                return NSLocalizedString("connection.descriotion.scanning", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Setting
            ///
            /// Locales: en, ja
            static func navigationSetting(_: Void = ()) -> String {
                return NSLocalizedString("navigation.setting", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: The bluetooth setting is off  Switch to non
            ///
            /// Locales: en, ja
            static func connectionAlertBluetoothMessage(_: Void = ()) -> String {
                return NSLocalizedString("connection.alert.bluetooth.message", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Turn on the cube  and press search button
            ///
            /// Locales: en, ja
            static func connectionDescriptionPrev(_: Void = ()) -> String {
                return NSLocalizedString("connection.description.prev", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: about toio
            ///
            /// Locales: en, ja
            static func informationListAboutToio(_: Void = ()) -> String {
                return NSLocalizedString("information.list.aboutToio", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: close
            ///
            /// Locales: en, ja
            static func connectionAlertBluetoothClose(_: Void = ()) -> String {
                return NSLocalizedString("connection.alert.bluetooth.close", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: close
            ///
            /// Locales: en, ja
            static func connectionAlertLessbatteryClose(_: Void = ()) -> String {
                return NSLocalizedString("connection.alert.lessbattery.close", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: controller setting
            ///
            /// Locales: en, ja
            static func informationListControllerSetting(_: Void = ()) -> String {
                return NSLocalizedString("information.list.controllerSetting", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: iPhone is low on charge  nPlease charge before playing
            ///
            /// Locales: en, ja
            static func connectionAlertLessbatteryMessage(_: Void = ()) -> String {
                return NSLocalizedString("connection.alert.lessbattery.message", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: privacypolisy
            ///
            /// Locales: en, ja
            static func informationListPrivacypolicy(_: Void = ()) -> String {
                return NSLocalizedString("information.list.privacypolicy", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: toio
            ///
            /// Locales: en, ja
            static func navigationAbountToio(_: Void = ()) -> String {
                return NSLocalizedString("navigation.abountToio", tableName: "Localize.string", bundle: R.hostingBundle, comment: "")
            }

            fileprivate init() {}
        }

        /// This `R.string.main` struct is generated, and contains static references to 0 localization keys.
        struct main {
            fileprivate init() {}
        }

        fileprivate init() {}
    }

    fileprivate struct intern: Rswift.Validatable {
        fileprivate static func validate() throws {
            try _R.validate()
        }

        fileprivate init() {}
    }

    fileprivate class Class {}

    fileprivate init() {}
}

struct _R: Rswift.Validatable {
    static func validate() throws {
        try storyboard.validate()
    }

    struct nib {
        struct _ConnectViewController: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "ConnectViewController"

            func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> UIKit.UIView? {
                return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
            }

            fileprivate init() {}
        }

        struct _ControlViewController: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "ControlViewController"

            func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> UIKit.UIView? {
                return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
            }

            fileprivate init() {}
        }

        struct _InformationViewController: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "InformationViewController"

            func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> UIKit.UIView? {
                return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
            }

            fileprivate init() {}
        }

        struct _SettingViewController: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "SettingViewController"

            func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> UIKit.UIView? {
                return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
            }

            fileprivate init() {}
        }

        struct _WebViewController: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "WebViewController"

            func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> UIKit.UIView? {
                return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
            }

            fileprivate init() {}
        }

        fileprivate init() {}
    }

    struct storyboard: Rswift.Validatable {
        static func validate() throws {
            try launchScreen.validate()
            try main.validate()
        }

        struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
            typealias InitialController = UIKit.UIViewController

            let bundle = R.hostingBundle
            let name = "LaunchScreen"

            static func validate() throws {
                if #available(iOS 11.0, *) {}
            }

            fileprivate init() {}
        }

        struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
            typealias InitialController = UIKit.UIViewController

            let bundle = R.hostingBundle
            let name = "Main"

            static func validate() throws {
                if #available(iOS 11.0, *) {}
            }

            fileprivate init() {}
        }

        fileprivate init() {}
    }

    fileprivate init() {}
}
