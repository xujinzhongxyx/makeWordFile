//
//  newWordViewController.m
//  makeWordFile
//
//  Created by zlw on 2018/1/2.
//  Copyright © 2018年 xujinzhong. All rights reserved.
//

#import "newWordViewController.h"
#import "viewController.h"

@interface newWordViewController ()<NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property(nonatomic, strong) NSArray  *aryAllWords;                 //所有单词
@property(nonatomic, strong) NSMutableArray *aryAssociateWord;      //关联单词列表
@property(nonatomic, strong) NSMutableArray *aryAssociateWordEx;    //关联单词列表解释
@property(nonatomic, strong) NSMutableArray *aryMarkWords;          //陌生单词

/** 添加新单词 ***********************************************************/
@property (strong) IBOutlet NSTextField *textPrefix;    //词缀
@property (strong) IBOutlet NSTextField *textName;       //单词名称
@property (strong) IBOutlet NSTextField *textExplain;    //解释
@property (strong) IBOutlet NSTextField *textSplit;      //分解
@property (strong) IBOutlet NSTextField *textYinbiao;    //音标
@property (strong) IBOutlet NSTextField *textAssoWord;   //单词-关联
@property (strong) IBOutlet NSTextField *textAssoExplain;//单词-解释
//关联单词列表
@property (strong) IBOutlet NSScrollView    *tableViewAddContent;
@property (strong) IBOutlet NSTableView     *tableViewAddAssociate;

@property (strong) IBOutlet NSTextField *textEn;              //英文语句
@property (strong) IBOutlet NSTextField *textCn;              //中文语句
@property (strong) IBOutlet NSTextField *textMarkWordName;    //语句单词名称
@property (strong) IBOutlet NSTextField *textMarkWordExplain; //语句单词解释
@property (strong) IBOutlet NSTextField *textMark;            //单词说明
@property (strong) IBOutlet NSSearchField *wordSearchField;   //索索单词
@property (strong) IBOutlet NSTextField *lableWarning;        //提示信息


- (IBAction)back:(id)sender;

//添加关联单词按钮-点击事件
- (IBAction)addSocciateClickEvent:(id)sender;
//添加语句单词按钮-点击事件
- (IBAction)btnSenceClickEvent:(id)sender;
//添加单词按钮-点击事件
- (IBAction)addClickEvent:(id)sender;
//修改单词按钮-点击事件
- (IBAction)updateClickEvent:(id)sender;
//删除单词按钮-点击事件
- (IBAction)deleteClickEvent:(id)sender;
//搜索单词按钮-点击事件
- (IBAction)searchClickEvent:(id)sender;
//清空单词按钮-点击事件
- (IBAction)cleanWClickEvent:(id)sender;

@end

@implementation newWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setWantsLayer:YES];
    self.view.layer.backgroundColor = [Helper colorFromHexRGB:@"EBEBEB"].CGColor;
    
    [NSApp setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow)name:NSWindowWillCloseNotification object:nil];
    
    _aryAssociateWord = [NSMutableArray array];
    _aryAssociateWordEx = [NSMutableArray array];
    _aryMarkWords = [NSMutableArray array];

    [self initAssociateTableView];
}

- (void)closeWindow
{
    [NSApp terminate:self];
}

//添加关联单词按钮-点击事件
- (IBAction)addSocciateClickEvent:(id)sender {
    if (self.textAssoWord.stringValue.length==0 || self.textAssoExplain.stringValue.length==0) {
        self.lableWarning.stringValue = @"添加关联单词为空";
        [self.textAssoWord becomeFirstResponder];
        return;
    }
    //装载关联单词
    [self.aryAssociateWord addObject:self.textAssoWord.stringValue];
    [self.aryAssociateWordEx addObject:self.textAssoExplain.stringValue];
    //更新关联列表
    [_tableViewAddAssociate reloadData];
    //清空关联单词和解释
    self.textAssoWord.stringValue = self.textAssoExplain.stringValue = @"";
}

