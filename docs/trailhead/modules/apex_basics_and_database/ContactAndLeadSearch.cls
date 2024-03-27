/**
 * Module: Apex Basics & Database
 * Chapter: Write SOSL queries
 * 
 */
public without sharing class ContactAndLeadSearch {

  public static List<List<sObject>> searchContactsAndLeads(String soslSearchFilter) {
    List<List<sObject>> objectList = [FIND :soslSearchFilter IN NAME FIELDS RETURNING Contact(LastName),Lead(LastName)];
    return objectList;
  }
}