public class CaseTriggerHandler{

  
  public static void runBeforeInsert(List<Case> newList, List<Case> oldList, Map<Id, Case> newMap, Map<Id, Case> oldMap) {
    Integer count = 0;
    for(Case c: newList) {
        while (Limits.getCpuTime() < 500) {
            count++;    
        }
      // System.debug(c);
    }
  }

  public static void runBeforeUpdate(List<Case> newList, List<Case> oldList, Map<Id, Case> newMap, Map<Id, Case> oldMap) {
    Integer count = 0;
    for(Case c: newList) {
        while (Limits.getCpuTime() < 1000) {
        count++;    
        }
      // System.debug(c);
    }
  }

  public static void runAfterInsert(List<Case> newList, List<Case> oldList, Map<Id, Case> newMap, Map<Id, Case> oldMap) {
    Integer count = 0;
    for(Case c: newList) {
      while (Limits.getCpuTime() < 1500) {
        count++;    
      }
      // System.debug(c);
    }
  }

  public static void runAfterUpdate(List<Case> newList, List<Case> oldList, Map<Id, Case> newMap, Map<Id, Case> oldMap) {
    Integer count = 0;
    for(Case c: newList) {
    while (Limits.getCpuTime() < 2000) {
        count++;    
      }
      // System.debug(c);
    }
  }
  
  @InvocableMethod(label = 'Case CPU time limit error')
  public static void runPBFlowLogic(List<Case> newList) {
    Integer count = 0;
    for(Case c: newList) {
    while (Limits.getCpuTime() < 3000) {
        count++;    
      }
    }
  }

}