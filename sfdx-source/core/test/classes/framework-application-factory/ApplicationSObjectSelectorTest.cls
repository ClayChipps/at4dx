/**
 * Copyright (c) 2021, John M. Daniel & John Storey
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the John M. Daniel, nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

@IsTest
private class ApplicationSObjectSelectorTest
{
    @IsTest
    private static void testInheritedSharingSelectorInheritedSharingInjectableWithSharingController() {
        ApplicationSObjectSelectorDIModule.bindingRecords.addAll(
            new List<ApplicationFactory_SelectorBinding__mdt> {
                new ApplicationFactory_SelectorBinding__mdt(
                    BindingSObjectAlternate__c = 'Account',
                    To__c = 'ApplicationSObjectSelectorTest.TestAccountsSelectorInheritedSharing'  
                )
            }
        );
        
        Application.Selector.setMock(new TestAccountsSelectorInheritedSharing());

        Account testAccount = new Account(
            Name = 'A Test Account',
            AccountNumber = '123456'
        );

        insert testAccount;

        User testUser = new User(
            Alias = 'standt',
            Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'at4dxwizard@gooble.com'
        );

        insert testUser;

        System.runAs(testUser) {
            List<Account> accounts = new ControllerWithSharing().selectAccountsByNumberWith(
                'ApplicationSObjectSelectorTest.TestSelectorMethodInheritedSharing', 
                new Set<string>{ '123456' }
            );

            System.Assert.areEqual(0, accounts.size());
        }
    }

    @IsTest
    private static void testInheritedSharingSelectorInheritedSharingInjectableWithoutSharingController() {
        ApplicationSObjectSelectorDIModule.bindingRecords.addAll(
            new List<ApplicationFactory_SelectorBinding__mdt> {
                new ApplicationFactory_SelectorBinding__mdt(
                    BindingSObjectAlternate__c = 'Account',
                    To__c = 'ApplicationSObjectSelectorTest.TestAccountsSelectorInheritedSharing'  
                )
            }
        );
        
        Application.Selector.setMock(new TestAccountsSelectorInheritedSharing());

        Account testAccount = new Account(
            Name = 'A Test Account',
            AccountNumber = '123456'
        );

        insert testAccount;

        User testUser = new User(
            Alias = 'standt',
            Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'at4dxwizard@gooble.com'
        );

        insert testUser;

        System.runAs(testUser) {
            List<Account> accounts = new ControllerWithoutSharing().selectAccountsByNumberWith(
                'ApplicationSObjectSelectorTest.TestSelectorMethodInheritedSharing', 
                new Set<string>{ '123456' }
            );

            System.Assert.areEqual(1, accounts.size());
        }
    }

    @IsTest
    private static void testInheritedSharingSelectorWithoutSharingInjectableWithoutSharingController() {
        ApplicationSObjectSelectorDIModule.bindingRecords.addAll(
            new List<ApplicationFactory_SelectorBinding__mdt> {
                new ApplicationFactory_SelectorBinding__mdt(
                    BindingSObjectAlternate__c = 'Account',
                    To__c = 'ApplicationSObjectSelectorTest.TestAccountsSelectorInheritedSharing'  
                )
            }
        );
        
        Application.Selector.setMock(new TestAccountsSelectorInheritedSharing());

        Account testAccount = new Account(
            Name = 'A Test Account',
            AccountNumber = '123456'
        );

        insert testAccount;

        User testUser = new User(
            Alias = 'standt',
            Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'at4dxwizard@gooble.com'
        );

        insert testUser;

        System.runAs(testUser) {
            List<Account> accounts = new ControllerWithoutSharing().selectAccountsByNumberWith(
                'ApplicationSObjectSelectorTest.TestSelectorMethodWithoutSharing', 
                new Set<string>{ '123456' }
            );

            System.Assert.areEqual(1, accounts.size());
        }
    }

    public inherited sharing class ControllerInheritedSharing {
        public List<Account> selectAccountsByNumberWith(String injectableClazz, Set<String> accountNumberSet) {
            IApplicationSObjectSelector selector = Application.Selector.newInstance(Account.getSObjectType());
            TestSelectorMethodParameters queryParams = new TestSelectorMethodParameters();
            queryParams.accountNumberSet = new Set<string>{ '123456' };

            return (List<Account>) selector.selectInjection(Type.forName(injectableClazz), queryParams);
        }
    }

    public with sharing class ControllerWithSharing {
        public List<Account> selectAccountsByNumberWith(String injectableClazz, Set<String> accountNumberSet) {
            IApplicationSObjectSelector selector = Application.Selector.newInstance(Account.getSObjectType());
            TestSelectorMethodParameters queryParams = new TestSelectorMethodParameters();
            queryParams.accountNumberSet = new Set<string>{ '123456' };

            return (List<Account>) selector.selectInjection(Type.forName(injectableClazz), queryParams);
        }
    }

    public without sharing class ControllerWithoutSharing {
        public List<Account> selectAccountsByNumberWith(String injectableClazz, Set<String> accountNumberSet) {
            IApplicationSObjectSelector selector = Application.Selector.newInstance(Account.getSObjectType());
            TestSelectorMethodParameters queryParams = new TestSelectorMethodParameters();
            queryParams.accountNumberSet = new Set<string>{ '123456' };

            return (List<Account>) selector.selectInjection(Type.forName(injectableClazz), queryParams);
        }
    }

    public interface ITestAccountsSelector
        extends IApplicationSObjectSelector
    {
        List<Account> selectById(Set<Id> idSet);
    }

    @TestVisible
    public inherited sharing class TestAccountsSelectorInheritedSharing
        extends ApplicationSObjectSelector
        implements ITestAccountsSelector
    {
        public Schema.sObjectType getSObjectType()
        {
            return Account.SObjectType;
        }

        private List<Schema.SObjectField> getAdditionalSObjectFieldList()
        {
            return new List<Schema.SObjectField> { };
        }

        public List<Account> selectById(Set<Id> idSet)
        {
            return (List<Account>) selectSObjectsById( idSet ?? new Set<Id>() );
        }
    }
    
    @TestVisible
    public with sharing class TestAccountsSelectorWithSharing
        extends ApplicationSObjectSelector
        implements ITestAccountsSelector
    {
        public Schema.sObjectType getSObjectType()
        {
            return Account.SObjectType;
        }

        private List<Schema.SObjectField> getAdditionalSObjectFieldList()
        {
            return new List<Schema.SObjectField> { };
        }

        public List<Account> selectById(Set<Id> idSet)
        {
            return (List<Account>) selectSObjectsById( idSet ?? new Set<Id>() );
        }
    }
    
    @TestVisible
    public without sharing class TestAccountsSelectorWithoutSharing
        extends ApplicationSObjectSelector
        implements ITestAccountsSelector
    {
        public Schema.sObjectType getSObjectType()
        {
            return Account.SObjectType;
        }

        private List<Schema.SObjectField> getAdditionalSObjectFieldList()
        {
            return new List<Schema.SObjectField> { };
        }

        public List<Account> selectById(Set<Id> idSet)
        {
            return (List<Account>) selectSObjectsById( idSet ?? new Set<Id>() );
        }
    }

    public class TestSelectorMethodParameters
        implements ISelectorMethodParameterable
    {
        public Set<String> accountNumberSet;
    }

    public inherited sharing class TestSelectorMethodInheritedSharing
        extends AbstractSelectorMethodInjectable
        implements ISelectorMethodInjectable
    {
        public List<SObject> selectQuery()
        {
            TestSelectorMethodParameters queryParams = (TestSelectorMethodParameters) getParameters();

            Set<String> accountNumberSet = queryParams.accountNumberSet;

            return Database.query( newQueryFactory().setCondition( Account.AccountNumber + ' in :accountNumberSet').toSOQL() );
        }
    }

    public with sharing class TestSelectorMethodWithSharing
        extends AbstractSelectorMethodInjectable
        implements ISelectorMethodInjectable
    {
        public List<SObject> selectQuery()
        {
            TestSelectorMethodParameters queryParams = (TestSelectorMethodParameters) getParameters();

            Set<String> accountNumberSet = queryParams.accountNumberSet;

            return Database.query( newQueryFactory().setCondition( Account.AccountNumber + ' in :accountNumberSet').toSOQL() );
        }
    }

    public without sharing class TestSelectorMethodWithoutSharing
        extends AbstractSelectorMethodInjectable
        implements ISelectorMethodInjectable
    {
        public List<SObject> selectQuery()
        {
            TestSelectorMethodParameters queryParams = (TestSelectorMethodParameters) getParameters();

            Set<String> accountNumberSet = queryParams.accountNumberSet;

            return Database.query( newQueryFactory().setCondition( Account.AccountNumber + ' in :accountNumberSet').toSOQL() );
        }
    }
}
