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
    this.runInsertValidations(oldList, newList, oldMap, newMap);
  }

  private void runInsertValidations(
    List<ContentDocumentLink> oldList,
    List<ContentDocumentLink> newList,
    Map<Id, ContentDocumentLink> oldMap,
    Map<Id, ContentDocumentLink> newMa
  ) {
    List<Id> caseIdList = new List<Id>();
    List<Id> fileIdList = new List<Id>();
    Map<Id, Id> caseAndFileMap = new Map<Id, Id>();
    for (ContentDocumentLink cdl : newList) {
      if (
        cdl.LinkedEntityId != null &
        String.valueOf(cdl.LinkedEntityId).startsWith('500')
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
    if (!caseIdList.isEmpty()) {
      updateCaseStatus(caseIdList);
    }
  }

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

  private List<Case> getCaseList(List<Id> caseIdList) {
    List<Case> caseList = [
      SELECT
        Id,
        CaseNumber,
        Number_of_Attachments__c,
        Number_of_Deflections__c,
        Case_Priority_Score__c
      FROM Case
      WHERE Id IN :caseIdList
    ];

    return caseList;
  }

  private void setFileSharing(List<Id> fileIdList) {
    List<ContentDocument> cdList = new List<ContentDocument>();
    Map<Id, ContentDocument> cdMap = this.getCDMap(fileIdList);
    for (ContentDocument cd : cdMap.values()) {
      if (
        !(UserInfo.getUserName().startswith('user@gmail.com') ||
        UserInfo.getUserName().startswith('user2@gmail.com'))
      ) {
        cd.SharingPrivacy = 'P';
        cdList.add(cd);
      }
    }
    update cdList;
  }

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

  private void updateCaseStatus(List<Id> caseIdList) {
    List<Case> casesToUpdate = new List<Case>();
    List<Case> caseList = getCaseList(caseIdList);
    for (Case c : caseList) {
      if (c.Number_of_Files__c != null) {
        c.Number_of_Files__c += 1;
        casesToUpdate.add(c);
      } else {
        c.Number_of_Files__c = 1;
        casesToUpdate.add(c);
      }
    }

    update casesToUpdate;
  }
}
