public without sharing class ConfigDetails1 {
    
    public class ConfigDetailsResp_Wrap {
        public String user_first_name;
        public String user_last_name;
        public String user_title;
        public String tracking_start_date;
        public String tracking_end_date;
        public String duration;
        public Integer contact_limit;
        public String frequency;
    }
    
	@AuraEnabled
    public static Kanlet_License__c configDetail(string configId) {
    Kanlet_License__c licenseRecord = [SELECT Id, Customer_id__c, User_Unique_Id__c FROM Kanlet_License__c WHERE Id = :configId LIMIT 1];
    return licenseRecord;
} 
    
    
    @AuraEnabled
    public static void ConfigurationDetails(Integer customer_id, Integer user_unique_id) {
        System.debug('ConfigurationDetails method started');
        
        // Retrieve Kanlet_License__c record
        Kanlet_License__c kanletLicense = [SELECT Id, Customer_id__c, User_Unique_Id__c
                                           FROM Kanlet_License__c
                                           WHERE User_Unique_Id__c =: user_unique_id
                                           AND Customer_id__c =: customer_id
                                           LIMIT 1];
        system.debug('kanletLicense--> '+kanletLicense);
        if (kanletLicense != null) {
            // Prepare API request with Customer_id__c and User_Unique_Id__c
            String token = getLoginToken.getToken();
            if (String.isNotBlank(token)) {
                String authHeader = 'Bearer ' + token;
                Integration_Metadata__mdt apiConfig = Integration_Metadata__mdt.getInstance('ConfigDetails');
                if (apiConfig != null && apiConfig.Active__c) {
                    HttpRequest httpRequest = new HttpRequest();
                    httpRequest.setHeader('Authorization', authHeader);
                    httpRequest.setHeader('Content-Type', apiConfig.Content_Type__c);
                    httpRequest.setMethod(apiConfig.Method_Type__c.trim());
                    httpRequest.setEndpoint('https://track-crm.kanlet.app/track/config/details/' + kanletLicense.User_Unique_Id__c + '/' + kanletLicense.Customer_id__c + '/');
                    httpRequest.setTimeout(apiConfig.Timeout__c != null ? Integer.valueOf(apiConfig.Timeout__c) : 120000);
                    
                    Http http = new Http();
                    HttpResponse response = http.send(httpRequest);
                    
                    if (response.getStatusCode() == 200) {
                        String responseBody = response.getBody();
                        System.debug('Response Body: ' + responseBody);
                        
                        // Deserialize response to ConfigDetailsResp_Wrap
                        ConfigDetailsResp_Wrap apiResponse = (ConfigDetailsResp_Wrap) JSON.deserialize(responseBody, ConfigDetailsResp_Wrap.class);
                        
                        // Update Kanlet_License__c record with API response
                        kanletLicense.First_Name__c = apiResponse.user_first_name;
                        kanletLicense.Last_Name__c = apiResponse.user_last_name;
                        kanletLicense.Job_Title__c = apiResponse.user_title;
                        // Example assuming tracking_start_date format is "YYYY-MM-DD"
                        if (apiResponse.tracking_start_date != null && apiResponse.tracking_start_date.length() == 10) {
                            kanletLicense.Tracking_Start_Date__c = Date.valueOf(apiResponse.tracking_start_date);
                        } else {
                            System.debug('Invalid date format for tracking_start_date: ' + apiResponse.tracking_start_date);
                            // Handle the error or set a default value for Tracking_Start_Date__c
                        }
                        // Example assuming tracking_start_date format is "YYYY-MM-DD"
                        if (apiResponse.tracking_end_date != null && apiResponse.tracking_end_date.length() == 10) {
                            kanletLicense.Tracking_End_Date__c = Date.valueOf(apiResponse.tracking_end_date);
                        } else {
                            System.debug('Invalid date format for tracking_start_date: ' + apiResponse.tracking_end_date);
                            // Handle the error or set a default value for Tracking_Start_Date__c
                        }
                        
                        //    kanletLicense.Tracking_End_Date__c = Date.valueOf(apiResponse.tracking_end_date);
                        kanletLicense.Duration__c = apiResponse.duration;
                        kanletLicense.Contact_Limit__c = apiResponse.contact_limit;
                        // Update the record
                        update kanletLicense;
                    } else {
                        System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
                    }
                } else {
                    System.debug('Service is inactive');
                }
            } else {
                System.debug('Token is null or empty');
            }
        } else {
            System.debug('Kanlet License record not found');
        }
        
        System.debug('ConfigurationDetails method ended');
    }
}