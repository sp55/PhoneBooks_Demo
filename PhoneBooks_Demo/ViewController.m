//
//  ViewController.m
//  PhoneBooks_Demo
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 AlezJi. All rights reserved.
//
//http://www.jianshu.com/p/f47daa36f75a
//ios9.0 获取通讯录数据“干货”分享



//http://www.jianshu.com/p/0b3a9498d0a6
//iOS9.0访问通讯录---ContactsUI和Contacts
#import "ViewController.h"
#import <ContactsUI/ContactsUI.h>


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<CNContactPickerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArr=[NSMutableArray array];
  
    [self getAuthor];
  
    
    [self initUI];
}
-(void)initUI
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
#pragma mark -tableView delegate&dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"单元格被点击了");
}

// 1. 获取权限
- (void)getAuthor {
    
    // 1. 判断当前的授权状态
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
        
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"授权成功");
            } else {
                NSLog(@"授权失败");
            }
        }];
    }
}
// 2. 获取所有联系人的信息
- (IBAction)getPhoneBooksAction:(UIBarButtonItem *)sender {
    // 1. 判断授权状态
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] != CNAuthorizationStatusAuthorized) {
        NSLog(@"请授权");
        return;
    }
    
    // 2. 获取联系人仓库
    CNContactStore *store = [[CNContactStore alloc] init];
    
    // 3. 创建联系人信息的请求对象
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    
    // 4. 根据请求Key, 创建请求对象
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    
    // 5. 发送请求
    [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        // 6.1 获取姓名
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSLog(@"%@--%@", givenName, familyName);
        
        // 6.2 获取电话
        NSArray *phoneArray = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneArray) {
            
            CNPhoneNumber *number = labelValue.value;
            NSLog(@"%@--%@", number.stringValue, labelValue.label);
            
            [self.dataArr addObject:[NSString stringWithFormat:@"%@%@:%@",givenName,familyName,number.stringValue]];
        }
        
        
        [self.tableView reloadData];
    }];
    
}



























//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    // 1. 创建选择联系人控制器
//    CNContactPickerViewController *pickerVC = [[CNContactPickerViewController alloc] init];
//    
//    // 2. 设置代理
//    pickerVC.delegate = self;
//    
//    // 3. 弹出控制器
//    [self presentViewController:pickerVC animated:YES completion:nil];
//
//}

//#pragma mark - 代理方法
//// 控制器点击取消的时候调用
//- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
//    NSLog(@"点击了取消");
//}

// 点击了联系人的时候调用, 如果实现了这个方法, 就无法进入联系人详情界面
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
//    
//    // contact属性就是联系人的信息
//    NSLog(@"%@---%@", contact.namePrefix, contact.familyName);
//    
//    // 获取联系人的电话号码
//    NSArray<CNLabeledValue<CNPhoneNumber*>*> *phoneNumbers = contact.phoneNumbers;
//    
//    // 注意, 由于这个数组规定了泛型, 所以要使用遍历器来取出每一个特定类型的对象, 才能取到里面的属性
//    [phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue<CNPhoneNumber*> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        NSLog(@"%@--%@", obj.label, obj.value.stringValue);
//    }];
//}

// 点击了联系人的确切属性的时候调用, 注意, 这两个方法只能实现一个
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
//    NSLog(@"%@---%@", contactProperty.key, contactProperty.value);
//}

@end
