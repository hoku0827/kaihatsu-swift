//
//  TConnect.swift
import Foundation

// NSURLRequestの非公開APIをオーバーライド
extension NSURLRequest {
    static func allowsAnyHTTPSCertificateForHost(host: String) -> Bool {
        return true
    }
}