import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "Dallas" asset catalog image resource.
    static let dallas = DeveloperToolsSupport.ImageResource(name: "Dallas", bundle: resourceBundle)

    /// The "Estadio Mexico" asset catalog image resource.
    static let estadioMexico = DeveloperToolsSupport.ImageResource(name: "Estadio Mexico", bundle: resourceBundle)

    /// The "Estadio dallas" asset catalog image resource.
    static let estadioDallas = DeveloperToolsSupport.ImageResource(name: "Estadio dallas", bundle: resourceBundle)

    /// The "Estadio de los angeles" asset catalog image resource.
    static let estadioDeLosAngeles = DeveloperToolsSupport.ImageResource(name: "Estadio de los angeles", bundle: resourceBundle)

    /// The "Estadio de vancouver" asset catalog image resource.
    static let estadioDeVancouver = DeveloperToolsSupport.ImageResource(name: "Estadio de vancouver", bundle: resourceBundle)

    /// The "Estadio guadalajara" asset catalog image resource.
    static let estadioGuadalajara = DeveloperToolsSupport.ImageResource(name: "Estadio guadalajara", bundle: resourceBundle)

    /// The "Estadio houston" asset catalog image resource.
    static let estadioHouston = DeveloperToolsSupport.ImageResource(name: "Estadio houston", bundle: resourceBundle)

    /// The "Estadio monterrey" asset catalog image resource.
    static let estadioMonterrey = DeveloperToolsSupport.ImageResource(name: "Estadio monterrey", bundle: resourceBundle)

    /// The "Estadio san francisco" asset catalog image resource.
    static let estadioSanFrancisco = DeveloperToolsSupport.ImageResource(name: "Estadio san francisco", bundle: resourceBundle)

    /// The "Estadio toronto" asset catalog image resource.
    static let estadioToronto = DeveloperToolsSupport.ImageResource(name: "Estadio toronto", bundle: resourceBundle)

    /// The "FFF" asset catalog image resource.
    static let FFF = DeveloperToolsSupport.ImageResource(name: "FFF", bundle: resourceBundle)

    /// The "Guadalajara" asset catalog image resource.
    static let guadalajara = DeveloperToolsSupport.ImageResource(name: "Guadalajara", bundle: resourceBundle)

    /// The "Houston" asset catalog image resource.
    static let houston = DeveloperToolsSupport.ImageResource(name: "Houston", bundle: resourceBundle)

    /// The "KansasCity" asset catalog image resource.
    static let kansasCity = DeveloperToolsSupport.ImageResource(name: "KansasCity", bundle: resourceBundle)

    /// The "Los Angeles" asset catalog image resource.
    static let losAngeles = DeveloperToolsSupport.ImageResource(name: "Los Angeles", bundle: resourceBundle)

    /// The "Mexico" asset catalog image resource.
    static let mexico = DeveloperToolsSupport.ImageResource(name: "Mexico", bundle: resourceBundle)

    /// The "Monterrey" asset catalog image resource.
    static let monterrey = DeveloperToolsSupport.ImageResource(name: "Monterrey", bundle: resourceBundle)

    /// The "San Francisco" asset catalog image resource.
    static let sanFrancisco = DeveloperToolsSupport.ImageResource(name: "San Francisco", bundle: resourceBundle)

    /// The "Seattle" asset catalog image resource.
    static let seattle = DeveloperToolsSupport.ImageResource(name: "Seattle", bundle: resourceBundle)

    /// The "Toronto" asset catalog image resource.
    static let toronto = DeveloperToolsSupport.ImageResource(name: "Toronto", bundle: resourceBundle)

    /// The "Vancouver" asset catalog image resource.
    static let vancouver = DeveloperToolsSupport.ImageResource(name: "Vancouver", bundle: resourceBundle)

    /// The "estadio de kansas" asset catalog image resource.
    static let estadioDeKansas = DeveloperToolsSupport.ImageResource(name: "estadio de kansas", bundle: resourceBundle)

    /// The "estadio de seattle" asset catalog image resource.
    static let estadioDeSeattle = DeveloperToolsSupport.ImageResource(name: "estadio de seattle", bundle: resourceBundle)

    /// The "ss" asset catalog image resource.
    static let ss = DeveloperToolsSupport.ImageResource(name: "ss", bundle: resourceBundle)

    /// The "v2" asset catalog image resource.
    static let v2 = DeveloperToolsSupport.ImageResource(name: "v2", bundle: resourceBundle)

    /// The "v22" asset catalog image resource.
    static let v22 = DeveloperToolsSupport.ImageResource(name: "v22", bundle: resourceBundle)

    /// The "v23" asset catalog image resource.
    static let v23 = DeveloperToolsSupport.ImageResource(name: "v23", bundle: resourceBundle)

    /// The "v24" asset catalog image resource.
    static let v24 = DeveloperToolsSupport.ImageResource(name: "v24", bundle: resourceBundle)

    /// The "v25" asset catalog image resource.
    static let v25 = DeveloperToolsSupport.ImageResource(name: "v25", bundle: resourceBundle)

    /// The "v26" asset catalog image resource.
    static let v26 = DeveloperToolsSupport.ImageResource(name: "v26", bundle: resourceBundle)

    /// The "v6" asset catalog image resource.
    static let v6 = DeveloperToolsSupport.ImageResource(name: "v6", bundle: resourceBundle)

    /// The "v61" asset catalog image resource.
    static let v61 = DeveloperToolsSupport.ImageResource(name: "v61", bundle: resourceBundle)

    /// The "v62" asset catalog image resource.
    static let v62 = DeveloperToolsSupport.ImageResource(name: "v62", bundle: resourceBundle)

    /// The "v63" asset catalog image resource.
    static let v63 = DeveloperToolsSupport.ImageResource(name: "v63", bundle: resourceBundle)

    /// The "v64" asset catalog image resource.
    static let v64 = DeveloperToolsSupport.ImageResource(name: "v64", bundle: resourceBundle)

    /// The "v65" asset catalog image resource.
    static let v65 = DeveloperToolsSupport.ImageResource(name: "v65", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "Dallas" asset catalog image.
    static var dallas: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dallas)
