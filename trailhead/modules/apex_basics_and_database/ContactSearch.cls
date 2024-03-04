/**
 * Module: Apex Basics & Database
 * Chapter: Write SOQL queries
 * 
 */
public  without sharing class ContactSearch {

  public static List<Contact> searchForContacts(String lastName, String mailingPostalCode) {
    List<Contact> contactList = new List<Contact>();
    for (Contact c : [SELECT Id, Name FROM Contact WHERE LastName = :lastName AND MailingPostalCode = :mailingPostalCode]) {
      contactList.add(c);
    }

    return contactList;
  }
}