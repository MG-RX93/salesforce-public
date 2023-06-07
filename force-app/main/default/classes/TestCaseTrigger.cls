@isTest
public class TestCaseTrigger {
  static List<Account> accountList;
  static List<Contact> contactList;
  static List<Case> caseList;

  @isTest
  private static void updateCases() {
    init();
    Test.StartTest();    
    for (Case c: caseList) {
      if (c.Status == 'New') {
        c.Status = 'Working';
      }
    }
    update caseList;
    Test.StopTest();
  }

  private static void init() {
    accountList = new List<Account>();
    for (Integer i = 1; i < 5; i++) {
      Account a = new Account(
        Name = 'Meraki' + i,
        Industry = 'Networking'
      );
      accountList.add(a);
    }
    insert accountList;

    contactList = new List<Contact>();
    for (Integer i = 0; i < 4; i++) {
      Contact c = new Contact(
        FirstName = 'Test' + i,
        LastName = 'Tester',
        Email = 'testuser' + i + '@gmail.com',
        AccountId = accountList[i].Id
      );
      contactList.add(c);
    }
    insert contactList;

    caseList = new List<Case>();
    for (Integer i = 0; i < 4; i++) {
      Case c = new Case(
        Subject = 'Test',
        Description = 'Tester',
        AccountId = accountList[i].Id,
        ContactId = contactList[i].Id
      );
      caseList.add(c);
    }
    insert caseList;
  }
}