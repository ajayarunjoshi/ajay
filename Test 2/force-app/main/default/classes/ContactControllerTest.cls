@isTest
private class ContactControllerTest {

    @isTest
    static void testGetCareerEventsByEmail() {
        // Create test data
        Contact testContact = new Contact(
            FirstName = 'Jack',
            LastName = 'Rogers'
            
        );
        insert testContact;

        // Create a K_Contact__c record associated with the test contact
        K_Contact__c testKContact = new K_Contact__c(
            Contact__c = testContact.Id,
            // Add required fields for K_Contact__c
            // For example:
            Job_Title__c = 'VP, Facilities',
            Last_Name__c = 'Rogers',
            First_Name__c = 'Jack',
            Company_Name__c = 'Burlington Textiles Corp of America'
        );
        insert testKContact;

        // Create a K_Processed_Contact__c record associated with the test K_Contact__c record
        K_Processed_Contact__c testCareerEvent = new K_Processed_Contact__c(
            K_Contact__c = testKContact.Id
            // Add any other required fields for K_Processed_Contact__c
        );
        insert testCareerEvent;

        // Call the method being tested
        Test.startTest();
        K_Processed_Contact__c result = ContactController.getCareerEventsByEmail(testContact.Id);
        Test.stopTest();

        // Assert the results
        System.assertEquals(testCareerEvent.Id, result.Id);
        // Add more assertions as needed
    }
}