List<Account> accountList = new List<Account>();
for (Integer i = 0; i < 1; i++) {
  Account a = new Account();
  a.Name = 'Test';
  a.Industry = 'Test';
  accountList.add(a);
}
System.debug('accounts:'+accountList);
insert accountList;

List<Contact> contactList = new List<Contact>();
for (Integer i = 0; i < accountList.size(); i++) {
  Contact c = new Contact();
  c.FirstName = 'Test' + i;
  c.LastName = 'User';
  c.Email = 'testuser' + i + '@gmail.com';
  c.AccountId = accountList[i].Id;
  contactList.add(c);
}
System.debug('contactList: '+contactList);
insert contactList;

List<Case> caseList = new List<Case>();
for (Integer i = 0; i < contactList.size(); i++) {
  Case c = new Case();
  c.Status = 'New';
  c.AccountId = accountList[i].Id;
  c.ContactId = contactList[i].Id;
  c.Subject = 'Test Case' + i;
  c.Origin = 'Phone';
  caseList.add(c);
}
System.debug('caseList: '+caseList);
insert caseList;

List<ContentVersion> cvList = new List<ContentVersion>();
for (Integer i = 0; i < caseList.size(); i++) {
  ContentVersion contentVersion = new ContentVersion(
    Title = 'Test Document' + String.ValueOf(i),
    PathOnClient = 'TestDocument.txt',
    VersionData = Blob.valueOf('Test content data'),
    IsMajorVersion = true
  );
  cvList.add(contentVersion);
}
insert cvList;

List<ContentDocument> documents = [
  SELECT Id, Title, LatestPublishedVersionId
  FROM ContentDocument WHERE Title LIKE '%Test Document%'
];
System.debug('Documents: '+documents);

List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
for (Integer i = 0; i < caseList.size(); i++) {
  ContentDocumentLink cdl = new ContentDocumentLink();
  cdl.LinkedEntityId = caseList[i].Id;
  cdl.ContentDocumentId = documents[i].Id;
  cdl.ShareType = 'V';
  cdlList.add(cdl);
}
System.debug('cdlList: '+cdlList);
insert cdlList;
