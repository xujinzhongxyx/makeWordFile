//
//  viewController.m
//  makeWordFile
//
//  Created by zlw on 2017/12/20.
//  Copyright © 2017年 xujinzhong. All rights reserved.
//

#import "viewController.h"
#import "newWordViewController.h"

@interface viewController ()<NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property(nonatomic, strong)    NSArray        *aryAllWords;           //所有单词
@property(nonatomic, strong)    NSMutableArray *aryAssociateWord;      //关联单词列表
@property(nonatomic, strong)    NSMutableArray *aryAssociateWordEx;    //关联单词列表解释
@property(nonatomic, strong)    NSMutableArray *aryMarkWords;          //陌生单词
@property(nonatomic, assign)    NSInteger      readWordIdx;            //当前选中的阅读单词的索引

/** 所有单词列表 */
@property (strong) IBOutlet     NSScrollView    *tableViewReadContent;
@property (strong) IBOutlet     NSTableView     *tableViewRead;

@property (strong) IBOutlet     NSTextField     *textPrefix;        //词缀
@property (strong) IBOutlet     NSTextField     *textWordName;      //单词名称
@property (strong) IBOutlet     NSTextField     *textWordExplain;   //单词解释
@property (strong) IBOutlet     NSTextField     *textWordSplit;     //单词分解
@property (strong) IBOutlet     NSTextField     *textWordYinbiao;   //单词音标
@property (strong) IBOutlet     NSScrollView    *tabAssociateContent;        //tableView加载
@property (strong) IBOutlet     NSTableView     *tabAssociate;      //关联单词列表
@property (strong) IBOutlet     NSTextField     *textMark;          //句子

@property (strong) IBOutlet     NSTextField     *labWordAssoc;
@property (strong) IBOutlet     NSBox           *assocBox;

- (IBAction)addWordClickEvent:(id)sender;
- (IBAction)preWordClickEvent:(id)sender;
- (IBAction)nextWordClickEvent:(id)sender;

@end

@implementation viewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setWantsLayer:YES];
    self.view.layer.backgroundColor = [Helper colorFromHexRGB:@"EBEBEB"].CGColor;

    [NSApp setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow)name:NSWindowWillCloseNotification object:nil];
    
    _aryAssociateWord = [NSMutableArray array];
    _aryAssociateWordEx = [NSMutableArray array];
    _aryMarkWords = [NSMutableArray array];
    
    [self initReadTableView];
    [self initAssociateTableView];
    
    /** 更新选中的单词 */
    Account *account = [Account shareInstance];
    account.aryWords = [self readDataFromFile];
    [Account writeFileCacheVariablesToFile];
    _readWordIdx = account.wordIdx;
    [_tableViewRead selectRowIndexes:[NSIndexSet indexSetWithIndex:_readWordIdx] byExtendingSelection:NO];
    
    /** 更新当前显示的单词 */
    [self updateAssociateWord:_readWordIdx];
}

- (void)closeWindow
{
    [NSApp terminate:self];
}

/** 从文件中获取数据 */
-(NSArray *)readDataFromFile{
    NSString *allWordContent = [Helper getJsonDataJsonname:kFineName];
    NSArray *aryWords = allWordContent.mj_JSONObject;
    return aryWords;
}

//更新关联单词列表
-(void)updateAssociateWord:(NSInteger)index{
    
    if (index>_aryAllWords.count) {
        return;
    }
    
    NSDictionary *dicWord = _aryAllWords[index];
    _textPrefix.stringValue = dicWord[@"prefix"];//词缀
    _textWordName.stringValue = dicWord[@"name"];//单词名称
    _textWordExplain.stringValue = dicWord[@"explain"];//单词解释
    _textWordSplit.stringValue = dicWord[@"split"];//单词分解
    _textWordYinbiao.stringValue = dicWord[@"yinbiao"];//单词音标
    
    NSString *strMark = [NSString stringWithFormat:@"%@\n%@\n%@",
                         dicWord[@"example"][@"en"],   //英文语句
                         dicWord[@"example"][@"cn"],   //中文语句
                         dicWord[@"example"][@"mark"]  //单词说明
                         ];
    _textMark.stringValue = strMark;
    _aryAssociateWord = dicWord[@"associateWord"];  //关联单词列表
    _aryAssociateWordEx = dicWord[@"associateEx"];//关联单词列表解释
    [_tabAssociate reloadData];
}