//添加语句单词按钮-点击事件
- (IBAction)btnSenceClickEvent:(id)sender {
    if (self.textMarkWordName.stringValue.length==0 || self.textMarkWordExplain.stringValue.length==0) {
        self.lableWarning.stringValue = @"添加陌生单词解释为空";
        [self.textMarkWordName becomeFirstResponder];
        return;
    }
    
    NSString *strMarkWord = [NSString stringWithFormat:@"%@-%@\n", self.textMarkWordName.stringValue, self.textMarkWordExplain.stringValue];
    [self.aryMarkWords addObject:strMarkWord];
    
    __block NSString *strAllMarkWrods = @"";
    [self.aryMarkWords enumerateObjectsUsingBlock:^(NSString *word, NSUInteger idx, BOOL * _Nonnull stop) {
        strAllMarkWrods = [strAllMarkWrods stringByAppendingString:word];
    }];
    self.textMark.stringValue = strAllMarkWrods;
    //清空关联单词和解释
    self.textMarkWordName.stringValue = self.textMarkWordExplain.stringValue = @"";
}

//添加单词按钮-点击事件
- (IBAction)addClickEvent:(id)sender {
    if ([self matchWord]) {
        [self makeJsonWords];
        NSString *specifiedWord = self.textName.stringValue;
        [self clearAllData];
        self.lableWarning.stringValue = [NSString stringWithFormat:@"添加【%@】成功。", specifiedWord];
        _aryAllWords = [self redaDataFromFile]; //重新跟新单词数据
    }
}

//修改单词按钮-点击事件
- (IBAction)updateClickEvent:(id)sender {
    NSString *word = _wordSearchField.stringValue;
    if (word.length==0) {
        self.lableWarning.stringValue = [NSString stringWithFormat:@"搜索的单词不为空。"];
        [_wordSearchField becomeFirstResponder];
        return;
    }
    //单词更新
    BOOL isSucc = [self updateSpecifyWord:word];
    if (isSucc) {
        _aryAllWords = [self redaDataFromFile]; //重新跟新单词数据
    }
}

//删除单词按钮-点击事件
- (IBAction)deleteClickEvent:(id)sender {
    if (self.textName.stringValue.length == 0) {
        self.lableWarning.stringValue = [NSString stringWithFormat:@"需要删除的单词不能为空。"];
        [self.textName becomeFirstResponder];
        return;
    }
    
    //显示搜索的单词
    NSMutableArray *aryMuWords = [NSMutableArray array];
    aryMuWords = [self redaDataFromFile].mutableCopy;
    
    __block NSString *word = self.textName.stringValue;
    __block NSInteger i = -1;
    [aryMuWords enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *wordName = obj[@"name"];
        if ([wordName isEqualToString:word]) {
            i = idx;
            *stop = YES;
        }
    }];
    
    if (i>=0) {
        //从文件中删除单词
        [aryMuWords removeObjectAtIndex:i];
        NSString *jsonData = aryMuWords.mj_JSONString;
        BOOL isSuce = [Helper setJsonDataJsonname:kFineName str:jsonData];
        if (isSuce) {
            self.lableWarning.stringValue = [NSString stringWithFormat:@"删除【%@】单词成功。", word];
        }
        
    }
}

//搜索单词按钮-点击事件
- (IBAction)searchClickEvent:(id)sender {
    if (self.wordSearchField.stringValue.length == 0) {
        self.lableWarning.stringValue = [NSString stringWithFormat:@"搜索的单词不能为空。"];
        [self.wordSearchField becomeFirstResponder];
        return;
    }
    
    //显示搜索的单词
    NSMutableArray *aryMuWords = [NSMutableArray array];
    aryMuWords = [self redaDataFromFile].mutableCopy;
    
    __block NSString *word = self.wordSearchField.stringValue;
    __block NSInteger i = -1;
    [aryMuWords enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *wordName = obj[@"name"];
        if ([wordName isEqualToString:word]) {
            i = idx;
            *stop = YES;
        }
    }];
    
    if (i>=0) {
        //在界面上显示单词信息
        [self displayWordOnInterface:aryMuWords[i]];
        NSString *msg = [NSString stringWithFormat:@"搜索到【%@】单词！", aryMuWords[i][@"name"]];
        self.lableWarning.stringValue = msg;
    }
}

//清空单词按钮-点击事件
- (IBAction)cleanWClickEvent:(id)sender {
    [self clearAllData];
}


