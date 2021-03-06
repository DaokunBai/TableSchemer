//
//  SchemeSetBuilder.swift
//  TableSchemer
//
//  Created by James Richard on 6/13/14.
//  Copyright (c) 2014 Weebly. All rights reserved.
//

import UIKit

/** This class facilitates building the contents of a `SchemeSet`.

    An instance of this object is passed into the build handler from `TableSchemeBuilder.buildSchemeSet(handler:)`.
    It's used to set a section title and to add schemes to the scheme set.
 */
public final class SchemeSetBuilder {
    
    /** This will be used as the SchemeSet's header text. If left nil, the SchemeSet will not have a title. */
    public var headerText: String?
    
    /** This will be used as the SchemeSet's footer text. If left nil, it will not have a footer label */
    public var footerText: String?
    
    /** This will be used as the SchemeSet's header view. If left nil, it will not have a custom section header view */
    public var headerView: UIView?
    
    /** This will be used as the SchemeSet's header view height. Default is `.useTable`, which means the height will be calculated automatically based on the content. */
    public var headerViewHeight: RowHeight = .useTable
    
    /** This will be used as the SchemeSet's footer view. If left nil, it will not have a custom section header view */
    public var footerView: UIView?
    
    /** This will be used as the SchemeSet's footer view height. Default is `.useTable`, which means the height will be calculated automatically based on the content. */
    public var footerViewHeight: RowHeight = .useTable
    
    /** These are the Scheme objects that the SchemeSet will be instantiated with. */
    public var schemes: [Scheme] {
        return attributedSchemes.map { $0.scheme }
    }

    var attributedSchemes = [AttributedScheme]()
    
    /// This is used to identify if the scheme is initially hidden or not
    public var hidden = false
    
    /**  
     Build a scheme within the closure.
        
     This method will instantiate a `Scheme` object, and then pass it into handler. The type of Scheme object that is instantiated will be inferred from the type passed into the handler.

     The created `Scheme` object will be validated before being added to the list of schemes to be created.

     The created `Scheme` object will be returned if you need a reference to it, but it will be added to the `TableScheme` automatically.

    - parameter     handler:    The closure to configure the scheme.
    - returns:                  The created Scheme instance.
     */
    @discardableResult
    public func buildScheme<BuilderType: SchemeBuilder>(_ handler: (_ builder: BuilderType, _ hidden: inout Bool) -> Void) -> BuilderType.SchemeType {
        let builder = BuilderType()
        var hidden = false
        handler(builder, &hidden)

        let scheme = try! builder.createScheme()
        attributedSchemes.append(AttributedScheme(scheme: scheme, hidden: hidden))
        return scheme
    }

    @discardableResult
    public func buildScheme<BuilderType: SchemeBuilder>(_ handler: (_ builder: BuilderType) -> Void) -> BuilderType.SchemeType {
        let builder = BuilderType()
        handler(builder)

        let scheme = try! builder.createScheme()
        attributedSchemes.append(AttributedScheme(scheme: scheme, hidden: false))
        return scheme
    }
    
    /** Create the `SchemeSet` with the currently added `Scheme`s. This method should not be called except from `TableSchemeBuilder` */
    internal func createSchemeSet() -> AttributedSchemeSet {
        return AttributedSchemeSet(schemeSet: SchemeSet(attributedSchemes: attributedSchemes, headerText: headerText, footerText: footerText, headerView: headerView, headerViewHeight: headerViewHeight, footerView: footerView, footerViewHeight: footerViewHeight), hidden: hidden)
    }
}
