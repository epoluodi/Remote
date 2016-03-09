//
//  DeviceNet.h
//  Remote
//
//  Created by 程嘉雯 on 16/1/29.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "GCDAsyncSocket.h"

#define SEARCH_MSG @"HELLO"//搜索设备字符
#define LINK_MSG @"LINK"//连接设备字符
#define LINK_SUCCESS @"SUCCESS"//连接设备字符
#define MulticastAddr @"255.255.255.255"//广播地址

#define loadContentType @"loadContentType" //读取所有类别
#define loadMediaByType @"loadMediaByType" //读取媒体信息 参数 :ContentType
#define loadAllMedia @"loadAllMedia" //加载所有媒体信息按类型分组 没有用
#define loadMediaByParentcode @"loadMediaByParentcode" // 没有用
#define loadSysDir @"loadSysDir" // 加载服务器上文件目录 扫描文件
#define scanfDir @"scanfDir" // 把所有扫描的文件会编排一个id
#define delMedia @"delMedia" //
#define convertType @"convertType" //
#define addToTask @"addToTask" //
#define loadAllTask @"loadAllTask" //
#define delTask @"delTask" //
#define getAllItemByTask @"getAllItemByTask" //
#define delTaskItem @"delTaskItem" //
#define addTask @"addTask" //
#define enOrDisableTask @"enOrDisableTask" //
#define editTask @"editTask" //
#define replaceDB @"replaceDB" //
#define sendmail @"sendmail" //
#define systemrecover @"systemrecover" //
#define getshutdown @"getshutdown" //
#define setshutdown @"setshutdown" //

#define playpro @"playpro" //
#define playnext @"playnext" //
#define skiptime @"skiptime" //
#define playOrPause @"playOrPause" //
#define playMedia @"playMedia" //
#define playorder @"playorder" //
#define playMode @"playMode" //
#define playPublicMedia @"playPublicMedia" //
#define dowmVolume @"dowmVolume" //降低音量
#define upVolume @"upVolume" //提高音量
#define OnOffTime @"setOnOffTime"


#define SplitStr @"!~!" // 命令分隔符
#define CRCL @"\x0D\x0A"//结束符

const int COMMUNICATION_PORT = 21414;// 搜搜 端口
const int RECIVE_PORT = 21415;// 接收 端口
const int SEND_STATU_PORT = 21416;// 发送 端口
const int CommandPort = 18001;// 通信端口

typedef enum :int {
    EloadContentType=0,
    EloadMediaByType,
    EloadAllTask,
    EaddTask,
    EdelTask,
    EEditTask,
    EDelMedia,
    EConvertType,
    ELoadSysDir,
    EScanDir,
    EReplaceDB,
    EGetAllItemByTask,
    EDelTaskItem,
    EPlayMode,
    EPlayOrder,
    EPlayOrStop,
    EPlaypro,
    EPlaynext,
    EPlayMedia,
    ESkipTime,
    EPublicMedia,
    EAddtoTask,
    EdownVolume,
    EupVolume,
    EOnOffTime,
    EGetShutTime,
    
} CommandType;



@protocol FinishCommanddelegate

-(void)CommandTimeout;
-(void)CommandFinish:(CommandType) commandtype json:(NSDictionary *)json;

@end


@interface DeviceNet : NSObject<GCDAsyncSocketDelegate>
{
    GCDAsyncUdpSocket *udpsocketsend;
    GCDAsyncUdpSocket *udpsocketrecve;
    
    GCDAsyncSocket *tcpsocket;

    id<GCDAsyncUdpSocketDelegate> udpviewdelegate;//搜索委托
    
    NSCondition *condtion;
    
    NSString *_arg;
    
    dispatch_queue_t commandqueue;
    CommandType _commandtype;
}


//命令执行委托
@property(weak,nonatomic) NSObject<FinishCommanddelegate> *Commanddelegate;

//初始化UDP
-(void)initdelegate:(id<GCDAsyncUdpSocketDelegate>) delegate;


//搜索设备
-(BOOL)SearchDevice;
-(void)stopSearchDevice;
-(BOOL)startListenserver;
-(void)stoptListenserver;
//获取媒体类别
-(BOOL)getContentType:(NSString *)ip;

//获得一个类型媒体的明细
-(BOOL)getMediaByType:(NSString *)ip arg:(NSString *)arg;

//设置音量 0 提升 1 下降
-(BOOL)SetVolume:(NSString *)ip flag:(int)flag;

//获取所有任务
-(BOOL)getAllTask:(NSString *)ip;
//添加一个任务
-(BOOL)AddTask:(NSString *)ip arg:(NSString *)arg;
//删除一个任务
-(BOOL)DelTask:(NSString *)ip arg:(NSString *)arg;
//修改一个任务
-(BOOL)EditTask:(NSString *)ip arg:(NSString *)arg;

//删除一组媒体
-(BOOL)DelMedia:(NSString *)ip arg:(NSString *)arg;
//转移一组媒体
-(BOOL)ConvertType:(NSString *)ip arg:(NSString *)arg;


//获得系统目录
-(BOOL)getAllSysDir:(NSString *)ip arg:(NSString *)arg;
//扫描系统目录
-(BOOL)ScanSysDir:(NSString *)ip arg:(NSString *)arg;

//扫描系统目录配置
-(BOOL)ReplaceDB:(NSString *)ip;

//获取任务信息中详细信息
-(BOOL)GetTaskDetailInfo:(NSString *)ip arg:(NSString *)arg;
//删除任务中一个条目
-(BOOL)DelItemDetailInfo:(NSString *)ip arg:(NSString *)arg;

//添加任务
-(BOOL)AddTaskwithMedia:(NSString *)ip arg:(NSString *)arg;

//模式
-(BOOL)setPlayMode:(NSString *)ip;

//播放模式
-(BOOL)setPlayOrder:(NSString *)ip;

//播放和停止
-(BOOL)setPlayOrStop:(NSString *)ip;

//前一首
-(BOOL)setPlaypro:(NSString *)ip;

//下一首
-(BOOL)setPlaynext:(NSString *)ip;

//播放
-(BOOL)setPlayMedia:(NSString *)ip arg:(NSString *)arg;

//拖动
-(BOOL)setSkipTime:(NSString *)ip arg:(NSString *)arg;

//设置关机时间
-(BOOL)setOnOffTime:(NSString *)ip arg:(NSString *)arg;

//得到开机时间信息
-(BOOL)getShutTimeinfo:(NSString *)ip;


//开始任务
-(BOOL)setPublicMedia:(NSString *)ip;


@end
