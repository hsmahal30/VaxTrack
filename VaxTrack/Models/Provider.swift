//
//  Provider.swift
//  Capstone Project iOS
//
//  Created by Joeun Kim on 4/29/21.
//
import Foundation
import CoreLocation

class Provider: NSObject {
    var uid: Int!
    var firstName: String!
    var lastName: String!
    var organizationName: String?
    var address: String!
    var contactPhone: String!
    var contactEmail: String?
    var website: String?
    var office: String?
    var officeHourStart: String?
    var officeHourEnd: String?
    var services: [String]!
    var coordinates: CLLocation?

    init(firstName: String, organizationName: String) {
        self.firstName = firstName
        self.organizationName = organizationName
    }
    
    init(uid: Int, firstName: String, lastName: String, organizationName: String, address: String, contactPhone: String, contactEmail: String, website: String, office:String, officeHour:String, officeHourStart:String, officeHourEnd:String, coordinates: CLLocation) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.organizationName = organizationName
        self.address = address
        self.contactPhone = contactPhone
        self.contactEmail = contactEmail
        self.website = website
        self.office = office
        self.officeHourStart = officeHourStart
        self.officeHourEnd = officeHourEnd
        self.coordinates = coordinates
    }
    
    init(uid: Int, firstName: String, lastName: String, organizationName: String, address: String, contactPhone: String, contactEmail: String, website: String, office:String, officeHourStart:String, officeHourEnd:String) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.organizationName = organizationName
        self.address = address
        self.contactPhone = contactPhone
        self.contactEmail = contactEmail
        self.website = website
        self.office = office
        self.officeHourStart = officeHourStart
        self.officeHourEnd = officeHourEnd
    }
    
    func toDict() -> NSDictionary {
        return [
            "pid": uid,
            "firstname": firstName,
            "lastname": lastName,
            "org": organizationName,
            "address": address,
            "phone": contactPhone,
            "email": contactEmail,
            "website": website,
            "office": office,
            "officehourstart": officeHourStart,
            "officehourend": officeHourEnd
        ]
    }
    
}
