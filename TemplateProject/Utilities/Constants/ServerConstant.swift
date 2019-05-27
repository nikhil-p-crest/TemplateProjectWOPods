//
//  ServerConstant.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import Foundation

enum StatusCode {
    case Continue
    case SwitchingProtocols
    case OK
    case Created
    case Accepted
    case NonAuthoritativeInformation
    case NoContent
    case ResetContent
    case PartialContent
    case MultipleChoices
    case MovedPermanently
    case Found
    case SeeOther
    case NotModified
    case UseProxy
    case Unused
    case TemporaryRedirect
    case BadRequest
    case Unauthorized
    case PaymentRequired
    case Forbidden
    case NotFound
    case MethodNotAllowed
    case NotAcceptable
    case ProxyAuthenticationRequired
    case RequestTimeout
    case Conflict
    case Gone
    case LengthRequired
    case PreconditionFailed
    case RequestEntityTooLarge
    case RequestURITooLong
    case UnsupportedMediaType
    case RequestedRangeNotSatisfiable
    case ExpectationFailed
    case UnProcessableEntity
    case InternalServerError
    case NotImplemented
    case BadGateway
    case ServiceUnavailable
    case GatewayTimeout
    case HTTPVersionNotSupported
    
    var code:Int {
        switch self {
        case .Continue:                             return 100
        case .SwitchingProtocols:                   return 101
        case .OK:                                   return 200
        case .Created:                              return 201
        case .Accepted:                             return 202
        case .NonAuthoritativeInformation:          return 203
        case .NoContent:                            return 204
        case .ResetContent:                         return 205
        case .PartialContent:                       return 206
        case .MultipleChoices:                      return 300
        case .MovedPermanently:                     return 301
        case .Found:                                return 302
        case .SeeOther:                             return 303
        case .NotModified:                          return 304
        case .UseProxy:                             return 305
        case .Unused:                               return 306
        case .TemporaryRedirect:                    return 307
        case .BadRequest:                           return 400
        case .Unauthorized:                         return 401
        case .PaymentRequired:                      return 402
        case .Forbidden:                            return 403
        case .NotFound:                             return 404
        case .MethodNotAllowed:                     return 405
        case .NotAcceptable:                        return 406
        case .ProxyAuthenticationRequired:          return 407
        case .RequestTimeout:                       return 408
        case .Conflict:                             return 409
        case .Gone:                                 return 410
        case .LengthRequired:                       return 411
        case .PreconditionFailed:                   return 412
        case .RequestEntityTooLarge:                return 413
        case .RequestURITooLong:                    return 414
        case .UnsupportedMediaType:                 return 415
        case .RequestedRangeNotSatisfiable:         return 416
        case .ExpectationFailed:                    return 417
        case .UnProcessableEntity:                  return 422
        case .InternalServerError:                  return 500
        case .NotImplemented:                       return 501
        case .BadGateway:                           return 502
        case .ServiceUnavailable:                   return 503
        case .GatewayTimeout:                       return 504
        case .HTTPVersionNotSupported:              return 505
        }
    }
    
    var message:String {
        switch self {
        case .Continue:                             return "Continue"
        case .SwitchingProtocols:                   return "Switching Protocols"
        case .OK:                                   return ""
        case .Created:                              return "Created"
        case .Accepted:                             return "Accepted"
        case .NonAuthoritativeInformation:          return "NonAuthoritative Information"
        case .NoContent:                            return "No Content"
        case .ResetContent:                         return "Reset Content"
        case .PartialContent:                       return "Partial Content"
        case .MultipleChoices:                      return "Multiple Choices"
        case .MovedPermanently:                     return "Moved Permanently"
        case .Found:                                return "Found"
        case .SeeOther:                             return "See Other"
        case .NotModified:                          return "Not Modified"
        case .UseProxy:                             return "Use Proxy"
        case .Unused:                               return "(Unused)"
        case .TemporaryRedirect:                    return "Temporary Redirect"
        case .BadRequest:                           return "Bad Request"
        case .Unauthorized:                         return "Unauthorized"
        case .PaymentRequired:                      return "Payment Required"
        case .Forbidden:                            return "Forbidden"
        case .NotFound:                             return "Not Found"
        case .MethodNotAllowed:                     return "Method Not Allowed"
        case .NotAcceptable:                        return "Not Acceptable"
        case .ProxyAuthenticationRequired:          return "Proxy Authentication Required"
        case .RequestTimeout:                       return "Request Timeout"
        case .Conflict:                             return "Conflict"
        case .Gone:                                 return "Gone"
        case .LengthRequired:                       return "Length Required"
        case .PreconditionFailed:                   return "Precondition Failed"
        case .RequestEntityTooLarge:                return "Request Entity Too Large"
        case .RequestURITooLong:                    return "Request-URI Too Long"
        case .UnsupportedMediaType:                 return "Unsupported Media Type"
        case .RequestedRangeNotSatisfiable:         return "Requested Range Not Satisfiable"
        case .ExpectationFailed:                    return "Expectation Failed"
        case .UnProcessableEntity:                  return ""
        case .InternalServerError:                  return "Internal Server Error"
        case .NotImplemented:                       return "Not Implemented"
        case .BadGateway:                           return "Bad Gateway"
        case .ServiceUnavailable:                   return "Service Unavailable"
        case .GatewayTimeout:                       return "Gateway Timeout"
        case .HTTPVersionNotSupported:              return "HTTP Version Not Supported"
        }
    }
    
}

struct ServerConstant {
    
    static let domain = "http://api.circles.to/"
    
    struct WebService {
        
        static let version = "v1"
        static let apiVersion = "1"
        static let apiURL = "\(ServerConstant.domain)api/"
        static let defaultErrorMessage = "Something went wrong."
        
        struct Response {
            static let status = "status"
            static let success = "success"
            static let data = "data"
            static let error = "error"
            static let errors = "errors"
            static let alert = "alert"
            static let message = "message"
            static let text = "text"
            struct CommonErrorMessage {
                static let cancelled = "cancelled"
            }
        }
        
        struct HttpHeader {
            struct Key {
                static let token = "Token"
                static let authorization = "Authorization"
            }
            struct Value {
                static let token = "Token token="
            }
        }
        
        struct FacebookLogin {
            static let email = "email"
            static let first_name = "first_name"
            static let id = "id"
            static let last_name = "last_name"
            static let name = "name"
            struct Picture {
                static let picture = "picture"
                struct Data {
                    static let data = "data"
                    static let height = "height"
                    static let is_silhouette = "is_silhouette"
                    static let url = "url"
                    static let width = "width"
                }
            }
        }
        
    }
    
}
