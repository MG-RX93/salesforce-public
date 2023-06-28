public class PerformanceUtil {

  public PerformanceUtil() {

  }

  public static Map<String, Integer> getCurrentLimits() {
    Map<String, Integer> currentLimits = new Map<String, Integer>();
    currentLimits.put('queryCountPre',Limits.getLimitQueries());
    currentLimits.put('cpuTimePre',Limits.getLimitCpuTime());
    currentLimits.put('heapSizePre',Limits.getLimitHeapSize());
    if (currentLimits != null && !currentLimits.isEmpty()) {
      return currentLimits;  
    } else {
      return null;
    }
  }

  public static void capturePerformanceMetrics(Map<String, Integer> currentLimits, String className, String methodName, String executionContext, String sObjectName, Integer size, Boolean currentContext) {
    System.debug('CurrentLimits in '+executionContext+'are :'+currentLimits);
    System.debug('Quiddity is: '+Request.getCurrent().getQuiddity());
    switch on Request.getCurrent().getQuiddity() {
      when SYNCHRONOUS, RUNTEST_SYNC, RUNTEST_ASYNC, AURA {
        syncLimitsUsage(currentLimits, className, methodName, executionContext , sObjectName, size, currentContext);
      }
      when BATCH_APEX, BULK_API, FUTURE {
        asyncLimitsUsage(currentLimits, className, methodName, executionContext , sObjectName, size, currentContext);
      }
      when else {
        syncLimitsUsage(currentLimits, className, methodName, executionContext , sObjectName, size, currentContext);
      }
    }
  }

  private static void syncLimitsUsage(Map<String, Integer> currentLimits, String className, String methodName, String executionContext, String sObjectName, Integer size, Boolean currentContext) {
 
    Integer queryCountDivisor = 100, cpuTimeDivisor = 10000, heapSizeDivisor = 6000000;

    PerformanceLog__c pl = new PerformanceLog__c();
    pl.class_name__c = className;
    pl.method_name__c = methodName;
    pl.trigger_type__c = executionContext;
    pl.object_name__c = sObjectName;
    pl.Queries_Used__c = getQueriesUsed();
    pl.CPU_Time_Used__c = getCPUTimeUsed();
    pl.Heap_Size_Used__c = getHeapSizeUsed();
    pl.Query_Limits__c = currentLimits.get('queryCountPre');
    pl.CPUTime_Limits__c = currentLimits.get('cpuTimePre');
    pl.HeapSize_Limits__c = currentLimits.get('heapSizePre');
    pl.Queries_Left_percentage__c = getPercentageQueriesLeft(currentLimits, queryCountDivisor);
    pl.CPUTime_Left_percentage__c = getPercentageCPUTimeLeft(currentLimits, cpuTimeDivisor);
    pl.Heap_Size_Left_percentage__c = getPercentageHeapSizeLeft(currentLimits, heapSizeDivisor);
    pl.records_in_context__c = size;
    pl.request_id__c = String.valueOf(Request.getCurrent().getRequestId());
    pl.transaction_quiddity__c = String.valueOf(Request.getCurrent().getQuiddity());
    pl.is_current_context_trigger__c = currentContext;
    pl.organization_id__c = UserInfo.getOrganizationId();
    pl.organization_name__c = UserInfo.getOrganizationName();
    pl.profile_id__c = UserInfo.getProfileId();
    pl.user_id__c = UserInfo.getUserId();
    pl.user_name__c = UserInfo.getName();
    System.debug('Sync Log record: '+pl);
    // insert pl;
    System.debug('Sync Log: '+JSON.serialize(getJSON(pl)));
    // callDataDogPost(JSON.serialize(pl));
    // System.debug('queryCount% left: '+ (queryCountUsedPercent)*100 + '%');
    // System.debug('cpuTime% left: '+ (cpuTimeUsedPercent)*100+ '%');
    // System.debug('heapSize% left: '+(heapSizeUsedPercent)*100+ '%'); 

    // Persist all data to an object.
  }

  private static void asyncLimitsUsage(Map<String, Integer> currentLimits, String className, String methodName, String executionContext, String sObjectName, Integer size, Boolean currentContext) {
    Integer queryCountDivisor = 200, cpuTimeDivisor = 60000, heapSizeDivisor = 12000000;

    
    PerformanceLog__c pl = new PerformanceLog__c();
    pl.class_name__c = className;
    pl.method_name__c = methodName;
    pl.trigger_type__c = executionContext;
    pl.object_name__c = sObjectName;
    pl.Queries_Used__c = getQueriesUsed();
    pl.CPU_Time_Used__c = getCPUTimeUsed();
    pl.Heap_Size_Used__c = getHeapSizeUsed();
    pl.Query_Limits__c = currentLimits.get('queryCountPre');
    pl.CPUTime_Limits__c = currentLimits.get('cpuTimePre');
    pl.HeapSize_Limits__c = currentLimits.get('heapSizePre');
    pl.Queries_Left_percentage__c = getPercentageQueriesLeft(currentLimits, queryCountDivisor);
    pl.CPUTime_Left_percentage__c = getPercentageCPUTimeLeft(currentLimits, cpuTimeDivisor);
    pl.Heap_Size_Left_percentage__c = getPercentageHeapSizeLeft(currentLimits, heapSizeDivisor);
    pl.records_in_context__c = size;
    pl.request_id__c = String.valueOf(Request.getCurrent().getRequestId());
    pl.transaction_quiddity__c = String.valueOf(Request.getCurrent().getQuiddity());
    pl.is_current_context_trigger__c = currentContext;
    pl.organization_id__c = UserInfo.getOrganizationId();
    pl.organization_name__c = UserInfo.getOrganizationName();
    pl.profile_id__c = UserInfo.getProfileId();
    pl.user_id__c = UserInfo.getUserId();
    pl.user_name__c = UserInfo.getName();
    System.debug('Async Log record: '+pl);
    // insert pl;
    System.debug('Async Log: '+JSON.serialize(getJSON(pl)));
    // callDataDogPost(JSON.serialize(pl));
    

    // System.debug('queryCount % left: '+ (queryCountUsedPercent)*100 + '%');
    // System.debug('cpuTime % left: '+ (cpuTimeUsedPercent)*100+ '%');
    // System.debug('heapSize % left: '+(heapSizeUsedPercent)*100+ '%'); 

    // Persist all data to an object.
  }

  private static JSON2Apex getJSON(PerformanceLog__c pl) {
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();     
    // gen.writeFieldName('transaction_info');
    // gen.writeStartObject();
    gen.writeIdField('Id', pl.Id);
    gen.writeBooleanField('is_current_context_trigger', pl.is_current_context_trigger__c);
    gen.writeStringField('transaction_quiddity', pl.transaction_quiddity__c);
    gen.writeStringField('request_id', pl.request_id__c);
    gen.writeDateTimeField('timestamp', System.now());
    // gen.writeEndObject();
    // gen.writeFieldName('user');
    // gen.writeStartObject();
    gen.writeIdField('organization_id', pl.organization_id__c);
    gen.writeStringField('organization_name', pl.organization_name__c);
    gen.writeIdField('profile_id', pl.profile_id__c);
    gen.writeIdField('user_id', pl.user_id__c);
    gen.writeStringField('user_name', pl.user_name__c);
    // gen.writeEndObject();
    // gen.writeFieldName('limits');
    // gen.writeStartObject();
    // gen.writeFieldName('left_percentage');
    // gen.writeStartObject();
    gen.writeNumberField('heap_size_left_percentage', pl.Heap_Size_Left_percentage__c);
    gen.writeNumberField('cputime_left_percentage', pl.CPUTime_Left_percentage__c);
    gen.writeNumberField('queries_left_percentage', pl.Queries_Left_percentage__c);
    // gen.writeEndObject();
    // gen.writeFieldName('total');
    // gen.writeStartObject();
    gen.writeNumberField('heapsize_limits', pl.HeapSize_Limits__c);
    gen.writeNumberField('cputime_limits', pl.CPUTime_Limits__c);
    gen.writeNumberField('query_limits', pl.Query_Limits__c);
    // gen.writeEndObject();
    // gen.writeFieldName('used');
    // gen.writeStartObject();
    gen.writeNumberField('heap_size_used', pl.Heap_Size_Used__c);
    gen.writeNumberField('cpu_time_used', pl.CPU_Time_Used__c);
    gen.writeNumberField('queries_used', pl.Queries_Used__c);
    // gen.writeEndObject();
    // gen.writeEndObject();
    // gen.writeFieldName('trigger_info');
    // gen.writeStartObject();
    gen.writeNumberField('records_in_context', pl.records_in_context__c);
    gen.writeStringField('trigger_type', pl.trigger_type__c);
    gen.writeStringField('method_name', pl.method_name__c);
    gen.writeStringField('class_name', pl.class_name__c);
    gen.writeStringField('object_name', pl.object_name__c);
    // gen.writeEndObject();
    gen.writeEndObject();
    String jsonData = gen.getAsString();
    // System.debug('jsonGen: '+jsonData);
    return (JSON2Apex)JSON.deserialize(jsonData, JSON2Apex.class);
  }

  @future(callout=true)
  private static void callDataDogPost(String plJson) {
    PerformanceLog__c pl = (PerformanceLog__c)JSON.deserialize(plJson, PerformanceLog__c.class);
    DataDog.postLog(pl);
  }

  private static Integer getQueriesLeft(Map<String, Integer> currentLimits) {
    Integer queriesUsed = getQueriesUsed();
    Integer queriesLeft = currentLimits.get('queryCountPre') - queriesUsed;
    return queriesLeft;
  }

  private static Integer getCPUTimeLeft(Map<String, Integer> currentLimits) {
    Integer cpuTimeUsed = getCPUTimeUsed();
    Integer cpuTimeLeft = currentLimits.get('cpuTimePre') - cpuTimeUsed;
    return cpuTimeLeft;
  }

  private static Integer getHeapSizeLeft(Map<String, Integer> currentLimits) {
    Integer heapSizeUsed = Limits.getHeapSize();
    Integer heapSizeLeft = currentLimits.get( 'heapSizePre') - heapSizeUsed;
    return heapSizeLeft;
  }

  private static Decimal getPercentageQueriesLeft(Map<String, Integer> currentLimits, Integer queryCountDivisor) {
    Decimal percentageOfQueriesLeft =  ((Double) getQueriesLeft(currentLimits)/queryCountDivisor)*100;
    return percentageOfQueriesLeft;
  }

  private static Decimal getPercentageCPUTimeLeft(Map<String, Integer> currentLimits, Integer cpuTimeDivisor) {
    Decimal percentageOfCPUTimeLeft =  ((Double) getCPUTimeLeft(currentLimits)/cpuTimeDivisor)*100;
    return percentageOfCPUTimeLeft;
  }

  private static Decimal getPercentageHeapSizeLeft(Map<String, Integer> currentLimits, Integer heapSizeDivisor) {
    Decimal percentageOfHeapSizeLeft =  ((Double) getHeapSizeLeft(currentLimits)/heapSizeDivisor)*100;
    return percentageOfHeapSizeLeft;
  }

  private static Integer getQueriesUsed() {
    return Limits.getQueries();
  }

  private static Integer getCPUTimeUsed() {
    return Limits.getCpuTime();
  }

  private static Integer getHeapSizeUsed() {
    return Limits.getHeapSize();
  }
}