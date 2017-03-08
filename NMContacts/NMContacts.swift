//
//  NMContacts.swift
//  NMContacts
//
//  Created by Nicolas Mahé on 23/11/2016.
//  Copyright © 2016 Nicolas Mahé. All rights reserved.
//

import UIKit
import Contacts
import PromiseKit

/*
You need to add to Info.plist:
<key>NSContactsUsageDescription</key>
<string>The app needs to access to your contact</string>
*/


public enum NMContactsError: Error {
  case notAllowed
  case filename
}

public class NMContacts: NSObject {
  
  public static var settingsURL: URL {
    return URL(string: UIApplicationOpenSettingsURLString)!
  }
  
  public static var isAuthorized: Bool {
    return CNContactStore.authorizationStatus(for: .contacts) == .authorized
  }
  
  public static var numberOfContact: Int? {
    if self.isAuthorized == false {
      return nil
    }
    let contacts = try? self.fetchContacts()
    return contacts?.count
  }
  
  public static var requestAccess: Promise<Void> {
    return Promise<Void> { (fulfill, reject) in
      CNContactStore().requestAccess(for: CNEntityType.contacts) { (status: Bool, error: Error?) in
        if status == true {
          fulfill()
        }
        else {
          if let error = error {
            print(error)
          }
          reject(NMContactsError.notAllowed)
        }
      }
    }
  }
  
  public class func fetchContacts(search: String? = nil) throws -> [CNContact] {
    
    let keysToFetch = [
      CNContactGivenNameKey as CNKeyDescriptor,
      CNContactFamilyNameKey as CNKeyDescriptor,
      CNContactMiddleNameKey as CNKeyDescriptor,
      CNContactEmailAddressesKey as CNKeyDescriptor,
      CNContactPhoneNumbersKey as CNKeyDescriptor,
      CNContactImageDataAvailableKey as CNKeyDescriptor,
      CNContactThumbnailImageDataKey as CNKeyDescriptor,
      CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName),
      CNContactVCardSerialization.descriptorForRequiredKeys()
    ]
    
    let contactStore = CNContactStore()
    var results: [CNContact] = []
    
    
    if let search = search, search.isEmpty == false {
      let fetchPredicate = CNContact.predicateForContacts(matchingName: search)
      results = try contactStore.unifiedContacts(
        matching: fetchPredicate,
        keysToFetch: keysToFetch
      )
    }
    else {
      let allContainers = try contactStore.containers(matching: nil)
      
      try allContainers.forEach { (container: CNContainer) in
        let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier:container.identifier)
        let containerResults = try contactStore.unifiedContacts(
          matching: fetchPredicate,
          keysToFetch: keysToFetch
        )
        results.append(contentsOf: containerResults)
      }
    }
    
    return results
    
  }
  
  public class func generateVCard(for contact: CNContact) throws -> URL {
    let fileManager = FileManager.default
    let cacheDirectory = try fileManager.url(
      for: FileManager.SearchPathDirectory.cachesDirectory,
      in: FileManager.SearchPathDomainMask.userDomainMask,
      appropriateFor: nil,
      create: true
    )
    
    guard let fileName = CNContactFormatter().string(from: contact)
      else {
        throw NMContactsError.filename
    }
    
    let fileLocation = cacheDirectory.appendingPathComponent(fileName + ".vcf")
    
    let contactData = try CNContactVCardSerialization.data(with: [contact])
    try contactData.write(to: fileLocation)
    
    return fileLocation
  }

}
