//
//  JwtTests.swift
//  JwtTests
//
//  Created by Mendy Edri on 29/10/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest
@testable import TDDChatProject

class JwtTests: XCTestCase {
    
    func test_jwtIsValid() {
        let sut = Jwt(string: futureJwt, parser: JwtDefaultParser())
        
        XCTAssertNoThrow(try sut.isJwtExp())
        XCTAssertEqual(try sut.isJwtExp(), false)
    }
    
    func test_jwtIsExipred() {
        let sut = Jwt(string: expiredJwt, parser: JwtDefaultParser())
    
        XCTAssertEqual(try sut.isJwtExp(), true)
    }
    
    func test_expiredJwtNotThrowing() {
        let sut = Jwt(string: expiredJwt, parser: JwtDefaultParser())
        
        XCTAssertNoThrow(try sut.isJwtExp())
    }
    
    func test_throwsInvalidErrorWhenCorrupted() {
        assertingJwtThrows(when: corruptedJwt)
    }
    
    func test_throwsOnEmptyJwt() {
        assertingJwtThrows(when: emptyJwt)
    }
    
    private func assertingJwtThrows(when jwt: String, file: StaticString = #file) {
        let sut = Jwt(string: jwt, parser: JwtDefaultParser())
        
        var thrownError: Error?
        
        // First, we have to catch this mf error
        XCTAssertThrowsError(try sut.isJwtExp(), file: file) {
            thrownError = $0
        }
        
        // Now, we'll verify the error is in the right type
        XCTAssertTrue( thrownError is Jwt.Error,
                       "Unexpected error type: \(type(of: thrownError))", file: file)
        
        // Finaly, we make sure when we pass corrupted jwt - this error is returns
        XCTAssertEqual(thrownError as? Jwt.Error, .invalid, file: file)
    }
}

extension JwtTests {
    // Experation date in 2029
    var futureJwt: String {
     return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE4OTE0MzEwNTcsImlkIjoicGluZ0lkMTIzNCIsInVzZXJJZCI6InVzZXJJZDk4NzYifQ.4DXgPqyAxvw2DpRFKHjmCMMY3vr4k3od4BNyV2oSNXE"
    }
    
    var expiredJwt: String {
        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjExNzI2MTExNzcsImlkIjoicGluZ0lkMTIzNCIsInVzZXJJZCI6InVzZXJJZDk4NzYifQ.PHdCsv40vXi56McA3084aDkVeuIkOlAK5Jm2_IU8Io8"
    }
    
    var corruptedJwt: String {
        return "%%$@@@!!eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIi--@@XXXOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjExNzI2MTExNzcsImlkIjoicGluZ0lkMTIzNCIsInVzZXJJZCI6InVzZXJJZDk4NzYifQ.PHdCsv40vXi56McA3084aDkVeuIkOlAK5Jm2_IU8Io8"
    }
    
    var emptyJwt: String {
        return ""
    }
}
