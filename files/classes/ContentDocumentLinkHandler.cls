public without sharing class ContentDocumentLinkHandler {
  /**
   * @description process files attached to case records
   * @param oldList
   * @param newList
   * @param oldMap
   * @param newMap
   */
  public static void processCaseFiles(
    List<ContentDocumentLink> oldList,
    List<ContentDocumentLink> newList,
    Map<Id, ContentDocumentLink> oldMap,
    Map<Id, ContentDocumentLink> newMap
  ) {    
    ProcessCaseFiles pcf = new ProcessCaseFiles();
    pcf.execute(oldList, newList, oldMap, newMap);
  }
}
