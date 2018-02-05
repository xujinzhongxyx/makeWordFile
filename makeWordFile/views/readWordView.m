//
//  readWordView.m
//  makeWordFile
//
//  Created by zlw on 2017/12/22.
//  Copyright © 2017年 xujinzhong. All rights reserved.
//

#import "readWordView.h"

//控件之间间隔高度
#define kDistanceHeight    8

#define kmultipliedOffset  0.95


@interface readWordView()<NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, strong)   NSTextField     *textPrefix;       //词缀
@property (nonatomic, strong)   NSTextField     *textWordName;     //单词名称
@property (nonatomic, strong)   NSTextField     *textWordExplain;  //单词解释
@property (nonatomic, strong)   NSTextField     *textWordSplit;    //单词分解
@property (nonatomic, strong)   NSTextField     *textWordYinbiao;  //单词音标
@property (nonatomic, strong)   NSView          *wordView;         //单词显示视图

@property (nonatomic, strong)   NSMutableArray  *aryAssociateWord;  //关联单词列表
@property (nonatomic, strong)   NSMutableArray  *aryAssociateWordEx;//关联单词列表解释

@property (nonatomic, strong)   NSTableView     *tableViewAddAssociate; //关联单词列表
@property (nonatomic, strong)   NSScrollView    *tableViewAddContent;

@property (nonatomic, strong)   NSTextField     *textEn;    //英文语句
@property (nonatomic, strong)   NSTextField     *textCn;    //中文语句
@property (nonatomic, strong)   NSView          *sentenceView;  //英文语句视图

@property (nonatomic, strong)   NSTextField     *textMark;  //单词说明

@property (nonatomic, strong)   NSButton        *btnPreWord;    //上一个单词按钮
@property (nonatomic, strong)   NSButton        *btnNextWord;   //下一个单词按钮

@end

@implementation readWordView
{
    NSInteger _index;
}

