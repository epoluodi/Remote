//
//  DeviceNet.m
//  Remote
//
//  Created by 程嘉雯 on 16/1/29.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "DeviceNet.h"

@implementation DeviceNet
@synthesize Commanddelegate;
#pragma mark 搜索
-(void)initdelegate:(id<GCDAsyncUdpSocketDelegate>)delegate
{
    udpviewdelegate = delegate;
}
-(BOOL)SearchDevice
{
    udpsocketrecve = [[GCDAsyncUdpSocket alloc] initWithDelegate:udpviewdelegate delegateQueue:dispatch_get_main_queue()];
    if (![udpsocketrecve bindToPort:RECIVE_PORT error:nil])
        return NO;
    if (![udpsocketrecve beginReceiving:nil])
        return NO;
    udpsocketsend = [[GCDAsyncUdpSocket alloc] initWithDelegate:udpviewdelegate delegateQueue:dispatch_get_main_queue()];
    NSData *senddata =[SEARCH_MSG dataUsingEncoding:NSUTF8StringEncoding];
    [udpsocketsend enableBroadcast:YES error:nil];
    [udpsocketsend sendData:senddata toHost:MulticastAddr port:COMMUNICATION_PORT withTimeout:5 tag:0];
    
    return YES;
    
}
-(void)stopSearchDevice
{
    [udpsocketrecve close];
    [udpsocketsend close];
    udpsocketrecve=nil;
    udpsocketsend=nil;
}
#pragma mark -

-(BOOL)getContentType:(NSString *)ip
{
    
    _commandtype = EloadContentType;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
  
        if (Istimeout)
        {
            
            return NO;
        }
    }
    else{
        [tcpsocket disconnect];

        return NO;
    }
    return  YES;
    
}






#pragma mark tcp 委托

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接成功 %@ %d",host,port);
    NSString *command;
    NSData *data;
  
    switch (_commandtype) {
        case EloadContentType:
            command = [NSString stringWithFormat:@"%@%@%@",loadContentType,SplitStr,CRCL];
            NSLog(@"发送数据:%@",command);
            
            
            data =[command dataUsingEncoding:NSASCIIStringEncoding];
//      NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
//            [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
//                unsigned char *dataBytes = (unsigned char*)bytes;
//                for (NSInteger i = 0; i < byteRange.length; i++) {
//                    NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
//                    if ([hexStr length] == 2) {
//                        [string appendString:hexStr];
//                    } else {
//                        [string appendFormat:@"0%@", hexStr];
//                    }
//                }
//            }];
            
            
           [sock writeData:data withTimeout:0 tag:0];


            break;
            
     
    }
    
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"发送完毕");
    [sock readDataWithTimeout:5 tag:tag];
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);

      NSLog(@"接收到 数据 %@",[[NSString alloc] initWithData:data encoding:enc]);
  
    NSString *jsondata =[[NSString alloc] initWithData:data encoding:enc];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsondata dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    switch (_commandtype) {
        case EloadContentType:
            [Commanddelegate CommandFinish:_commandtype json:json];
            break;
            

    }
   
}
-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    [Commanddelegate CommandTimeout];
    return 0;
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err.code == GCDAsyncSocketConnectTimeoutError ||
        err.code == GCDAsyncSocketReadTimeoutError ||
        err.code == GCDAsyncSocketWriteTimeoutError)
    {
         [Commanddelegate CommandTimeout];
        return;
    }

    NSLog(@"错误 %@",err);
    NSLog(@"连接关闭");
}
#pragma mark -
@end