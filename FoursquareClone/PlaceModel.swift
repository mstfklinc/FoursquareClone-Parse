//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by apple on 16.11.2019.
//  Copyright © 2019 Mustafa KILINÇ. All rights reserved.
//

import Foundation
import UIKit

class PlaceModel
{
    static let sharedInstace = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placesLatitude = ""
    var placeLongitude = ""
   
    
    private init()
    {
        
    }
}