-(void)makeJsonWords{
    NSMutableArray *aryWordsList = [NSMutableArray array];
    
    if ([self redaDataFromFile]) {
        aryWordsList = [self redaDataFromFile].mutableCopy;
    }
    
    //判断单词是否已经存在
    if ([self wordIsExist:aryWordsList andWord:self.textName.stringValue]) {
        self.lableWarning.stringValue = [NSString stringWithFormat:@"【%@】已经存在!", self.textName.stringValue];
        return;
    }
    
    NSDictionary *dicWord = @{
                              @"prefix":self.textPrefix.stringValue,    //词缀
                              @"name":self.textName.stringValue,        //单词名称
                              @"explain":self.textExplain.stringValue,  //解释
                              @"split":self.textSplit.stringValue,      //分解
                              @"yinbiao":self.textYinbiao.stringValue,  //单词音标
                              @"associateWord":self.aryAssociateWord,   //关联单词列表
                              @"associateEx":self.aryAssociateWordEx,   //关联单词解释列表
                              @"example":@{
                                      @"en":self.textEn.stringValue,    //英文语句
                                      @"cn":self.textCn.stringValue,    //中文语句
                                      @"mark":self.textMark.stringValue //单词说明
                                      }
                              };
    [aryWordsList addObject:dicWord];
    
    NSString *jsonData = aryWordsList.mj_JSONString;
    BOOL isSuce = [Helper setJsonDataJsonname:kFineName str:jsonData];
    if (isSuce) {
        self.lableWarning.stringValue = @"添加单词成功了";
    }
}

//更新指定单词
-(BOOL)updateSpecifyWord:(NSString *)word{
    NSMutableArray *aryWordsList = [NSMutableArray array];
    if ([self redaDataFromFile]) {
        aryWordsList = [self redaDataFromFile].mutableCopy;
    }
    
    __block NSInteger index = -1;
    [aryWordsList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *thisWord = obj[@"name"];
        if ([thisWord isEqualToString:word]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    //判断单词是否已经存在
    if (index < 0) {
        self.lableWarning.stringValue = [NSString stringWithFormat:@"【%@】单词不存在!", self.textName.stringValue];
        return NO;
    }
    
    NSDictionary *dicWord = @{
                              @"prefix":self.textPrefix.stringValue,    //词缀
                              @"name":self.textName.stringValue,        //单词名称
                              @"explain":self.textExplain.stringValue,  //解释
                              @"split":self.textSplit.stringValue,      //分解
                              @"yinbiao":self.textYinbiao.stringValue,  //单词音标
                              @"associateWord":self.aryAssociateWord,   //关联单词列表
                              @"associateEx":self.aryAssociateWordEx,   //关联单词解释列表
                              @"example":@{
                                      @"en":self.textEn.stringValue,    //英文语句
                                      @"cn":self.textCn.stringValue,    //中文语句
                                      @"mark":self.textMark.stringValue //单词说明
                                      }
                              };
    
    [aryWordsList removeObjectAtIndex:index];
    [aryWordsList insertObject:dicWord atIndex:index];
    
    NSString *jsonData = aryWordsList.mj_JSONString;
    BOOL isSuce = [Helper setJsonDataJsonname:kFineName str:jsonData];
    if (isSuce) {
        NSString *updateWord = [NSString stringWithFormat:@"更新【%@】单词成功了", word];
        self.lableWarning.stringValue = updateWord;
        return YES;
    }
    else{
        NSString *updateWord = [NSString stringWithFormat:@"更新【%@】单词失败了", word];
        self.lableWarning.stringValue = updateWord;
        return NO;
    }
    
    return NO;
}

-(BOOL)wordIsExist:(NSArray *)aryWords andWord:(NSString *)word{
    __block BOOL isExist = NO;
    [aryWords enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *thisWord = aryWords[idx][@"name"];
        if ([thisWord isEqualToString:word]) {
            isExist = *stop = YES;
        }
    }];
    
    return isExist;
}

-(NSInteger)indexOfWords:(NSString *)word{
    NSArray *aryWords = [self redaDataFromFile];
    __block BOOL isExist = NO;
    __block NSInteger index = 0;
    [aryWords enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *thisWord = aryWords[idx][@"name"];
        if ([thisWord isEqualToString:word]) {
            index = idx;
            isExist = *stop = YES;
        }
    }];
    
    return index;
}

-(void)clearAllData{
    self.lableWarning.stringValue = @"";   //提示信息
    self.textName.stringValue = @"";       //单词名称
    self.textExplain.stringValue = @"";    //解释
    self.textSplit.stringValue = @"";      //分解
    self.textYinbiao.stringValue = @"";    //单词音标
    self.textEn.stringValue = @"";         //英文语句
    self.textCn.stringValue = @"";         //中文语句
    self.textMark.stringValue = @"";       //单词说明
    self.textAssoWord.stringValue = @"";   //单词-关联
    self.textAssoExplain.stringValue = @"";//单词-解释
    //清空tableView列表
    [self.aryAssociateWord removeAllObjects];
    [self.aryAssociateWordEx removeAllObjects];
    [self.aryMarkWords removeAllObjects];
    [self.tableViewAddAssociate reloadData];
}

