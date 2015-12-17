//
//  ListDetailViewController.h
//  Jobs
//
//  Created by 王振辉 on 15/6/5.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellbackgroundVIew.h"

typedef NS_ENUM(NSInteger, CompanyDetailOpenType){
    CompanyDetailOpenTypeAdd,
    CompanyDetailOpenTypeEdit
};

@class CompanyDetailViewController;
@class Company;

typedef void (^AddCompanyInsertZeroBlock)(Company *company);
typedef void (^EditCompanyReloadBlock)(Company *fromCompany, Company *toCompany);

@interface CompanyDetailViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UIBarButtonItem *saveBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;
@property (nonatomic, strong) Company *companyToEdit;
@property (nonatomic, assign) CompanyDetailOpenType companyDetailOpenType;
@property (nonatomic, copy) AddCompanyInsertZeroBlock addCompanyInsertZeroBlock;
@property (nonatomic, copy) EditCompanyReloadBlock editCompanyReloadBlock;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
