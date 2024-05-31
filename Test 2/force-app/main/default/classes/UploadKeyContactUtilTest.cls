@isTest
public class UploadKeyContactUtilTest {

    static testmethod void testGetContacts() {
        // Create a Track_Request__c record
        Track_Request__c trackRequest = new Track_Request__c();
        insert trackRequest;
        
        // Create a K_Contact__c record
        K_Contact__c kContact = new K_Contact__c(Contact__c = 'TestContactId');
        insert kContact;
        
        // Create a Contact record
        Contact contact = new Contact();
        insert contact;
        
        // Create a Track_Request_Contact__c record associated with the Track Request and K Contact
        Track_Request_Contact__c trackRequestContact = new Track_Request_Contact__c(
            Track_Request__c = trackRequest.Id,
            K_Contact__c = kContact.Id
        );
        insert trackRequestContact;
        
        Test.startTest();
        UploadKeyContactUtil.getContacts(new List<String>{trackRequest.Id});
        Test.stopTest();
    }
      
    @isTest
    static void testUploadK() {
        List<UploadKContact_RequestWrap> inputwrapper = new List<UploadKContact_RequestWrap>();
        UploadKContact_RequestWrap requestWrap = new UploadKContact_RequestWrap();
        inputwrapper.add(requestWrap);
        
        Test.startTest();
        UploadKContact_ResWrap result = UploadKeyContactUtil.uploadK(inputwrapper);
        Test.stopTest();
    }
}