#else
        .init()
#endif
    }

    /// The "Estadio Mexico" asset catalog image.
    static var estadioMexico: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .estadioMexico)
#else
        .init()
#endif
    }

    /// The "Estadio dallas" asset catalog image.
    static var estadioDallas: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .estadioDallas)
#else
        .init()
#endif
    }

    /// The "Estadio de los angeles" asset catalog image.
    static var estadioDeLosAngeles: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .estadioDeLosAngeles)
#else
        .init()
#endif
    }

    /// The "Estadio de vancouver" asset catalog image.
    static var estadioDeVancouver: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .estadioDeVancouver)
#else
        .init()
#endif
    }

    /// The "Estadio guadalajara" asset catalog image.
    static var estadioGuadalajara: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .estadioGuadalajara)
#else
        .init()
#endif
    }

    /// The "Estadio houston" asset catalog image.
    static var estadioHouston: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .estadioHouston)
#else
        .init()
#endif
    }

    /// The "Estadio monterrey" asset catalog image.
    static var estadioMonterrey: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .estadioMonterrey)
#else
        .init()
#endif
    }

    /// The "Estadio san francisco" asset catalog image.
    static var estadioSanFrancisco: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .estadioSanFrancisco)
#else
        .init()
#endif
    }

    /// The "Estadio toronto" asset catalog image.
    static var estadioToronto: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .estadioToronto)
#else
        .init()
#endif
    }

    /// The "FFF" asset catalog image.
    static var FFF: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .FFF)
#else
        .init()
#endif
    }

    /// The "Guadalajara" asset catalog image.
    static var guadalajara: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .guadalajara)
#else
        .init()
#endif
    }

    /// The "Houston" asset catalog image.
    static var houston: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .houston)
#else
        .init()
#endif
    }

    /// The "KansasCity" asset catalog image.
    static var kansasCity: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .kansasCity)
#else
        .init()
#endif
    }

    /// The "Los Angeles" asset catalog image.
    static var losAngeles: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .losAngeles)
#else
        .init()
#endif
    }

    /// The "Mexico" asset catalog image.
    static var mexico: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mexico)
#else
        .init()
#endif
    }

    /// The "Monterrey" asset catalog image.
    static var monterrey: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .monterrey)
#else
        .init()
#endif
    }

    /// The "San Francisco" asset catalog image.
    static var sanFrancisco: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sanFrancisco)
#else
        .init()
#endif
    }

    /// The "Seattle" asset catalog image.
    static var seattle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .seattle)
#else
        .init()
#endif
    }

    /// The "Toronto" asset catalog image.
    static var toronto: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .toronto)
#else
        .init()
#endif
    }

    /// The "Vancouver" asset catalog image.
    static var vancouver: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .vancouver)
#else
        .init()
#endif
    }

    /// The "estadio de kansas" asset catalog image.
    static var estadioDeKansas: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .estadioDeKansas)
#else
        .init()
#endif
    }

    /// The "estadio de seattle" asset catalog image.
    static var estadioDeSeattle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .estadioDeSeattle)
#else
        .init()
#endif
    }

    /// The "ss" asset catalog image.
    static var ss: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ss)
#else
        .init()
#endif
    }

    /// The "v2" asset catalog image.
    static var v2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v2)
#else
        .init()
#endif
    }

    /// The "v22" asset catalog image.
    static var v22: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v22)
#else
        .init()
#endif
    }

    /// The "v23" asset catalog image.
    static var v23: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v23)
#else
        .init()
#endif
    }

    /// The "v24" asset catalog image.
    static var v24: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v24)
#else
        .init()
#endif
    }

    /// The "v25" asset catalog image.
    static var v25: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v25)
#else
        .init()
#endif
    }

    /// The "v26" asset catalog image.
    static var v26: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v26)
#else
        .init()
#endif
    }

    /// The "v6" asset catalog image.
    static var v6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v6)
