@isTest
public class HandlerChatBot_Test {

    static testMethod void postChattextTest() {
        Lead newLead = new Lead();
        newLead.Company='Capgemini';
        newLead.Email= 'dig@capgemini.com';
        newLead.FirstName='Digvijay';
        newLead.LastName='Singh';
        HandlerChatBot.createRecord(newLead);
        Test.startTest();
        HandlerChatBot.postChatText('Hello');
        Test.stopTest();
        
    }

}