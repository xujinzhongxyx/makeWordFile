//
//  writeWordView.m
//  makeWordFile
//
//  Created by zlw on 2017/12/22.
//  Copyright © 2017年 xujinzhong. All rights reserved.
//

#import "writeWordView.h"

//控件之间间隔高度
#define kDistanceHeight    5
#define warnMsg(var) [NSString stringWithFormat:@"[%@]-不能为空", var];

@interface writeWordView()<NSTableViewDelegate, NSTableViewDataSource>

@property(nonatomic, strong) NSMutableArray *aryAssociateWord;      //关联单词列表
@property(nonatomic, strong) NSMutableArray *aryAssociateWordEx;    //关联单词列表解释
@property(nonatomic, strong) NSMutableArray *aryMarkWords;          //陌生单词

@property (nonatomic, strong)  NSTextField    *lableWarning;   //提示信息
@property (nonatomic, strong)  NSTextField    *textPrefix;     //词缀
@property (nonatomic, strong)  NSTextField    *textName;       //单词名称
@property (nonatomic, strong)  NSTextField    *textExplain;    //解释
@property (nonatomic, strong)  NSTextField    *textSplit;      //分解
@property (nonatomic, strong)  NSTextField    *textYinbiao;    //音标
@property (nonatomic, strong)  NSTextField    *textAssoWord;   //单词-关联
@property (nonatomic, strong)  NSTextField    *textAssoExplain;//单词-解释

@property (nonatomic, strong)  NSTableView    *tableViewAddAssociate; //关联单词列表
@property (nonatomic, strong)  NSScrollView   *tableViewAddContent;

@property (nonatomic, strong)  NSTextField    *textEn;              //英文语句
@property (nonatomic, strong)  NSTextField    *textCn;              //中文语句
@property (nonatomic, strong)  NSTextField    *textMarkWordName;    //语句陌生名称
@property (nonatomic, strong)  NSTextField    *textMarkWordExplain; //语句单词解释
@property (nonatomic, strong)  NSButton       *btnAddMark;          //添加单词解释
@property (nonatomic, strong)  NSTextField    *textMark;            //单词说明

@property (nonatomic, strong)  NSButton       *btnAddSocciateWord;  //添加关联单词按钮
@property (nonatomic, strong)  NSButton       *btnAddWord;          //添加单词按钮
@property (nonatomic, strong)  NSButton       *btnDeleteWord;       //删除单词按钮
@property (nonatomic, strong)  NSButton       *btnUpdateWord;       //修改单词按钮
@property (nonatomic, strong)  NSButton       *btnSearchWord;       //查找单词按钮
@property (nonatomic, strong)  NSButton       *btnCleanWord;        //清空单词按钮

@end

@implementation writeWordView

//词缀
-(NSTextField *)textPrefix{
    if (!_textPrefix) {
        _textPrefix = [NSTextField new];
        _textPrefix.font = FONT(13.f);
        _textPrefix.placeholderString = @"词缀";
        [self addSubview:_textPrefix];
        
        [_textPrefix mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.left.offset(5);
            make.width.equalTo(self).offset(-10);
            make.height.offset(40);
        }];
    }
    
    return _textPrefix;
}

//单词名称
-(NSTextField *)textName{
    if (!_textName) {
        _textName = [NSTextField new];
        _textName.font = FONT(13.f);
        _textName.placeholderString = @"单词名称";
        [self addSubview:_textName];
        
        [_textName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textPrefix.mas_bottom).offset(10);
            make.left.offset(5);
            make.width.equalTo(_textPrefix);
            make.height.offset(25);
        }];
    }
    
    return _textName;
}

//单词解释
-(NSTextField *)textExplain{
    if (!_textExplain) {
        _textExplain = [NSTextField new];
        _textExplain.font = FONT(13.f);
        _textExplain.placeholderString = @"单词解释";
        [self addSubview:_textExplain];
        
        [_textExplain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textName.mas_bottom).offset(kDistanceHeight);
            make.left.offset(5);
            make.width.equalTo(_textName);
            make.height.equalTo(_textName);
        }];
    }
    
    return _textExplain;
}

