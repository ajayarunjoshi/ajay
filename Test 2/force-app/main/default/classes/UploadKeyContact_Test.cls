@isTest
public class UploadKeyContact_Test {
    
    @isTest
    static void testUploadK() {
        // Test data setup
        List<UploadKContact_RequestWrap> inputwrapper = new List<UploadKContact_RequestWrap>();
        // Add test data to the input wrapper
        
        // Mocking the getLoginToken class and method
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method
        UploadKContact_ResWrap result = UploadKeyContact.uploadK(inputwrapper);
        
        // Assertions
        // Add your assertions here based on the expected behavior of the method
        
        Test.stopTest();
    }
    
    // Mock HTTP response generator class
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": true, "message": "Success"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testParse() {
        // Test JSON string
        String jsonString = '{"status":true,"data":[{"customer_id":123,"user_unique_id":456,"unique_id":789,"salesforce_contact_id":101,"contact_first_name":"John","contact_last_name":"Doe","contact_title":"Manager","salesforce_account_id":202,"contact_company_name":"Test Company","contact_company_website_url":"www.test.com","contact_email":"john.doe@example.com","contact_company_status":"Active"}],"message":"Success","status_code":200,"errors":{}}';
        
        // Call the parse method
        UploadKContact_ResWrap resWrap = UploadKContact_ResWrap.parse(jsonString);
        
        // Assertions
        System.assertEquals(true, resWrap.status, 'Status should be true');
        System.assertEquals(1, resWrap.data.size(), 'Data list should contain one element');
        UploadKContact_ResWrap.Data data = resWrap.data[0];
        System.assertEquals(123, data.customer_id, 'Customer ID should match');
        System.assertEquals(456, data.user_unique_id, 'User unique ID should match');
        System.assertEquals(789, data.unique_id, 'Unique ID should match');
        System.assertEquals(101, data.salesforce_contact_id, 'Salesforce contact ID should match');
        System.assertEquals('John', data.contact_first_name, 'Contact first name should match');
        System.assertEquals('Doe', data.contact_last_name, 'Contact last name should match');
        System.assertEquals('Manager', data.contact_title, 'Contact title should match');
        System.assertEquals(202, data.salesforce_account_id, 'Salesforce account ID should match');
        System.assertEquals('Test Company', data.contact_company_name, 'Contact company name should match');
        System.assertEquals('www.test.com', data.contact_company_website_url, 'Contact company website URL should match');
        System.assertEquals('john.doe@example.com', data.contact_email, 'Contact email should match');
        System.assertEquals('Active', data.contact_company_status, 'Contact company status should match');
        System.assertEquals('Success', resWrap.message, 'Message should match');
        System.assertEquals(200, resWrap.status_code, 'Status code should match');
        System.assertEquals(null, resWrap.errors, 'Errors should be null');
    } 
    
    
    
    
     @isTest
    static void testParse2() {
        // Test JSON string
        String jsonString = '[{"customer_id":123,"user_unique_id":456,"salesforce_contact_id":789,"contact_first_name":"John","contact_last_name":"Doe","contact_title":"Manager","salesforce_account_id":101,"contact_company_name":"Test Company","contact_company_website_url":"www.test.com","contact_email":"john.doe@example.com","contact_company_status":"Active"}]';
        
        // Call the parse method
        List<UploadKContact_RequestWrap> requestWraps = UploadKContact_RequestWrap.parse(jsonString);
        
        // Assertions
        System.assertEquals(1, requestWraps.size(), 'List size should be 1');
        UploadKContact_RequestWrap requestWrap = requestWraps[0];
        System.assertEquals(123, requestWrap.customer_id, 'Customer ID should match');
        System.assertEquals(456, requestWrap.user_unique_id, 'User unique ID should match');
        System.assertEquals(789, requestWrap.salesforce_contact_id, 'Salesforce contact ID should match');
        System.assertEquals('John', requestWrap.contact_first_name, 'Contact first name should match');
        System.assertEquals('Doe', requestWrap.contact_last_name, 'Contact last name should match');
        System.assertEquals('Manager', requestWrap.contact_title, 'Contact title should match');
        System.assertEquals(101, requestWrap.salesforce_account_id, 'Salesforce account ID should match');
        System.assertEquals('Test Company', requestWrap.contact_company_name, 'Contact company name should match');
        System.assertEquals('www.test.com', requestWrap.contact_company_website_url, 'Contact company website URL should match');
        System.assertEquals('john.doe@example.com', requestWrap.contact_email, 'Contact email should match');
        System.assertEquals('Active', requestWrap.contact_company_status, 'Contact company status should match');
    }
    
    
}