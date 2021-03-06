//
//  DatabaseManager.swift
//  HotelFinder
//
//  Created by James Nocentini on 02/10/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

// tag::setup-database[]
import CouchbaseLiteSwift

class DatabaseManager {

  private static var privateSharedInstance: DatabaseManager?
  
  var database: Database
  
  let DB_NAME = "travel-sample"
  
  class func sharedInstance() -> DatabaseManager   {
    guard let privateInstance = DatabaseManager.privateSharedInstance else {
      DatabaseManager.privateSharedInstance = DatabaseManager()
      return DatabaseManager.privateSharedInstance!
    }
    return privateInstance
  }
  
  private init() {
    let path = Bundle.main.path(forResource: self.DB_NAME, ofType: "cblite2")!
    if !Database.exists(withName: self.DB_NAME) {
      do {
        try Database.copy(fromPath: path, toDatabase: self.DB_NAME, withConfig: nil)
      } catch {
        fatalError("Could not copy database")
      }
    }
    do {
      self.database = try Database(name: "travel-sample")
      self.createIndex(database)
    } catch {
      fatalError("Could not copy database")
    }
  }
  
  func createIndex(_ database: Database) {
    do {
      try database.createIndex(IndexBuilder.fullTextIndex(items: FullTextIndexItem.property("description")).ignoreAccents(false), withName: "descFTSIndex")
    } catch {
      print(error)
    }
  }
  
}
// end::setup-database[]