//分解
-(NSTextField *)textSplit{
    if (!_textSplit) {
        _textSplit = [NSTextField new];
        _textSplit.font = FONT(13.f);
        _textSplit.placeholderString = @"分解";
        [self addSubview:_textSplit];
        
        [_textSplit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textExplain.mas_bottom).offset(kDistanceHeight);
            make.left.offset(5);
            make.width.equalTo(_textExplain).multipliedBy(0.4);
            make.height.equalTo(_textExplain);
        }];
    }
    
    return _textSplit;
}

//单词音标
-(NSTextField *)textYinbiao{
    if (!_textYinbiao) {
        _textYinbiao = [NSTextField new];
        _textYinbiao.font = FONT(13.f);
        _textYinbiao.placeholderString = @"单词音标";
        [self addSubview:_textYinbiao];
        
        [_textYinbiao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_textSplit);
            make.left.equalTo(_textSplit.mas_right).offset(5);
            make.right.equalTo(_textExplain);
            make.height.equalTo(_textSplit);
        }];
    }
    
    return _textYinbiao;
}

//单词-关联
-(NSTextField *)textAssoWord{
    if (!_textAssoWord) {
        _textAssoWord = [NSTextField new];
        _textAssoWord.font = FONT(13.f);
        _textAssoWord.placeholderString = @"单词-关联";
        [self addSubview:_textAssoWord];
        
        [_textAssoWord mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textSplit.mas_bottom).offset(kDistanceHeight);
            make.left.offset(5);
            make.width.equalTo(_textExplain).multipliedBy(0.3);
            make.height.equalTo(_textExplain);
        }];
    }
    
    return _textAssoWord;
}

//单词-解释
-(NSTextField *)textAssoExplain{
    if (!_textAssoExplain) {
        _textAssoExplain = [NSTextField new];
        _textAssoExplain.font = FONT(13.f);
        _textAssoExplain.placeholderString = @"单词-解释";
        [self addSubview:_textAssoExplain];

        [_textAssoExplain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textSplit.mas_bottom).offset(kDistanceHeight);
            make.left.equalTo(_textAssoWord.mas_right).offset(2);
            make.width.equalTo(_textExplain).multipliedBy(0.55);
            make.height.equalTo(_textExplain);
        }];
    }

    return _textAssoExplain;
}

//关联单词列表
- (NSScrollView *)tableViewAddContent{
    if (!_tableViewAddContent) {
        _tableViewAddContent = [[NSScrollView alloc] init];
        [self addSubview:self.tableViewAddContent];
        
        [_tableViewAddContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textAssoWord.mas_bottom).offset(kDistanceHeight);
            make.left.equalTo(_textExplain).offset(2);
            make.width.equalTo(_textExplain);
            make.height.offset(160);
        }];
    }
    return _tableViewAddContent;
}

- (NSTableView *)tableViewAddAssociate{
    if (!_tableViewAddAssociate) {
        _tableViewAddAssociate = [[NSTableView alloc]initWithFrame:self.frame];
        _tableViewAddAssociate.gridStyleMask = NSTableViewSolidVerticalGridLineMask|NSTableViewSolidHorizontalGridLineMask;
        _tableViewAddAssociate.delegate = self;
        _tableViewAddAssociate.dataSource = self;
    }
    return _tableViewAddAssociate;
}

//添加关联单词按钮
-(NSButton *)btnAddSocciateWord{
    if (!_btnAddSocciateWord) {
        _btnAddSocciateWord = [NSButton new];
        [_btnAddSocciateWord setTitle:@"+"];
        [self addSubview:_btnAddSocciateWord];
        
        [_btnAddSocciateWord mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_textExplain).offset(-4);
            make.centerY.equalTo(_textAssoExplain);
            make.width.offset(40);
            make.height.equalTo(_textAssoExplain);
        }];
    }
    
    return _btnAddSocciateWord;
}