#else
        .init()
#endif
    }

    /// The "v61" asset catalog image.
    static var v61: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v61)
#else
        .init()
#endif
    }

    /// The "v62" asset catalog image.
    static var v62: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v62)
#else
        .init()
#endif
    }

    /// The "v63" asset catalog image.
    static var v63: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v63)
#else
        .init()
#endif
    }

    /// The "v64" asset catalog image.
    static var v64: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v64)
#else
        .init()
#endif
    }

    /// The "v65" asset catalog image.
    static var v65: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v65)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "Dallas" asset catalog image.
    static var dallas: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dallas)
#else
        .init()
#endif
    }

    /// The "Estadio Mexico" asset catalog image.
    static var estadioMexico: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .estadioMexico)
#else
        .init()
#endif
    }

    /// The "Estadio dallas" asset catalog image.
    static var estadioDallas: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .estadioDallas)
#else
        .init()
#endif
    }

    /// The "Estadio de los angeles" asset catalog image.
    static var estadioDeLosAngeles: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .estadioDeLosAngeles)
#else
        .init()
#endif
    }

    /// The "Estadio de vancouver" asset catalog image.
    static var estadioDeVancouver: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .estadioDeVancouver)
#else
        .init()
#endif
    }

    /// The "Estadio guadalajara" asset catalog image.
    static var estadioGuadalajara: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .estadioGuadalajara)
#else
        .init()
#endif
    }

    /// The "Estadio houston" asset catalog image.
    static var estadioHouston: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .estadioHouston)
#else
        .init()
#endif
    }

    /// The "Estadio monterrey" asset catalog image.
    static var estadioMonterrey: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .estadioMonterrey)
#else
        .init()
#endif
    }

    /// The "Estadio san francisco" asset catalog image.
    static var estadioSanFrancisco: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .estadioSanFrancisco)
#else
        .init()
#endif
    }

    /// The "Estadio toronto" asset catalog image.
    static var estadioToronto: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .estadioToronto)
#else
        .init()
#endif
    }

    /// The "FFF" asset catalog image.
    static var FFF: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .FFF)
#else
        .init()
#endif
    }

    /// The "Guadalajara" asset catalog image.
    static var guadalajara: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .guadalajara)
#else
        .init()
#endif
    }

    /// The "Houston" asset catalog image.
    static var houston: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .houston)
#else
        .init()
#endif
    }

    /// The "KansasCity" asset catalog image.
    static var kansasCity: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .kansasCity)
#else
        .init()
#endif
    }

    /// The "Los Angeles" asset catalog image.
    static var losAngeles: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .losAngeles)
#else
        .init()
#endif
    }

    /// The "Mexico" asset catalog image.
    static var mexico: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mexico)
#else
        .init()
#endif
    }

    /// The "Monterrey" asset catalog image.
    static var monterrey: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .monterrey)
#else
        .init()
#endif
    }

    /// The "San Francisco" asset catalog image.
    static var sanFrancisco: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sanFrancisco)
#else
        .init()
#endif
    }

    /// The "Seattle" asset catalog image.
    static var seattle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .seattle)
#else
        .init()
#endif
    }

    /// The "Toronto" asset catalog image.
    static var toronto: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .toronto)
#else
        .init()
#endif
    }

    /// The "Vancouver" asset catalog image.
    static var vancouver: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .vancouver)
#else
        .init()
#endif
    }

    /// The "estadio de kansas" asset catalog image.
    static var estadioDeKansas: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .estadioDeKansas)
#else
        .init()
#endif
    }

    /// The "estadio de seattle" asset catalog image.
    static var estadioDeSeattle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .estadioDeSeattle)
#else
        .init()
#endif
    }

    /// The "ss" asset catalog image.
    static var ss: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ss)
#else
        .init()
#endif
    }

    /// The "v2" asset catalog image.
    static var v2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v2)
#else
        .init()
#endif
    }

    /// The "v22" asset catalog image.
    static var v22: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v22)
#else
        .init()
#endif
    }

    /// The "v23" asset catalog image.
    static var v23: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v23)
#else
        .init()
#endif
    }

    /// The "v24" asset catalog image.
    static var v24: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v24)
#else
        .init()
#endif
    }

    /// The "v25" asset catalog image.
    static var v25: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v25)
#else
        .init()
#endif
    }

    /// The "v26" asset catalog image.
    static var v26: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v26)
#else
        .init()
#endif
    }

    /// The "v6" asset catalog image.
    static var v6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v6)
#else
        .init()
#endif
    }

    /// The "v61" asset catalog image.
    static var v61: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v61)
#else
        .init()
#endif
    }

    /// The "v62" asset catalog image.
    static var v62: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v62)
#else
        .init()
#endif
    }

    /// The "v63" asset catalog image.
    static var v63: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v63)
#else
        .init()
#endif
    }

    /// The "v64" asset catalog image.
    static var v64: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v64)
#else
        .init()
#endif
    }

    /// The "v65" asset catalog image.
    static var v65: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v65)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

