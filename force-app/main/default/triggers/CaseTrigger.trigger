trigger CaseTrigger on Case (after insert, after update, after delete, before insert, before update, before delete) {
    if(trigger.isBefore) {
        CaseTriggerDispatcher.beforeContextCalls(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
    }
    if(trigger.isAfter) {
        CaseTriggerDispatcher.afterContextCalls(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
    }
}