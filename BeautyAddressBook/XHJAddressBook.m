//
//  XHJAddressBook.m
//  BM
//
//  Created by yuhuajun on 15/7/13.
//  Copyright (c) 2015年 yuhuajun. All rights reserved.
//

#import "XHJAddressBook.h"
#import "PersonModel.h"
#import  "NSString+TKUtilities.h"

@implementation XHJAddressBook
- (instancetype)init
{
    self = [super init];
    if(self){
        _addressArr = [[NSArray alloc]init];
        _persons = [[NSMutableArray alloc]init];
        _listContent = [NSMutableArray new];
        _list2Content=[NSMutableArray new];
        _sectionTitles=[NSMutableArray new];
 
    }
    return self;
}
 
-(UILocalizedIndexedCollation *)addbookSort:(NSMutableArray*)personArr
{
    // 对数据进行排序，并按首字母分类
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (PersonModel *addressBook in personArr) {
        NSInteger sect = [theCollation sectionForObject:addressBook
                                collationStringSelector:@selector(lastName)];
        
        addressBook.sectionNumber = sect;
        //给各个名字放入正确的标签
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];//27
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    //把对应的名字放入这个27个数组
    for (PersonModel *addressBook in personArr) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(firstName)];

        [_listContent addObject:sortedSection];
    }
    return  theCollation;
}

-(NSMutableArray*)getAllPerson
{
    // Create addressbook data model
    NSMutableArray *addressBookTemp = [NSMutableArray array];
    CFErrorRef error = NULL;
    ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, &error);
    
    int staticid=ABAddressBookGetAuthorizationStatus();
    if(staticid==2)//拒绝授权返回
    {
      
         return nil;
    }
    NSLog(@"staticid:%d",staticid);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);//发出访问通讯录的请求
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
        
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    
    for (NSInteger i = 0; i < nPeople; i++)
    {
        PersonModel *addressBook = [[PersonModel alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
        addressBook.name1 = nameString;
        addressBook.phonename=nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        addressBook.rowSelected = NO;   // addressbook 某一行是否被选中
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,  // 电话
            kABPersonEmailProperty   // 邮件
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = [(__bridge NSString*)value initTelephoneWithReformat];
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        [addressBookTemp addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    CFRelease(allPeople);
    CFRelease(addressBooks);
    
    // 对数据进行排序，并按首字母分类
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles removeAllObjects];
    
    [self.sectionTitles addObjectsFromArray:[theCollation sectionTitles]];
 
    for (PersonModel *addressBook in addressBookTemp) {
        if(addressBook.name1!=nil)
        {
            
          NSInteger sect = [theCollation sectionForObject:addressBook
                    collationStringSelector:@selector(name1)];
          addressBook.sectionNumber = sect;
          //给各个名字放入正确的标签
        }
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];//27
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    //把对应的名字放入这个27个数组
    for (PersonModel *addressBook in addressBookTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
 
        PersonModel *person=(PersonModel*)sectionArray.firstObject;
        if(person.name1==nil||[person.name1 isEqualToString:@""])
        {
            continue;
        }
       if (person.name1 != nil)
        {
           NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name1)];
          [_list2Content addObject:sortedSection];
        }
    }

    return _list2Content;
}

-(void)dealloc
{
    _perArr=nil;
    _localCollation=nil;
    _sectionTitles=nil;
    _addressArr=nil;
    _persons=nil;
    _listContent =nil;
    _list2Content=nil;
 
}

@end