-(BOOL)matchWord{
    //词缀
    if (0==self.textPrefix.stringValue.length) {
        self.lableWarning.stringValue = warnMsg(@"词缀");
        [self.textPrefix becomeFirstResponder];
        return NO;
    }
    //单词名称
    if (0==self.textName.stringValue.length) {
        self.lableWarning.stringValue = warnMsg(@"单词名称");
        [self.textName becomeFirstResponder];
        return NO;
    }
    //解释
    if (0==self.textExplain.stringValue.length) {
        self.lableWarning.stringValue = warnMsg(@"解释");
        [self.textExplain becomeFirstResponder];
        return NO;
    }
    //分解
    if (0==self.textSplit.stringValue.length) {
        self.lableWarning.stringValue = warnMsg(@"分解");
        [self.textSplit becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

/** 从文件中获取数据 */
-(NSArray *)redaDataFromFile{
    NSString *allWordContent = [Helper getJsonDataJsonname:kFineName];
    NSArray *aryWords = allWordContent.mj_JSONObject;
    return aryWords;
}

-(void)displayWordOnInterface:(NSDictionary *)dicWord{
    _textPrefix.stringValue = dicWord[@"prefix"];//词缀
    _textName.stringValue = dicWord[@"name"];//单词名称
    _textExplain.stringValue = dicWord[@"explain"];//单词解释
    _textSplit.stringValue = dicWord[@"split"];//单词分解
    _textYinbiao.stringValue = dicWord[@"yinbiao"];//单词音标
    //单词列表-------------------------------------------
    _aryAssociateWord = dicWord[@"associateWord"];  //关联单词列表
    _aryAssociateWordEx = dicWord[@"associateEx"];//关联单词列表解释
    [_tableViewAddAssociate reloadData];
    
    _textEn.stringValue = dicWord[@"example"][@"en"];//英文语句
    _textCn.stringValue = dicWord[@"example"][@"cn"];//中文语句
    _textMark.stringValue = dicWord[@"example"][@"mark"];//单词说明
}

//初始化关联单词列表
-(void)initAssociateTableView{
    self.aryAllWords = [self redaDataFromFile];
    self.tableViewAddContent = [[NSScrollView alloc] init];
    [self.view addSubview:self.tableViewAddContent];
    
    [self.tableViewAddContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textAssoWord.mas_bottom).offset(5);
        make.bottom.equalTo(_textEn.mas_top).offset(-5);
        make.left.equalTo(_textAssoWord).offset(2);
        make.width.equalTo(_textExplain).offset(-4);
    }];
    
    self.tableViewAddAssociate = [[NSTableView alloc]initWithFrame:self.view.frame];
    self.tableViewAddAssociate.gridStyleMask = NSTableViewSolidVerticalGridLineMask|NSTableViewSolidHorizontalGridLineMask;
    self.tableViewAddAssociate.tag = 2;
    [self.view addSubview:self.tableViewAddAssociate];
    self.tableViewAddAssociate.delegate = self;
    self.tableViewAddAssociate.dataSource = self;
    NSTableColumn *coumnWord = [[NSTableColumn alloc]initWithIdentifier:@"word"];
    coumnWord.width = 100;
    coumnWord.title = @"单词名称";
    [self.tableViewAddAssociate addTableColumn:coumnWord];
    NSTableColumn * columnExplain = [[NSTableColumn alloc]initWithIdentifier:@"expain"];
    columnExplain.width = 171;
    columnExplain.title = @"解释";
    [self.tableViewAddAssociate addTableColumn:columnExplain];
    [self.tableViewAddContent setDocumentView:self.tableViewAddAssociate];
    [self.tableViewAddContent setHasVerticalScroller:YES];
    [self.tableViewAddContent setHasHorizontalScroller:YES];
    [self.tableViewAddAssociate reloadData];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return _aryAssociateWord.count;;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return [tableColumn.title isEqualToString:@"单词名称"] ? self.aryAssociateWord[row] : self.aryAssociateWordEx[row];
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 22;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    if (1==tableView.tag) {
        [Account shareInstance].wordIdx = row;
        [Account writeFileCacheVariablesToFile];
    }
    return 1;
}

- (IBAction)back:(id)sender {
    viewController *vc = [[viewController alloc] init];
    [self.view.window setContentViewController:vc];
}
@end
