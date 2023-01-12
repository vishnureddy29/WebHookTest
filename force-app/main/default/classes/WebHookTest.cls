@RestResource(urlMapping='/api/Webhooks/pushDetailsdemo/*')
global without sharing class WebHookTest {
    @HttpPost
    global static void handleNotification(){
        
        try{
            HttpRequest req = new HttpRequest();
           
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
        }catch(Exception e){
            System.debug('Exception Happened: '+e.getMessage());
        }
    }
}