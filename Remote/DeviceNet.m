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

-(BOOL)startListenserver
{
    udpsocketrecve = [[GCDAsyncUdpSocket alloc] initWithDelegate:udpviewdelegate delegateQueue:dispatch_get_main_queue()];
    if (![udpsocketrecve bindToPort:SEND_STATU_PORT error:nil])
        return NO;
    if (![udpsocketrecve beginReceiving:nil])
        return NO;

    return YES;
}
-(void)stoptListenserver
{
    [udpsocketrecve close];
    udpsocketrecve = nil;
}
#pragma mark -


#pragma mark 获取设备信息指令
-(BOOL)getContentType:(NSString *)ip
{
    
    _commandtype = EloadContentType;
  
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];

        return NO;
    }
    return  YES;
    
}



-(BOOL)getMediaByType:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EloadMediaByType;

    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
    
}


-(BOOL)getAllTask:(NSString *)ip
{
    
    _commandtype = EloadAllTask;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
    
}

-(BOOL)AddTask:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EaddTask;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)DelTask:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EdelTask;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)EditTask:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EEditTask;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)AddTaskwithMedia:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EAddtoTask;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)ConvertType:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EConvertType;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}
-(BOOL)DelMedia:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EDelMedia;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)getAllSysDir:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = ELoadSysDir;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)ScanSysDir:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EScanDir;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)ReplaceDB:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EReplaceDB;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)GetTaskDetailInfo:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EGetAllItemByTask;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}


-(BOOL)DelItemDetailInfo:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EDelTaskItem;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)setPlayMode:(NSString *)ip
{
    _commandtype = EPlayMode;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)setPlayOrder:(NSString *)ip
{
    _commandtype = EPlayOrder;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)setPlayOrStop:(NSString *)ip
{
    _commandtype = EPlayOrStop;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)setPlaypro:(NSString *)ip
{
    _commandtype = EPlaypro;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}
-(BOOL)setPlaynext:(NSString *)ip
{
    _commandtype = EPlaynext;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)setPlayMedia:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EPlayMedia;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}

-(BOOL)setSkipTime:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = ESkipTime;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}


-(BOOL)setPublicMedia:(NSString *)ip
{
    _commandtype = EPublicMedia;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}
-(BOOL)SetVolume:(NSString*)ip flag:(int)flag
{
    if (flag==0)
        _commandtype = EupVolume;
    else
        _commandtype = EdownVolume;
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}


-(BOOL)setOnOffTime:(NSString *)ip arg:(NSString *)arg
{
    _arg=arg;
    _commandtype = EOnOffTime;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}


-(BOOL)getShutTimeinfo:(NSString *)ip
{
    
    _commandtype = EGetShutTime;
    
    tcpsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([tcpsocket connectToHost:ip onPort:CommandPort withTimeout:5 error:nil])
    {
        return YES;
    }
    else{
        [tcpsocket disconnect];
        
        return NO;
    }
    return  YES;
}
#pragma mark -




