public class ICPConfigurationController {
/*
    @AuraEnabled  
    public static String getKanletConfiguration() {
        // Validate the input
        /*  if (String.isEmpty(KanletConfigurationid)) {
            return 'Invalid KanletConfigurationid';
        }
        */
        
        // Query Kanlet_License__c record to ensure it exists
    /*   List<Kanlet_License__c> kanletLicenses = [SELECT Id FROM Kanlet_License__c LIMIT 1];
        if (kanletLicenses.isEmpty()) {
            return 'No Kanlet License found';
        }
        Kanlet_License__c kanletLicense = kanletLicenses[0];
        system.debug('kanletLicense--> ' + kanletLicense);
        
        List<ICP__c> icpDetailsList = [
            SELECT Id, Customer_Id__c, User_Unique_Id__c, 
            Customer_Name__c, Industry__c, Employee_Count__c, Revenue__c, 
            Location_City__c, Location_State__c, Location_Country__c, 
            Last_Funding_Status__c, Tech_Stack__c, Job_Title__c, Job_Title_Function__c, 
            Job_Title_Seniority__c, Boolean_indicating_if_the_record_is_arch__c, 
            Insert_Date__c, Update_Date__c 
            FROM ICP__c  
            WHERE Kanlet_License__c = :kanletLicense.Id
        ];
        
        // Check if records were found
        if (icpDetailsList.isEmpty()) {
            return 'No ICP Details Found';
        }
        
        // Create the response wrapper and populate the request list
        List<CreateKeyContacts_ReqWrap> reqLst = new List<CreateKeyContacts_ReqWrap>();   
        
        // Populate the request wraps
        for (ICP__c icpDetails : icpDetailsList) {
            CreateKeyContacts_ReqWrap reqWrap = new CreateKeyContacts_ReqWrap();          
            reqWrap.customer_name = icpDetails.Customer_Name__c;
            reqWrap.customer_id = Integer.valueOf(icpDetails.Customer_Id__c);
            reqWrap.user_unique_id = Integer.valueOf(icpDetails.User_Unique_Id__c);
            reqWrap.industry = new <String>{icpDetails.Industry__c};
            reqWrap.employee_count = new List<String>{icpDetails.Employee_Count__c};
            reqWrap.revenue = new List<String>{icpDetails.Revenue__c};
            reqWrap.location_city = new List<String>{icpDetails.Location_City__c};
            reqWrap.location_state = new List<String>{icpDetails.Location_State__c};
            reqWrap.location_country = new List<String>{icpDetails.Location_Country__c};
            reqWrap.last_funding_status = new List<String>{icpDetails.Last_Funding_Status__c};
            reqWrap.tech_stack = new List<String>{icpDetails.Tech_Stack__c};
            reqWrap.job_title = new List<String>{icpDetails.Job_Title__c};
            reqWrap.job_title_function = new List<String>{icpDetails.Job_Title_Function__c};
            reqWrap.job_title_seniority = new List<String>{icpDetails.Job_Title_Seniority__c};
            reqLst.add(reqWrap);
        }
        
       if (reqLst.size() > 0) {
            CreateKeyCont(reqLst);
            return 'Success';
        } else {
            return 'No ICP Details Found';
        }   
    }

    @AuraEnabled 
    public static void CreateKeyCont(List<CreateKeyContacts_ReqWrap> inputwrapper) {
        String requestBody1 = '';
        CreateKeyContacts_ResWrap auth1 = new CreateKeyContacts_ResWrap();
        Integration_Metadata__mdt apiConfig = Integration_Metadata__mdt.getInstance('CreateKeyContactsSpecs');
        String Token = getLoginToken.getToken();
        String authHeader = 'Bearer ' + Token;
        
        system.debug('Accesstoken=' + Token);
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');  
        req.setHeader('Authorization', authHeader); 
        req.setTimeout(120000);
        String endpoint = 'callout:CreateKeyContactsSpecs';
        system.debug('endpoint--> '+endpoint);
        req.setEndpoint(endpoint);
        requestBody1 = JSON.serialize(inputwrapper);
        
        req.setBody(requestBody1);
        System.debug('requestBody1=' + requestBody1);
        Http http = new Http();
        
        HTTPResponse response = http.send(req);
        system.debug('response=' + response);
        string responsebody = response.getBody();
        system.debug('Response Body=' + responsebody);
        
        Track_Log__c trackLog = new Track_Log__c();
        trackLog.Request_Date1__c = system.now();
        trackLog.API_Type__c = 'ICP';
        trackLog.Request__c = JSON.serializePretty(inputwrapper);
        
        if (response.getStatusCode() == 200) {
            try {
                auth1 = (CreateKeyContacts_ResWrap) System.JSON.deserialize(responsebody, CreateKeyContacts_ResWrap.class);
                trackLog.Status__c = 'Success';
                saveResponseInTrackLog(trackLog, responsebody);
            } catch (System.JSONException e) {
                trackLog.Status__c = 'Fail';
                trackLog.Error__c = 'Failed to parse JSON response: ' + e.getMessage();
                trackLog.Response__c = responsebody;
                insert trackLog;
            }
        } else {
            handleErrorResponse(response, trackLog, responsebody);
        }
    }

    private static void saveResponseInTrackLog(Track_Log__c trackLog, String responsebody) {
        Integer maxLength = 32000;
        if (responsebody.length() > maxLength) {
            trackLog.Response__c = 'Please refer to notes and attachments for the full response.';
            insert trackLog;
            saveResponseAsContentDocument(trackLog.Id, responsebody);
        } else {
            trackLog.Response__c = responsebody;
            insert trackLog;
        }
    }

    private static void handleErrorResponse(HTTPResponse response, Track_Log__c trackLog, String responsebody) {
        try {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responsebody);
            string errorMsg = string.valueOf(responseMap.get('errors'));
            trackLog.Status__c = 'Fail';
            trackLog.Error__c = errorMsg;
        } catch (System.JSONException e) {
            trackLog.Status__c = 'Fail';
            trackLog.Error__c = 'Failed to parse JSON error response: ' + e.getMessage();
        }
        saveResponseInTrackLog(trackLog, responsebody);
        system.debug('Failed to Create key contacts: HTTP status code ' + response.getStatusCode());
    }

    private static void saveResponseAsContentDocument(Id trackLogId, String responsebody) {
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.VersionData = Blob.valueOf(responsebody);
        contentVersion.Title = 'API_Response.txt';
        contentVersion.PathOnClient = 'API_Response.txt';
        insert contentVersion;
        
        contentVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id];
        
        ContentDocumentLink contentDocLink = new ContentDocumentLink();
        contentDocLink.ContentDocumentId = contentVersion.ContentDocumentId;
        contentDocLink.LinkedEntityId = trackLogId;
        contentDocLink.ShareType = 'V';
        contentDocLink.Visibility = 'AllUsers';
        insert contentDocLink;
    }*/
}