//添加关联单词按钮事件
-(void)addSocciateWordEvent{
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

//英文语句
-(NSTextField *)textEn{
    if (!_textEn) {
        _textEn = [NSTextField new];
        _textEn.font = FONT(13.f);
        _textEn.placeholderString = @"英文语句";
        [self addSubview:_textEn];
        
        [_textEn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tableViewAddContent.mas_bottom).offset(5);
            make.left.equalTo(_textExplain);
            make.width.equalTo(_textExplain);
            make.height.offset(50);
        }];
    }
    
    return _textEn;
}

//中文语句
-(NSTextField *)textCn{
    if (!_textCn) {
        _textCn = [NSTextField new];
        _textCn.font = FONT(13.f);
        _textCn.placeholderString = @"中文语句";
        [self addSubview:_textCn];
        
        [_textCn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textEn.mas_bottom).offset(5);
            make.left.equalTo(_textExplain);
            make.width.equalTo(_textExplain);
            make.height.offset(50);
        }];
    }
    
    return _textCn;
}

//语句陌生名称
-(NSTextField *)textMarkWordName{
    if (!_textMarkWordName) {
        _textMarkWordName = [NSTextField new];
        _textMarkWordName.font = FONT(13.f);
        _textMarkWordName.placeholderString = @"语句陌生名称";
        [self addSubview:_textMarkWordName];
        
        [_textMarkWordName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textCn.mas_bottom).offset(kDistanceHeight);
            make.left.offset(5);
            make.width.equalTo(_textCn).multipliedBy(0.3);
            make.height.equalTo(_textExplain);
        }];
    }
    
    return _textMarkWordName;
}

//语句单词解释
-(NSTextField *)textMarkWordExplain{
    if (!_textMarkWordExplain) {
        _textMarkWordExplain = [NSTextField new];
        _textMarkWordExplain.font = FONT(13.f);
        _textMarkWordExplain.placeholderString = @"语句单词解释";
        [self addSubview:_textMarkWordExplain];
        
        [_textMarkWordExplain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textCn.mas_bottom).offset(kDistanceHeight);
            make.left.equalTo(_textMarkWordName.mas_right).offset(2);
            make.width.equalTo(_textCn).multipliedBy(0.55);
            make.height.equalTo(_textExplain);
        }];
    }
    
    return _textMarkWordExplain;
}

//添加单词解释
-(NSButton *)btnAddMark{
    if (!_btnAddMark) {
        _btnAddMark = [NSButton new];
        [_btnAddMark setTitle:@"+"];
        [self addSubview:_btnAddMark];
        
        [_btnAddMark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_textCn).offset(-4);
            make.centerY.equalTo(_textMarkWordExplain);
            make.width.offset(40);
            make.height.equalTo(_textMarkWordExplain);
        }];
    }
    
    return _btnAddMark;
}

//添加关联单词按钮事件
-(void)addMarkEvent{
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

//单词说明
-(NSTextField *)textMark{
    if (!_textMark) {
        _textMark = [NSTextField new];
        _textMark.font = FONT(13.f);
        _textMark.placeholderString = @"单词说明";
        [self addSubview:_textMark];
        
        [_textMark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textMarkWordName.mas_bottom).offset(5);
            make.left.equalTo(_textExplain);
            make.width.equalTo(_textExplain);
            make.height.offset(60);
        }];
    }
    
    return _textMark;
}

//提示信息
-(NSTextField *)lableWarning{
    if (!_lableWarning) {
        _lableWarning = [NSTextField new];
        _lableWarning.font = FONT(13.f);
        _lableWarning.alignment = NSTextAlignmentCenter;
        _lableWarning.textColor = [NSColor redColor];
        _lableWarning.backgroundColor = [NSColor clearColor];
        _lableWarning.placeholderString = @"提示信息";
        [_lableWarning setBordered:NO];
        [_lableWarning setEditable:NO];
        [_lableWarning setSelectable:NO];
        [self addSubview:_lableWarning];
        
        [_lableWarning mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textMark.mas_bottom).offset(8);
            make.left.equalTo(_textMark);
            make.width.equalTo(_textMark);
            make.height.offset(22);
        }];
    }
    
    return _lableWarning;
}

