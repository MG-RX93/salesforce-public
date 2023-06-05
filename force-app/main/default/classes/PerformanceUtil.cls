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
      when SYNCHRONOUS, RUNTEST_SYNC, AURA {
        syncLimitsUsage(currentLimits, className, methodName, executionContext , sObjectName, size, currentContext);
      }
      when BATCH_APEX, RUNTEST_ASYNC, BULK_API, FUTURE {
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
    pl.ApexClass__c = className;
    pl.ApexMethod__c = methodName;
    pl.ApexExecContext__c = executionContext;
    pl.ApexSObject__c = sObjectName;
    pl.Queries_Used__c = getQueriesUsed();
    pl.CPU_Time_Used__c = getCPUTimeUsed();
    pl.Heap_Size_Used__c = getHeapSizeUsed();
    pl.Query_Limits__c = currentLimits.get('queryCountPre');
    pl.CPUTime_Limits__c = currentLimits.get('cpuTimePre');
    pl.HeapSize_Limits__c = currentLimits.get('heapSizePre');
    pl.Queries_Left_percentage__c = getPercentageQueriesLeft(currentLimits, queryCountDivisor);
    pl.CPUTime_Left_percentage__c = getPercentageCPUTimeLeft(currentLimits, cpuTimeDivisor);
    pl.Heap_Size_Left_percentage__c = getPercentageHeapSizeLeft(currentLimits, heapSizeDivisor);
    pl.RecordsInContext__c = size;
    pl.RequestId__c = String.valueOf(Request.getCurrent().getRequestId());
    pl.Quiddity__c = String.valueOf(Request.getCurrent().getQuiddity());
    pl.IsCurrentContextTrigger__c = currentContext;
    System.debug('Sync Log: '+JSON.serialize(pl));
    System.debug('Timestamp:'+System.now());
    insert pl;
    callDataDogPost(JSON.serialize(pl));
    // System.debug('queryCount% left: '+ (queryCountUsedPercent)*100 + '%');
    // System.debug('cpuTime% left: '+ (cpuTimeUsedPercent)*100+ '%');
    // System.debug('heapSize% left: '+(heapSizeUsedPercent)*100+ '%'); 

    // Persist all data to an object.
  }

  private static void asyncLimitsUsage(Map<String, Integer> currentLimits, String className, String methodName, String executionContext, String sObjectName, Integer size, Boolean currentContext) {
    Integer queryCountDivisor = 200, cpuTimeDivisor = 60000, heapSizeDivisor = 12000000;

    
    PerformanceLog__c pl = new PerformanceLog__c();
    pl.ApexClass__c = className;
    pl.ApexMethod__c = methodName;
    pl.ApexExecContext__c = executionContext;
    pl.ApexSObject__c = sObjectName;
    pl.Queries_Used__c = getQueriesUsed();
    pl.CPU_Time_Used__c = getCPUTimeUsed();
    pl.Heap_Size_Used__c = getHeapSizeUsed();
    pl.Query_Limits__c = currentLimits.get('queryCountPre');
    pl.CPUTime_Limits__c = currentLimits.get('cpuTimePre');
    pl.HeapSize_Limits__c = currentLimits.get('heapSizePre');
    pl.Queries_Left_percentage__c = getPercentageQueriesLeft(currentLimits, queryCountDivisor);
    pl.CPUTime_Left_percentage__c = getPercentageCPUTimeLeft(currentLimits, cpuTimeDivisor);
    pl.Heap_Size_Left_percentage__c = getPercentageHeapSizeLeft(currentLimits, heapSizeDivisor);
    pl.RecordsInContext__c = size;
    pl.RequestId__c = String.valueOf(Request.getCurrent().getRequestId());
    pl.Quiddity__c = String.valueOf(Request.getCurrent().getQuiddity());
    pl.IsCurrentContextTrigger__c = currentContext;
    System.debug('Async Log: '+JSON.serialize(pl));
    System.debug('Timestamp:'+System.now());
    insert pl;
    callDataDogPost(JSON.serialize(pl));

    // System.debug('queryCount % left: '+ (queryCountUsedPercent)*100 + '%');
    // System.debug('cpuTime % left: '+ (cpuTimeUsedPercent)*100+ '%');
    // System.debug('heapSize % left: '+(heapSizeUsedPercent)*100+ '%'); 

    // Persist all data to an object.
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