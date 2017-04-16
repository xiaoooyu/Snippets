//
//  SnippetsTests.swift
//  SnippetsTests
//
//  Created by Yin Xiaoyu on 3/24/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import XCTest

import CoreData
@testable import Snippets

class SnippetsTests: XCTestCase {
    
    var vc: ViewController!
    var moc: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = sb.instantiateInitialViewController() as! ViewController
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        moc = delegate.managedObjectContext
        
        clearOutCoreData()
    }
    
    func clearOutCoreData() -> Void {
        // TODO: next
        
        var data: [NSManagedObject]!
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Snippet")
        do {
            let fetchResult = try moc.fetch(fetchRequest)
            data = fetchResult as! [NSManagedObject]
        } catch {
            let e = error as Error
            print("Unresolved error \(e.localizedDescription)")
        }
        
        for d in data {
            moc.delete(d)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveSnippet() {
        let testString = "test"
        vc.saveTextSnippet(text: testString)
        
        // get data from core data
        var data: [NSManagedObject]!
        

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Snippet")
        do {
            let fetchResult = try moc.fetch(fetchRequest)
            data = fetchResult as! [NSManagedObject]
        } catch {
            let e = error as Error
            print("Unresolved error \(e.localizedDescription)")
        }
        
        // validate data
        let snippet = data[0]
        if let rawType = snippet.value(forKey:"type") as? String,
            let string = snippet.value(forKey:"text") as? String {
            XCTAssertEqual(SnippetType(rawValue: rawType), .text)
            XCTAssertEqual(string, testString)
        } else {
            XCTFail()
        }
    }
    
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