//初始化单词列表
-(void)initReadTableView{
    self.aryAllWords = [self readDataFromFile];
    
    [self.view addSubview:self.tableViewReadContent];

    self.tableViewRead = [[NSTableView alloc]initWithFrame:self.view.frame];
    self.tableViewRead.gridStyleMask = NSTableViewSolidVerticalGridLineMask|NSTableViewSolidHorizontalGridLineMask;
    self.tableViewRead.tag = 1;
    self.tableViewRead.enabled = YES;
    [self.view addSubview:self.tableViewRead];
    self.tableViewRead.delegate = self;
    self.tableViewRead.dataSource = self;
    NSTableColumn *coumnWord = [[NSTableColumn alloc]initWithIdentifier:@"word"];
    coumnWord.width = 100;
    coumnWord.title = @"单词名称";
    [self.tableViewRead addTableColumn:coumnWord];
    NSTableColumn * columnExplain = [[NSTableColumn alloc]initWithIdentifier:@"expain"];
    columnExplain.width = 312;
    columnExplain.title = @"解释";
    [self.tableViewRead addTableColumn:columnExplain];
    [self.tableViewReadContent setDocumentView:self.tableViewRead];
    [self.tableViewReadContent setHasVerticalScroller:YES];
    [self.tableViewReadContent setHasHorizontalScroller:YES];
    [self.tableViewRead reloadData];
}

//初始化关联单词列表
-(void)initAssociateTableView{
    self.aryAllWords = [self readDataFromFile];
    self.tabAssociateContent = [[NSScrollView alloc] init];
    [self.view addSubview:self.tabAssociateContent];
    
    [self.tabAssociateContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labWordAssoc.mas_bottom).offset(2);
        make.left.equalTo(_labWordAssoc).offset(2);
        make.bottom.equalTo(_assocBox.mas_top).offset(-10);
        make.width.offset(398);
    }];
    
    self.tabAssociate = [[NSTableView alloc]initWithFrame:self.view.frame];
    self.tabAssociate.gridStyleMask = NSTableViewSolidVerticalGridLineMask|NSTableViewSolidHorizontalGridLineMask;
    self.tabAssociate.tag = 2;
    [self.view addSubview:self.tabAssociate];
    self.tabAssociate.delegate = self;
    self.tabAssociate.dataSource = self;
    NSTableColumn *coumnWord = [[NSTableColumn alloc]initWithIdentifier:@"word"];
    coumnWord.width = 100;
    coumnWord.title = @"单词名称";
    [self.tabAssociate addTableColumn:coumnWord];
    NSTableColumn * columnExplain = [[NSTableColumn alloc]initWithIdentifier:@"expain"];
    columnExplain.width = 171;
    columnExplain.title = @"解释";
    [self.tabAssociate addTableColumn:columnExplain];
    [self.tabAssociateContent setDocumentView:self.tabAssociate];
    [self.tabAssociateContent setHasVerticalScroller:YES];
    [self.tabAssociateContent setHasHorizontalScroller:YES];
    [self.tabAssociate reloadData];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    NSInteger rowCount = 0;
    if (1==tableView.tag) {
        rowCount = _aryAllWords.count;
    }
    else if (2==tableView.tag) {
        rowCount = _aryAssociateWord.count;
    }
    return rowCount;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *valueOfRow;
    if (1==tableView.tag) {
        valueOfRow = [tableColumn.title isEqualToString:@"单词名称"] ? _aryAllWords[row][@"name"] : _aryAllWords[row][@"explain"];
    }
    else if (2==tableView.tag){
        valueOfRow = [tableColumn.title isEqualToString:@"单词名称"] ? _aryAssociateWord[row] : _aryAssociateWordEx[row];
    }
    return valueOfRow;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 22;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    if (1 == tableView.tag) {
        /** 更新选中的单词 */
        Account *account = [Account shareInstance];
        account.wordIdx = row;
        [Account writeFileCacheVariablesToFile];
        [self updateAssociateWord:account.wordIdx];
    }
    return YES;
}

//添加新单词
- (IBAction)addWordClickEvent:(id)sender {
    newWordViewController *newVC = [[newWordViewController alloc] init];
    [self.view.window setContentViewController:newVC];
}

//显示上一个单词
- (IBAction)preWordClickEvent:(id)sender {
    if (--_readWordIdx<0) {
        _readWordIdx = 0;
    }
    [self updateAssociateWord:_readWordIdx];
    //选择所有单词列表的指定行
    [_tableViewRead selectRowIndexes:[NSIndexSet indexSetWithIndex:_readWordIdx] byExtendingSelection:NO];
    [Account shareInstance].wordIdx = _readWordIdx;
    [Account writeFileCacheVariablesToFile];
}

//显示下一个单词
- (IBAction)nextWordClickEvent:(id)sender {
    NSInteger wordCount = [Account shareInstance].aryWords.count;
    if (++_readWordIdx>wordCount-1) {
        _readWordIdx = wordCount-1;
    }
    [self updateAssociateWord:_readWordIdx];
    [_tableViewRead selectRowIndexes:[NSIndexSet indexSetWithIndex:_readWordIdx] byExtendingSelection:NO];
    [Account shareInstance].wordIdx = _readWordIdx;
    [Account writeFileCacheVariablesToFile];
}

@end

