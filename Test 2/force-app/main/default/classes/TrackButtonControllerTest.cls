@isTest
private class TrackButtonControllerTest {
    
    @isTest
    static void testGetContacts() {
        // Create a Kanlet_License__c record
        Kanlet_License__c kanletLicense = new Kanlet_License__c();
        insert kanletLicense;
        
        // Create a Track_Request__c record with Kanlet_Configuration__c field populated
        Track_Request__c trackRequest = new Track_Request__c(
            Kanlet_Configuration__c = kanletLicense.Id
        );
        insert trackRequest;
        
        // Create a Contact record with required fields
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            Phone = '1234567890'
            // Add more fields as needed
        );
        insert testContact;
        
        // Create a K_Contact__c record associated with the test Contact record and include required fields
        K_Contact__c testKContact = new K_Contact__c(
            Contact__c = testContact.Id,
            Job_Title__c = 'Manager',        // Provide the required Job Title
            Last_Name__c = 'Doe',            // Provide the required Last Name
            First_Name__c = 'John',          // Provide the required First Name
            Company_Name__c = 'ABC Inc'      // Provide the required Company Name
            // Add more fields as needed
        );
        insert testKContact;
        
        // Create a Track_Request_Contact__c record associated with the test Track_Request__c record and test K_Contact__c record
        Track_Request_Contact__c testTrackRequestContact = new Track_Request_Contact__c(
            Track_Request__c = trackRequest.Id,
            K_Contact__c = testKContact.Id
        );
        insert testTrackRequestContact;
        
        // Set up mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        // Call the method to test
        Test.startTest();
        TrackButtonController.getContacts(trackRequest.Id);
        Test.stopTest();
        
        // Perform assertions if needed
    }
    
    // Mock class to mock the callout response
    private class MockHttpResponse implements HttpCalloutMock {
        // Implement the respond method to return a mock response
        public HttpResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"key": "value"}'); // Adjust the response body as needed
            return res;
        }
    }
}