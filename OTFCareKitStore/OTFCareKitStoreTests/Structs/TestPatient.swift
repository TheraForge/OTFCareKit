/*
 Copyright (c) 2019, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3. Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import OTFCareKitStore
import Foundation
import XCTest

class TestPatient: XCTestCase {

    func testPatientAge() {
        var patient = OCKPatient(id: "A", givenName: "Amy", familyName: "Frost")
        XCTAssertNil(patient.age)

        patient.birthday = Calendar.current.date(byAdding: .year, value: -50, to: Date())
        XCTAssert(patient.age == 50)
    }
    
    func testPatientAttachments() {
        var patient = OCKPatient(id: "A", givenName: "Amy", familyName: "Frost")
        
        // swiftlint:disable:next line_length
        let jsonString = "{\"profile\":{\"content_type\":\"image/png\",\"revpos\":1,\"encrypted_file_key\":\"\",\"length\":232072,\"stub\":true,\"location\":\"https://storagebox-prod.s3.eu-central-1.amazonaws.com/theraforge-storagebox-pod1/SS9sfzWq4aWVIk0XdX4He3c2Fi9XPdcIBL0fPil7qd5t2CsWleIVvxs0tQpYTk6BeYM8zLmPCPCGZjfQ2SEt2hOFnDIv0TL0HnzT0tcp2332hgQ9BmlVaeOLWt8UrfpkJr3hf6iPngpAWaeV5Eiuljry7SxdDEhHIII6OMjSkMdykenx9fIok54HLQ8gt9pOYiyvN2gL/88680df1d8eb2c334f379d45abcb08e6/profile/aba868ef98b621a21e6f1af8c773142f?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIASPDA45JLQPHFDM7D%2F20230131%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20230131T142703Z&X-Amz-Expires=3600&X-Amz-Signature=ac66ed6e615e10cf3be8b489eecef088b0b52b2187e890f84905df1b99612667&X-Amz-SignedHeaders=host\",\"key\":\"theraforge-storagebox-pod1/SS9sfzWq4aWVIk0XdX4He3c2Fi9XPdcIBL0fPil7qd5t2CsWleIVvxs0tQpYTk6BeYM8zLmPCPCGZjfQ2SEt2hOFnDIv0TL0HnzT0tcp2332hgQ9BmlVaeOLWt8UrfpkJr3hf6iPngpAWaeV5Eiuljry7SxdDEhHIII6OMjSkMdykenx9fIok54HLQ8gt9pOYiyvN2gL/88680df1d8eb2c334f379d45abcb08e6/profile/aba868ef98b621a21e6f1af8c773142f\",\"owner\":\"88680df1d8eb2c334f379d45abcb08e6\"}}"
        patient.userInfo = ["attachments": jsonString]
        
        let attachmets = patient.attachments
        
        XCTAssertNotNil(attachmets)
    }
    
    func testPatientAppSetting() {
        var patient = OCKPatient(id: "A", givenName: "Amy", familyName: "Frost")
        
        // swiftlint:disable:next line_length
        let jsonString = "{\"playLists\": [{\"uuid\": \"7563537481234238423442\"},{\"uuid\": \"3481237481234238978234\"}]}"
        patient.userInfo = ["appSettings": jsonString]
        
        let appSettings = patient.appSettings
        
        XCTAssertNotNil(appSettings)
    }
}