//添加单词按钮
-(NSButton *)btnAddWord{
    if (!_btnAddWord) {
        _btnAddWord = [NSButton new];
        [_btnAddWord setWantsLayer:YES];
        _btnAddWord.layer.backgroundColor = [NSColor redColor].CGColor;
        [_btnAddWord setTitle:@"✔ 添加"];
        [self addSubview:_btnAddWord];
        
        [_btnAddWord mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.btnDeleteWord.mas_left).offset(-35);
            make.centerY.equalTo(self.btnDeleteWord);
            make.width.offset(60);
            make.height.offset(25);
        }];
    }
    
    return _btnAddWord;
}

//添加单词按钮事件
-(void)addAddWordEvent{
    if ([self matchWord]) {
        [self makeJsonWords];
        NSString *specifiedWord = self.textName.stringValue;
        [self clearAllData];
        self.lableWarning.stringValue = [NSString stringWithFormat:@"添加【%@】成功。", specifiedWord];
    }
}

//删除单词按钮
-(NSButton *)btnDeleteWord{
    if (!_btnDeleteWord) {
        _btnDeleteWord = [NSButton new];
        [_btnDeleteWord setWantsLayer:YES];
        _btnDeleteWord.layer.backgroundColor = [NSColor redColor].CGColor;
        [_btnDeleteWord setTitle:@"✘ 删除"];
        [self addSubview:_btnDeleteWord];
        
        [_btnDeleteWord mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lableWarning.mas_bottom).offset(8);
            make.right.equalTo(self.mas_centerX).offset(-20);
            make.width.offset(60);
            make.height.offset(25);
        }];
    }
    
    return _btnDeleteWord;
}

//删除单词按钮事件
-(void)addDeleteWordEvent{
    if (self.textName.stringValue.length == 0) {
        self.lableWarning.stringValue = [NSString stringWithFormat:@"删除的单词不能为空!"];
        [self.textName becomeFirstResponder];
        return;
    }
    
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
    
    [aryMuWords removeObjectAtIndex:i];
    NSString *jsonData = aryMuWords.mj_JSONString;
    BOOL isSuce = [Helper setJsonDataJsonname:kFineName str:jsonData];
    if (isSuce) {
        self.lableWarning.stringValue = @"删除单词成功了";
    }
    
    [self clearAllData];
    self.lableWarning.stringValue = [NSString stringWithFormat:@"删除【word】成功。"];
}


//搜索单词按钮
-(NSButton *)btnSearchWord{
    if (!_btnSearchWord) {
        _btnSearchWord = [NSButton new];
        [_btnSearchWord setWantsLayer:YES];
        _btnSearchWord.layer.backgroundColor = [NSColor redColor].CGColor;
        [_btnSearchWord setTitle:@"☯ 搜索"];
        [self addSubview:_btnSearchWord];
        
        [_btnSearchWord mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lableWarning.mas_bottom).offset(8);
            make.left.equalTo(self.mas_centerX).offset(20);
            make.width.offset(60);
            make.height.offset(25);
        }];
    }
    
    return _btnSearchWord;
}

//删除单词按钮事件
-(void)addSearchWordEvent{
    if (self.textName.stringValue.length == 0) {
        self.lableWarning.stringValue = [NSString stringWithFormat:@"没有需要搜索的单词。"];
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
        //在界面上显示单词信息
        [self displayWordOnInterface:aryMuWords[i]];
        //从文件中删除单词
        [aryMuWords removeObjectAtIndex:i];
        NSString *jsonData = aryMuWords.mj_JSONString;
        BOOL isSuce = [Helper setJsonDataJsonname:kFineName str:jsonData];
        if (isSuce) {
            self.lableWarning.stringValue = [NSString stringWithFormat:@"搜索到【word】单词！"];
        }
    }
}

