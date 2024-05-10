trigger ContentDocumentLinkTrigger on ContentDocumentLink(
  after insert,
  after update,
  after delete,
  before insert,
  before update,
  before delete
) {
  // DO NOT REMOVE THIS CODE. WHEN REQUIRED THIS WILL BE UNCOMMENTED AND USED.
  // if (Trigger.isBefore) {
  //   ContentDocumentLinkDispatcher.processBeforeContextCalls(
  //     Trigger.New,
  //     Trigger.Old,
  //     Trigger.NewMap,
  //     Trigger.OldMap
  //   );
  // }
  if (Trigger.isAfter) {
    ContentDocumentLinkDispatcher.processAfterContextCalls(
      Trigger.Old,
      Trigger.New,
      Trigger.OldMap,
      Trigger.NewMap
    );
  }
}