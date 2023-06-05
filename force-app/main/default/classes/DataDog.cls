public class DataDog {
  public static String postLog(PerformanceLog__c pl) {

    String url = 'https://http-intake.logs.us5.datadoghq.com/api/v2/logs';
    String jsonBody = JSON.serialize(
    new Map<String, String> {
        'ddsource' => 'NA91 Developer Org',
        'ddtags' => 'env:NA91,version:1.0',
        'hostname' => 'Developer Org',
        'message' => String.valueOf(System.now())+'|This is a test',
        'service' => 'Custom Apex',
        'timestamp' => String.valueOf(System.now()),
        'user.name' => UserInfo.getName(),
        'user.id' => UserInfo.getUserId(),
        'user.profileId' => UserInfo.getProfileId(),
        'user.org_name' => UserInfo.getOrganizationName(),
        'user.orgId' => UserInfo.getOrganizationId(),
        'status' => 'Error',
        'trigger.object' => String.valueOf(pl.ApexSObject__c),
        'trigger.class' => String.valueOf(pl.ApexClass__c),
        'trigger.method' => String.valueOf(pl.ApexMethod__c),
        'trigger.execution_context' => String.valueOf(pl.ApexExecContext__c),
        'trigger.records_in_context' => String.valueOf(pl.RecordsInContext__c),
        'transaction.requestId' => String.valueOf(pl.RequestId__c),
        'limits.used.queries_used' => String.valueOf(pl.Queries_Used__c),
        'limits.used.cpu_time_used' => String.valueOf(pl.CPU_Time_Used__c),
        'limits.used.heap_size_used' => String.valueOf(pl.Heap_Size_Used__c),
        'limits.total.queries_total' => String.valueOf(pl.Query_Limits__c),
        'limits.total.cpu_time_total' => String.valueOf(pl.CPUTime_Limits__c),
        'limits.total.heap_size_total' => String.valueOf(pl.HeapSize_Limits__c),
        'limits.left(%).queries_left' => String.valueOf(pl.Queries_Left_percentage__c),
        'limits.left(%).cpu_time_left' => String.valueOf(pl.CPUTime_Left_percentage__c),
        'limits.left(%).heap_size_left' => String.valueOf(pl.Heap_Size_Left_percentage__c),
        'transaction.quiddity' => String.valueOf(pl.Quiddity__c),
        'transaction.is_CurrentContext_Trigger' => String.valueOf(pl.IsCurrentContextTrigger__c)
    });
    System.debug('JSON o/p:'+jsonBody);

    // Instantiate a new Http object
    Http h = new Http();

    // Instantiate a new HTTP request
    // Specify request properties such as the endpoint, the POST method, etc. 
    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/json');
    req.setHeader('Accept', 'application/json');
    req.setHeader('DD-API-KEY', 'c3d8b8bcae834ba11aa1a86186862d45');
    req.setBody(jsonBody);

    // Send the request, and return a response
    HttpResponse res = h.send(req);
    return res.getBody();
  }
}