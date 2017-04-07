//
//  EndpointsConstants.swift
//  CrossfitStocznia
//
//  Created by Jakub on 07.04.2017.
//  Copyright © 2017 Jakub. All rights reserved.
//

import Foundation

struct EndpointsConstants {
    
    struct MainEndpoint {
        static let baseURL = "http://crossfitstocznia.reservante.pl"
    }
    
    struct LoginEndpoint {
        static let baseURL = "http://crossfitstocznia.reservante.pl/auth/login/check"
    }
    
    struct MyReservationsEndpoint {
        static let baseURL = "http://crossfitstocznia.reservante.pl/client/orders"
    }
    
    struct TokenValueEndpoint {
        static let baseURL = "http://crossfitstocznia.reservante.pl/auth"
    }
    
    
    
    
    
}