-(void)loadSubView
{
    //关联单词列表
    self.aryAssociateWord = [NSMutableArray array];
    //关联单词列表解释
    self.aryAssociateWordEx = [NSMutableArray array];
    
    _index = 0;
    
    //词缀***********************************************************
    _textPrefix = [NSTextField new];
    _textPrefix.font = FONT(15.f);
    _textPrefix.alignment = NSTextAlignmentCenter;
    _textPrefix.textColor = [NSColor redColor];
    _textPrefix.backgroundColor = [NSColor clearColor];
    _textPrefix.placeholderString = @"词缀";
    [_textPrefix setBordered:NO];
    [_textPrefix setEditable:NO];
    [_textPrefix setSelectable:YES];
    [self addSubview:_textPrefix];
    
    [_textPrefix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self);
        make.width.equalTo(self).multipliedBy(kmultipliedOffset);
        make.height.offset(40);
    }];
    
    //单词显示视图***********************************************************
    _wordView = [NSView new];
    [_wordView setWantsLayer:YES];
    _wordView.layer.backgroundColor = [Helper colorFromHexRGB:@"FFFFCC"].CGColor;
    _wordView.layer.cornerRadius = 5.f;
    _wordView.layer.masksToBounds = YES;
    _wordView.layer.borderColor = [Helper colorFromHexRGB:@"BFEFFF"].CGColor;
    _wordView.layer.borderWidth = 2.f;
    [self addSubview:_wordView];
    
    [_wordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textPrefix.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.width.equalTo(self).multipliedBy(kmultipliedOffset);
        make.height.offset(80);
    }];
    
    //单词名称--------
    _textWordName = [NSTextField new];
    _textWordName.font = FONT(25.f);
    _textWordName.alignment = NSTextAlignmentCenter;
    _textWordName.backgroundColor = [NSColor clearColor];
    _textWordName.textColor = [NSColor blackColor];
    _textWordName.placeholderString = @"单词名称";
    [_textWordName setEditable:NO];
    [_textWordName setBordered:NO];
    [_textWordName setSelectable:YES];
    [_wordView addSubview:_textWordName];
    
    [_textWordName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wordView).offset(7);
        make.bottom.equalTo(_wordView.mas_centerY).offset(-5);
        make.left.equalTo(_wordView).offset(5);
        make.width.equalTo(_wordView).multipliedBy(0.5);
    }];
    
    //单词分解--------
    _textWordSplit= [NSTextField new];
    _textWordSplit.font = FONT(18.f);
    _textWordSplit.alignment = NSTextAlignmentLeft;
    _textWordSplit.backgroundColor = [NSColor clearColor];
    _textWordSplit.textColor = [NSColor grayColor];
    _textWordSplit.placeholderString = @"单词分解";
    [_textWordSplit setEditable:NO];
    [_textWordSplit setBordered:NO];
    [_wordView addSubview:_textWordSplit];
    
    [_textWordSplit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textWordName);
        make.left.equalTo(_textWordName.mas_right);
        make.right.equalTo(_wordView);
        make.height.equalTo(_textWordName).multipliedBy(0.85);
    }];
    
    //单词解释--------
    _textWordExplain= [NSTextField new];
    _textWordExplain.font = FONT(15.f);
    _textWordExplain.alignment = NSTextAlignmentCenter;
    _textWordExplain.backgroundColor = [NSColor clearColor];
    _textWordExplain.textColor = [NSColor grayColor];
    _textWordExplain.lineBreakMode = NSLineBreakByWordWrapping;
    _textWordExplain.placeholderString = @"单词解释";
    [_textWordExplain setEnabled:NO];
    [_textWordExplain setBordered:NO];
    [_wordView addSubview:_textWordExplain];
    
    [_textWordExplain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wordView.mas_centerY).offset(5);
        make.bottom.equalTo(_wordView).offset(-5);
        make.left.equalTo(_wordView).offset(5);
        make.width.equalTo(_wordView).multipliedBy(0.5);
    }];
    
    //单词音标***********************************************************
    _textWordYinbiao= [NSTextField new];
    _textWordYinbiao.font = FONT(12.f);
    _textWordYinbiao.alignment = NSTextAlignmentLeft;
    _textWordYinbiao.backgroundColor = [NSColor clearColor];
    _textWordYinbiao.textColor = [NSColor grayColor];
    _textWordYinbiao.lineBreakMode = NSLineBreakByWordWrapping;
    _textWordYinbiao.placeholderString = @"单词音标";
    [_textWordYinbiao setEnabled:NO];
    [_textWordYinbiao setBordered:NO];
    [_wordView addSubview:_textWordYinbiao];
    
    [_textWordYinbiao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textWordExplain);
        make.left.equalTo(_textWordExplain.mas_right);
        make.right.equalTo(_wordView.mas_right);
        make.height.equalTo(_textWordExplain).multipliedBy(0.8);
    }];
    
    //关联单词列表***********************************************************
    _tableViewAddContent = [[NSScrollView alloc] init];
    [self addSubview:self.tableViewAddContent];
    
    [_tableViewAddContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wordView.mas_bottom).offset(20);
        make.left.equalTo(_wordView).offset(2);
        make.width.equalTo(_wordView);
        make.height.offset(150);
    }];
    
    _tableViewAddAssociate = [[NSTableView alloc]initWithFrame:self.frame];
    _tableViewAddAssociate.gridStyleMask = NSTableViewSolidVerticalGridLineMask|NSTableViewSolidHorizontalGridLineMask;
    [_tableViewAddAssociate setEnabled:NO];
    _tableViewAddAssociate.delegate = self;
    _tableViewAddAssociate.dataSource = self;
    
    [self initTableView];
    
    //英文语句------------------------------------------
    _textEn = [NSTextField new];
    _textEn.font = FONT(12.f);
    _textEn.placeholderString = @"英文语句";
    _textEn.textColor = [NSColor grayColor];
    _textEn.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_textEn];
    
    [_textEn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableViewAddContent.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.width.equalTo(self).multipliedBy(kmultipliedOffset);
        make.height.offset(50);
    }];
    
    //中文语句-----------------------------------------
    _textCn = [NSTextField new];
    _textCn.font = FONT(12.f);
    _textCn.placeholderString = @"中文语句";
    _textCn.textColor = [NSColor grayColor];
    _textCn.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_textCn];
    
    [_textCn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textEn.mas_bottom).offset(2);
        make.centerX.equalTo(self);
        make.width.equalTo(self).multipliedBy(kmultipliedOffset);
        make.height.offset(50);
    }];
    
    //单词说明***********************************************************
    _textMark = [NSTextField new];
    _textMark.font = FONT(12.f);
    _textMark.placeholderString = @"单词说明";
    _textMark.textColor = [NSColor grayColor];
    _textMark.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_textMark];
    
    [_textMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textCn.mas_bottom).offset(2);
        make.centerX.equalTo(self);
        make.width.equalTo(self).multipliedBy(kmultipliedOffset);
        make.height.offset(50);
    }];
    
    //上一个单词按钮***********************************************************
    CGFloat btnDidatanc = 20.f;
    _btnPreWord = [NSButton new];
    _btnPreWord.font = FONT(30.f);
    _btnPreWord.title = @"☜";
    _btnPreWord.target = self;
    [_btnPreWord setAction:@selector(clickPreEvent)];
    [self addSubview:_btnPreWord];
    
    [_btnPreWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textMark.mas_bottom).offset(btnDidatanc);
        make.right.equalTo(self.mas_centerX).offset(-70);
        make.width.offset(60);
        make.height.offset(25);
    }];
    
    //下一个单词按钮***********************************************************
    _btnNextWord = [NSButton new];
    _btnNextWord.font = FONT(30.f);
    _btnNextWord.title = @"☞";
    _btnNextWord.target = self;
    [_btnNextWord setAction:@selector(clickNextEvent)];
    [self addSubview:_btnNextWord];
    
    [_btnNextWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textMark.mas_bottom).offset(btnDidatanc);
        make.left.equalTo(self.mas_centerX).offset(70);
        make.width.offset(60);
        make.height.offset(25);
    }];
    
    NSArray *aryAllWords = [self readFromFile];
    if (aryAllWords.count>0) {
        if (--_index<0) {
            _index = 0;
        }
        NSDictionary *dicSpecified = aryAllWords[0];
        [self displaySpecifiedWord:dicSpecified];
    }
}

