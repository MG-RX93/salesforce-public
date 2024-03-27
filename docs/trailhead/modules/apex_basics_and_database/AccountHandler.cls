/**
 * Module: Apex Basics & Database
 * Chapter: Manipulate Records with DML 
 * 
 */
public without sharing class AccountHandler {

  public static Account insertNewAccount(String accountName) {
    Account a = new Account();
    a.Name = accountName;

    Account insertedAccount = insertAccount(a);
    return insertedAccount;
  }

  private static Account insertAccount(Account a) {
    Database.SaveResult sr = Database.insert(a,false);
    
    if(sr.isSuccess()){
      return a;
    }else{
      return null;
    }
    
  }
}