//清空单词按钮
-(NSButton *)btnCleanWord{
    if (!_btnCleanWord) {
        _btnCleanWord = [NSButton new];
        [_btnCleanWord setWantsLayer:YES];
        _btnCleanWord.layer.backgroundColor = [NSColor redColor].CGColor;
        [_btnCleanWord setTitle:@"▩ 清空"];
        [self addSubview:_btnCleanWord];
        
        [_btnCleanWord mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btnSearchWord.mas_right).offset(35);
            make.centerY.equalTo(self.btnSearchWord);
            make.width.offset(60);
            make.height.offset(25);
        }];
    }
    
    return _btnCleanWord;
}

//清空单词按钮事件
-(void)addCleanWordEvent{
    [self clearAllData];
}

-(void)loadSubView
{
    self.aryAssociateWord = [NSMutableArray array];
    self.aryAssociateWordEx = [NSMutableArray array];
    self.aryMarkWords = [NSMutableArray array];
    self.textPrefix.placeholderString = @"词缀";
    self.textName.placeholderString = @"单词名称";
    self.textExplain.placeholderString = @"单词解释";
    self.textSplit.placeholderString = @"分解";
    self.textYinbiao.placeholderString = @"单词音标";
    self.textAssoWord.placeholderString = @"单词-关联";
    self.textAssoExplain.placeholderString = @"单词-解释";
    //关联单词
    self.btnAddSocciateWord.target = self;
    [self.btnAddSocciateWord setAction:@selector(addSocciateWordEvent)];
    [self initTableView];
    //单词例句
    self.textEn.placeholderString = @"英文语句";
    self.textCn.placeholderString = @"中文语句";
    
    self.textMarkWordName.placeholderString = @"语句陌生名称";
    self.textMarkWordExplain.placeholderString = @"语句单词解释";
    
    //添加例句单词解释说明
    self.btnAddMark.target = self;
    [self.btnAddMark setAction:@selector(addMarkEvent)];
    
    self.textMark.placeholderString = @"单词说明";
    //提示信息
    [self.lableWarning setWantsLayer:YES];
    self.lableWarning.placeholderString = @"提示信息";
    //添加，删除，搜索，清空按钮
    //添加删除按钮
    self.btnAddWord.target = self;
    [self.btnAddWord setAction:@selector(addAddWordEvent)];
    //单词删除按钮
    self.btnDeleteWord.target = self;
    [self.btnDeleteWord setAction:@selector(addDeleteWordEvent)];
    //单词搜索按钮
    self.btnSearchWord.target = self;
    [self.btnSearchWord setAction:@selector(addSearchWordEvent)];
    //清空删除按钮
    self.btnCleanWord.target = self;
    [self.btnCleanWord setAction:@selector(addCleanWordEvent)];
}

//初始化关联单词列表
-(void)initTableView{
    [self addSubview:self.tableViewAddAssociate];
    self.tableViewAddAssociate.delegate = self;
    self.tableViewAddAssociate.dataSource = self;
    NSTableColumn *coumnWord = [[NSTableColumn alloc]initWithIdentifier:@"word"];
    coumnWord.title = @"单词名称";
    [self.tableViewAddAssociate addTableColumn:coumnWord];
    NSTableColumn * columnExplain = [[NSTableColumn alloc]initWithIdentifier:@"expain"];
    columnExplain.width = 300;
    columnExplain.title = @"解释";
    [self.tableViewAddAssociate addTableColumn:columnExplain];
    [self.tableViewAddContent setDocumentView:self.tableViewAddAssociate];
    [self.tableViewAddContent setHasVerticalScroller:YES];
    [self.tableViewAddContent setHasHorizontalScroller:YES];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return _aryAssociateWord.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return [tableColumn.title isEqualToString:@"单词名称"] ? _aryAssociateWord[row] : _aryAssociateWordEx[row];
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 20;
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

@end

