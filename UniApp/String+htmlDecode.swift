//
//  PulisceStringa.swift
//  UniApp
//
//  Created by Maurizio on 04/07/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//
import Foundation
#if os(macOS)
    import AppKit
#elseif os(iOS)
    import UIKit
#endif

extension String {
    
    init?(htmlEncodedString: String) {
        
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [String: Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
    }
    
}