//上一个单词按钮事件
-(void)clickPreEvent
{
    NSArray *aryAllWords = [self readFromFile];
    if (aryAllWords.count>0) {
        if (--_index<0) {
            _index = 0;
        }
        NSDictionary *dicSpecified = aryAllWords[_index];
        [self displaySpecifiedWord:dicSpecified];
    }
}

//下一个单词按钮事件
-(void)clickNextEvent
{
    NSArray *aryAllWords = [self readFromFile];
    if (aryAllWords.count>0) {
        if (++_index>aryAllWords.count-1) {
            _index = aryAllWords.count-1;
        }
        NSDictionary *dicSpecified = aryAllWords[_index];
        [self displaySpecifiedWord:dicSpecified];
    }
}

//加载指定的单词
-(void)pointSpecifiedWord:(NSInteger)idx{
    NSArray *aryAllWords = [self readFromFile];
    if (aryAllWords.count>0) {
        NSDictionary *dicSpecified = aryAllWords[idx];
        [self displaySpecifiedWord:dicSpecified];
    }
}

//在界面中显示指定的单词
-(void)displaySpecifiedWord:(NSDictionary *)data
{
    _textPrefix.stringValue = data[@"prefix"];//词缀
    _textWordName.stringValue = data[@"name"];//单词名称
    _textWordExplain.stringValue = data[@"explain"];//单词解释
    _textWordSplit.stringValue = data[@"split"];//单词分解
    _textWordYinbiao.stringValue = data[@"yinbiao"];//单词音标
    //单词列表-------------------------------------------
    _aryAssociateWord = data[@"associateWord"];  //关联单词列表
    _aryAssociateWordEx = data[@"associateEx"];//关联单词列表解释
    [_tableViewAddAssociate reloadData];
    
    _textEn.stringValue = data[@"example"][@"en"];//英文语句
    _textCn.stringValue = data[@"example"][@"cn"];//中文语句
    _textMark.stringValue = data[@"example"][@"mark"];//单词说明
}

/** 从文件中获取数据 */
-(NSArray *)readFromFile{
    NSString *allWordContent = [Helper getJsonDataJsonname:kFineName];
    NSArray *aryWords = allWordContent.mj_JSONObject;
    return aryWords;
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

@end
