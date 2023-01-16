@RestResource(urlMapping='/api/Webhooks/pushDetailsdemo/*')
global without sharing class WebhooksRestApi {
    @HttpPost
    global static void handleNotification()
    {
        try{
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        //fetching the body
        //get hash value from header
            String hashedval = request.headers.get('X-Hub-Signature-256');
            System.debug('hashedval: '+hashedval);
            Blob bB = request.requestBody;
            System.debug(bB.toString());
    //we are requesting body creating json parser and iterating body to fetch request body in payload  
            
            JSONParser parser =JSON.createParser(request.requestBody.toString());
            pusher ps;
            head_commit hc;
            String repo;
            while(parser.nextToken() != null) 
            {

                if(parser.getText() == 'pusher')
                {
                    System.debug('Inside pusher');
                
                    parser.nextToken();
                    ps = (pusher)parser.readValueAs(pusher.class);
                    System.debug(ps);    
                }

                if(parser.getText() == 'head_commit')
                {
                    System.debug('Inside head_commit');
                    
                    parser.nextToken();
                    hc = (head_commit)parser.readValueAs(head_commit.class);
                    System.debug(hc);

                }

                if(parser.getText() == 'full_name')
                {
                    System.debug('Inside full_name');
                    
                    parser.nextToken();
                    repo = parser.getText();
                    System.debug(repo);
                }
            }
            
            Github_push_details__c details = new Github_push_details__c();
            details.Commiter_Name__c = ps!=null?ps.name:'';
            details.Email__c = ps!=null?ps.email:'';
            details.Message__c = hc!=null?hc.message:'';
            details.TimeStamp__c = hc!=null?hc.timestamp:'';
            details.Url__c = hc!=null?hc.url:'';
            details.Repository_Name__c = repo;
            //details.Added_Components__c = hc!=null&&hc.added!=null?String.join(hc.added,','):'';
            //details.Removed_Components__c = hc!=null&&hc.removed!=null?String.join(hc.removed,','):'';
            //details.Modified_Components__c = hc!=null&&hc.modified!=null?String.join(hc.modified,','):'';
            insert details; 
            response.statusCode = 200;
            response.responseBody = Blob.valueof(JSON.serialize(new SFDCResponse('Success',	'processed Sucessfully')));

        }catch(Exception e){
                System.debug('Exception Happened: '+e.getMessage());
            }
            
        }

        public class SFDCResponse{
            String response;
            String message;
            public SFDCResponse(String resp, String msg){
            response =resp;	
            message = msg;
            } 
        }
        public class head_commit{
            public String url;
            public String timestamp;
            public String message;
            public head_commit(String url, String message, String timestamp){
                url = url;	
                timestamp = timestamp;
                message = message;
            } 
        }

        public class pusher{
            public String name;
            public String email;
            public pusher(String name, String email){
            name = name;	
            email = email;
            } 
        }

    }