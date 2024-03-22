public without sharing class ContentDocumentLinkDispatcher {
  // DO NOT REMOVE THIS CODE. WHEN REQUIRED THIS WILL BE UNCOMMENTED AND USED.
  // /**
  //  * @description processes before context triggers
  //  * @param oldList
  //  * @param newList
  //  * @param oldMap
  //  * @param newMap
  //  */
  // public static void processBeforeContextCalls(
  //   List<ContentDocumentLink> oldList,
  //   List<ContentDocumentLink> newList,
  //   Map<Id, ContentDocumentLink> oldMap,
  //   Map<Id, ContentDocumentLink> newMap
  // ) {
  // }

  /**
   * @description processes after context triggers
   * @param oldList
   * @param newList
   * @param oldMap
   * @param newMap
   */
  public static void processAfterContextCalls(
    List<ContentDocumentLink> oldList,
    List<ContentDocumentLink> newList,
    Map<Id, ContentDocumentLink> oldMap,
    Map<Id, ContentDocumentLink> newMap
  ) {
    if (Trigger.isInsert) {
      ContentDocumentLinkHandler.processCaseFiles(
        oldList,
        newList,
        oldMap,
        newMap
      );
    }
  }
}
