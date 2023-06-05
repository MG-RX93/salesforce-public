public class CaseTriggerDispatcher{


    /**
    *@Description: all before context calls of Insert, Update and Delete operations
    */
    public static void beforeContextCalls(List<Case> oldList, List<Case> newList, Map<Id,Case> oldMap,Map<Id,Case> newMap){
        /**
        *@Description: Insert Scenario calls
        */
        if(Trigger.isInsert) {
           Map<String, Integer> currentLimits = PerformanceUtil.getCurrentLimits();
           CaseTriggerHandler.runBeforeInsert(newList, oldList,newMAp, oldMap);
           PerformanceUtil.capturePerformanceMetrics(currentLimits, 'All', 'All' ,String.valueOf(Trigger.operationType) , 'Case', Trigger.size, Trigger.isExecuting);
        }
        
        /**
        *@Description: Update Scenario calls
        */
        if(Trigger.isUpdate) {
           Map<String, Integer> currentLimits = PerformanceUtil.getCurrentLimits();
           CaseTriggerHandler.runBeforeUpdate(newList, oldList,newMAp, oldMap);
           PerformanceUtil.capturePerformanceMetrics(currentLimits, 'All', 'All' ,String.valueOf(Trigger.operationType) , 'Case', Trigger.size, Trigger.isExecuting);
        }

        /**
        *@Description: Delete Scenario calls
        */
        if(Trigger.isDelete) {

        } 

    }

    /**
    *@Description: all after context calls of Insert, Update and Delete operations
    */
    public static void afterContextCalls(List<Case> oldList, List<Case> newList, Map<Id,Case> oldMap,Map<Id,Case> newMap){
        
        if(Trigger.isInsert) {
           Map<String, Integer> currentLimits = PerformanceUtil.getCurrentLimits();
           CaseTriggerHandler.runAfterInsert(newList, oldList,newMAp, oldMap);
           PerformanceUtil.capturePerformanceMetrics(currentLimits, 'All', 'All' ,String.valueOf(Trigger.operationType) , 'Case', Trigger.size, Trigger.isExecuting);
        }

        if(Trigger.isUpdate) {            
           Map<String, Integer> currentLimits = PerformanceUtil.getCurrentLimits();
           CaseTriggerHandler.runAfterUpdate(newList, oldList,newMAp, oldMap);
           PerformanceUtil.capturePerformanceMetrics(currentLimits, 'All', 'All' ,String.valueOf(Trigger.operationType) , 'Case', Trigger.size, Trigger.isExecuting);
        }


        if(Trigger.isDelete) {

        }
    }

}