#pragma mark tcp 委托

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接成功 %@ %d",host,port);
    NSString *command;
    NSData *data;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
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
        case EloadMediaByType:
            command = [NSString stringWithFormat:@"%@%@%@%@",loadMediaByType,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);

            
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EloadAllTask:
            command = [NSString stringWithFormat:@"%@%@%@",loadAllTask,SplitStr,CRCL];
            NSLog(@"发送数据:%@",command);
            
            
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EaddTask:
            command = [NSString stringWithFormat:@"%@%@%@%@",addTask,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            
            
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
       case EdelTask:
            command = [NSString stringWithFormat:@"%@%@%@%@",delTask,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            
            
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EEditTask:
            command = [NSString stringWithFormat:@"%@%@%@%@",editTask,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            
            
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EDelMedia:
            command = [NSString stringWithFormat:@"%@%@%@%@",delMedia,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EConvertType:
            command = [NSString stringWithFormat:@"%@%@%@%@",convertType,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case ELoadSysDir:
            command = [NSString stringWithFormat:@"%@%@%@%@",loadSysDir,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EScanDir:
            command = [NSString stringWithFormat:@"%@%@%@%@",scanfDir,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EReplaceDB:
            command = [NSString stringWithFormat:@"%@%@%@%@",replaceDB,SplitStr,_arg, CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EGetAllItemByTask:
            command = [NSString stringWithFormat:@"%@%@%@%@",getAllItemByTask,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EDelTaskItem:
            command = [NSString stringWithFormat:@"%@%@%@%@",delTaskItem,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EAddtoTask:
            command = [NSString stringWithFormat:@"%@%@%@%@",addToTask,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EPlayMode:
            command = [NSString stringWithFormat:@"%@%@%@",playMode,SplitStr,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EPlayOrder:
            command = [NSString stringWithFormat:@"%@%@%@",playorder,SplitStr,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EPlayOrStop:
            command = [NSString stringWithFormat:@"%@%@%@",playOrPause,SplitStr,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EPlaypro:
            command = [NSString stringWithFormat:@"%@%@%@",playpro,SplitStr,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EPlaynext:
            command = [NSString stringWithFormat:@"%@%@%@",playnext,SplitStr,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EPlayMedia:
            command = [NSString stringWithFormat:@"%@%@%@%@",playMedia,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case ESkipTime:
            command = [NSString stringWithFormat:@"%@%@%@%@",skiptime,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EPublicMedia:
            command = [NSString stringWithFormat:@"%@%@%@",playPublicMedia,SplitStr,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EupVolume:
            command = [NSString stringWithFormat:@"%@%@%@",upVolume,SplitStr,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EdownVolume:
            command = [NSString stringWithFormat:@"%@%@%@",dowmVolume,SplitStr,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EOnOffTime:
            command = [NSString stringWithFormat:@"%@%@%@%@",OnOffTime,SplitStr,_arg,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
        case EGetShutTime:
            command = [NSString stringWithFormat:@"%@%@%@",getshutdown,SplitStr,CRCL];
            NSLog(@"发送数据:%@",command);
            data =[command dataUsingEncoding:enc];
            [sock writeData:data withTimeout:0 tag:0];
            break;
    }
    
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"发送完毕");
    switch (_commandtype) {
        case EloadContentType:
            [sock readDataWithTimeout:5 tag:tag];
            break;
        case EloadMediaByType:
        case EupVolume:
        case EdownVolume:
        case EloadAllTask:
        case EaddTask:
        case EdelTask:
        case EEditTask:
        case EDelMedia:
        case EConvertType:
        case ELoadSysDir:
        case EScanDir:
        case EReplaceDB:
        case EGetAllItemByTask:
        case EDelTaskItem:
        case EPlayMode:
        case EPlayOrder:
        case EPlayOrStop:
        case EPlaypro:
        case EPlaynext:
        case EPlayMedia:
        case EPublicMedia:
        case EAddtoTask:
        case ESkipTime:
        case EOnOffTime:
        case EGetShutTime:
            [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:10 tag:1];
            break;
            
            
    }
    
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);

      NSLog(@"接收到 数据 %@",[[NSString alloc] initWithData:data encoding:enc]);
  
    NSString *jsondata =[[NSString alloc] initWithData:data encoding:enc];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsondata dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    switch (_commandtype) {
        case EloadContentType:
        case EloadMediaByType:
        case EloadAllTask:
        case EaddTask:
        case EdelTask:
        case EupVolume:
        case EdownVolume:
        case EEditTask:
        case EDelMedia:
        case EConvertType:
        case ELoadSysDir:
        case EScanDir:
        case EReplaceDB:
        case EGetAllItemByTask:
        case EDelTaskItem:
        case EPlayMode:
        case EPlayOrder:
        case EPlayOrStop:
        case EPlaypro:
        case EPlaynext:
        case EPlayMedia:
        case EPublicMedia:
        case EAddtoTask:
        case ESkipTime:
        case EOnOffTime:
        case EGetShutTime:
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
        err.code == GCDAsyncSocketWriteTimeoutError ||
        err.code == 61)
    {
         [Commanddelegate CommandTimeout];
        return;
    }

    NSLog(@"错误 %@",err);
    NSLog(@"连接关闭");
}
#pragma mark -
@end
