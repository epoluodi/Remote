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

#define SplitStr @"!~!" // 命令分隔符
#define CRCL @"\x0D\x0A"//结束符

const int COMMUNICATION_PORT = 21414;// 搜搜 端口
const int RECIVE_PORT = 21415;// 接收 端口
const int SEND_STATU_PORT = 21416;// 发送 端口
const int CommandPort = 18001;// 通信端口

typedef enum :int {
    EloadContentType=0,
    EloadMediaByType,
    
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
    
    BOOL Istimeout;
    
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


//获取媒体类别
-(BOOL)getContentType:(NSString *)ip;
@end
