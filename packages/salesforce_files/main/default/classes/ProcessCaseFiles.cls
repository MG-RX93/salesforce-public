/**
 * @description Processes Files related to Case object
 */
public without sharing class ProcessCaseFiles {
  /**
   * @description public execute method
   * @param oldList
   * @param newList
   * @param oldMap
   * @param newMap
   */
  public void execute(
    List<ContentDocumentLink> oldList,
    List<ContentDocumentLink> newList,
    Map<Id, ContentDocumentLink> oldMap,
    Map<Id, ContentDocumentLink> newMap
  ) {
    this.runAfterInsertValidations(oldList, newList, oldMap, newMap);
  }

  /**
   * @description run validations for all after insert transactions
   * @param oldList
   * @param newList
   * @param oldMap
   * @param newMap
   */
  @TestVisible
  private void runAfterInsertValidations(
    List<ContentDocumentLink> oldList,
    List<ContentDocumentLink> newList,
    Map<Id, ContentDocumentLink> oldMap,
    Map<Id, ContentDocumentLink> newMap
  ) {
    List<Id> caseIdList = new List<Id>();
    List<Id> fileIdList = new List<Id>();
    Map<Id, Id> caseAndFileMap = new Map<Id, Id>();
    String objectPrefix = System.Label.CaseObjectPrefix;
    for (ContentDocumentLink cdl : newList) {
      if (
        cdl.LinkedEntityId != null &
        String.valueOf(cdl.LinkedEntityId).startsWith(objectPrefix)
      ) {
        caseIdList.add(cdl.LinkedEntityId);
        fileIdList.add(cdl.ContentDocumentId);
        caseAndFileMap.put(cdl.LinkedEntityId, cdl.ContentDocumentId);
      }
    }

    if (!fileIdList.isEmpty()) {
      setFileSharing(fileIdList);
    }
    if (
      !fileIdList.isEmpty() &&
      !caseAndFileMap.isEmpty() &&
      !caseIdList.isEmpty()
    ) {
      insertFeedItem(fileIdList, caseAndFileMap, caseIdList);
    }
  }

  /**
   * @description get content document records as a Map
   * @param fileIdList
   * @return cdMap
   */
  @TestVisible
  private Map<Id, ContentDocument> getCDMap(List<Id> fileIdList) {
    Map<Id, ContentDocument> cdMap = new Map<Id, ContentDocument>(
      [
        SELECT Id, Title, SharingPrivacy
        FROM ContentDocument
        WHERE Id IN :fileIdList
      ]
    );

    return cdMap;
  }

  /**
   * @description get a list of case records from Ids
   * @param caseIdList
   * @return caseList
   */
  @TestVisible
  private List<Case> getCaseList(List<Id> caseIdList) {
    List<Case> caseList = [
      SELECT Id, CaseNumber, Number_of_Attachments__c
      FROM Case
      WHERE Id IN :caseIdList
    ];

    return caseList;
  }

  /**
   * @description set the SharingPrivacy value to private based on the username of the user in context.
   * @param fileIdList
   */
  @TestVisible
  private void setFileSharing(List<Id> fileIdList) {
    List<ContentDocument> cdList = new List<ContentDocument>();
    Map<Id, ContentDocument> cdMap = this.getCDMap(fileIdList);
    String userNameInContext = UserInfo.getUserName();
    String adminUserNames = System.Label.AdminUserNames;
    List<String> userNameList = adminUserNames.split(',');
    if (userNameList.contains(userNameInContext)) {
      for (ContentDocument cd : cdMap.values()) {
        cd.SharingPrivacy = 'P';
        cdList.add(cd);
      }
      update cdList;
    }
  }

  /**
   * @description inserts a feed item record on the respective cases with the title of the related file and links the url to the file
   * @param fileIdList
   * @param caseAndFileMap
   * @param caseIdList
   */
  @TestVisible
  private void insertFeedItem(
    List<Id> fileIdList,
    Map<Id, Id> caseAndFileMap,
    List<Id> caseIdList
  ) {
    List<FeedItem> feedItemList = new List<FeedItem>();
    Map<Id, ContentDocument> cdMap = this.getCDMap(fileIdList);
    List<Case> caseList = getCaseList(caseIdList);
    for (Case c : caseList) {
      String cdURL =
        URL.getOrgDomainURL().toExternalForm() +
        '/' +
        cdMap.get(caseAndFileMap.get(c.Id)).Id;
      String cdTitle = cdMap.get(caseAndFileMap.get(c.Id)).Title;
      String feedItemBody =
        '<a href="' +
        String.escapeSingleQuotes(cdURL) +
        '">' +
        cdTitle.escapeHtml4() +
        '</a>';
      FeedItem fi = new FeedItem();
      fi.ParentId = c.Id;
      fi.Body = 'Uploaded File: ' + feedItemBody;
      fi.Type = 'ContentPost';
      fi.IsRichText = true;
      feedItemList.add(fi);
    }

    insert feedItemList;
  }
}