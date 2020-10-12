#include "tcp_server_func.h"



#define RECV_SIZE 2000
#define SEND_SIZE 2000

char TCPsendBuffer[SEND_SIZE];//发送buffer，仅在本文件中由底层驱动使用
char TCPrecvBuffer[RECV_SIZE];//接收buffer，仅在本文件中由底层驱动使用
extern char TCP_User_Send_Buf;//发送buffer，在main中定义和改写
extern char TCP_User_Recv_Buf;//接收buffer，在main中定义和读取
extern struct netif server_netif;
static struct tcp_pcb *connected_TCP_pcb = NULL; // connected_pcb c_pcb
extern u8 tcp_udp_server_flag;	 //Server 测试全局状态标记变量

// 在开发测试中使用的变量
int tcp_poll_cnt = 0;
int tcp_sent_cnt = 0;
int count_for = 0;
int Test_counter = 0;
char test_char[] = "test! \r\n";


//*****************应用层 操作*******************************

// 打印recvbuffer中的内容
void TCP_print_received_data(void){
	xil_printf("%s \r\n", TCPrecvBuffer);
}



// 使用tcp来发送数据，可在任何位置使用，输入为字符串
void TCP_Send_data(const char a[]){
	//** 标记发送数据 **
	tcp_udp_server_flag|=1<<7;
	struct tcp_pcb *tpcb = connected_TCP_pcb;
	u16 plen;
	err_t wr_err=ERR_OK;
	struct pbuf* temp_p;
	struct pbuf *ptr;
	memcpy(TCPsendBuffer, a, RECV_SIZE); //将函数输入的字符串写入sendbuffer中
	temp_p = pbuf_alloc(PBUF_TRANSPORT,strlen((char*) TCPsendBuffer),PBUF_POOL);
	pbuf_take(temp_p,(char*)TCPsendBuffer,strlen((char*)TCPsendBuffer));

	 while((wr_err==ERR_OK)&&temp_p&&(temp_p->len<=tcp_sndbuf(tpcb)))
	 {
		ptr=temp_p;
		wr_err=tcp_write(tpcb,ptr->payload,ptr->len,1);
		if(wr_err==ERR_OK)
		{
			plen=ptr->len;
			temp_p=ptr->next;			//指向下一个pbuf
			if(temp_p) pbuf_ref(temp_p);	//pbuf的ref加1
			pbuf_free(ptr);
			tcp_recved(tpcb,plen); 		//更新tcp窗口大小
		}else if(wr_err==ERR_MEM) temp_p=ptr;//否则就不往后走
	 }
	if(temp_p != NULL) pbuf_free(temp_p); //释放内存
}



//接收回调函数
err_t tcp_recv_callback(void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err)
{
	err_t ret_err;
	u32 data_len = 0;
	struct pbuf *q;
	struct tcp_server_struct *tcp_state;
	LWIP_ASSERT("arg != NULL",arg != NULL);
	tcp_state=(struct tcp_server_struct *)arg;

	/* 处于未建立状态则不要读取数据包 */
	if (p==NULL) {
		tcp_state->state=TCPSERVER_CLOSING;//需要关闭TCP 连接了
		tcp_state->p=p;
		tcp_close(tpcb);//关闭连接
		xil_printf("tcp connection closed\r\n");
		tcp_udp_server_flag&=~(1<<5);//标记连接断开了
		tcp_recv(tpcb, NULL); // 清除回调函数的连接
		return ERR_OK;
	}

	if(err!=ERR_OK){//从客户端接收到一个非空数据,但是由于某种原因err!=ERR_OK
		if(p)pbuf_free(p);	//释放接收pbuf
		ret_err=err;
	}else if(tcp_state->state==TCPSERVER_ACCEPTED){//处于连接状态
		if(p!=NULL)  //当处于连接状态并且接收到的数据不为空时将其打印出来
		{
			//******************* 开始接收并存入buffer**********************
//			TCP_receive_commend(p); //直接从pbuf中分析获取指令，其实也可从TCP_User_Recv_Buf中分析获取指令
			memset(TCPrecvBuffer,'\0',RECV_SIZE);  //数据接收缓冲区清零
			for(q=p;q!=NULL;q=q->next)  //遍历完整个pbuf链表
			{
				//判断要拷贝到RECV_SIZE中的数据是否大于RECV_SIZE的剩余空间，如果大于
				//的话就只拷贝RECV_SIZE中剩余长度的数据，否则的话就拷贝所有的数据
				if(q->len > (RECV_SIZE-data_len)) memcpy(TCPrecvBuffer+data_len,q->payload,(RECV_SIZE-data_len));//拷贝数据
				else memcpy(TCPrecvBuffer+data_len,q->payload,q->len);
				data_len += q->len;
				if(data_len > RECV_SIZE){
					break; //超出TCP客户端接收数组,跳出
				}
			}
			//** 标记接收到数据了 **
			tcp_udp_server_flag|=1<<6;
			tcp_recved(tpcb, p->len);   //已收到数据包，更新窗口
			//***********************接收结束，已存入recvbuffer************************
			//**************加入加入代码处理接收的数据******************
			strcpy(&TCP_User_Recv_Buf, &TCPrecvBuffer);
			pbuf_free(p);    //释放pbuf
			ret_err=ERR_OK;
		}
	}else//服务器关闭了
	{
		tcp_recved(tpcb,p->tot_len);//用于获取接收数据,通知LWIP可以获取更多数据
		tcp_state->p=NULL;
		pbuf_free(p); //释放内存
		ret_err=ERR_OK;
	}
	return ret_err;
}

//关闭tcp连接
void tcp_server_connection_close(struct tcp_pcb *tpcb, struct tcp_server_struct *es)
{
	tcp_close(tpcb);
	tcp_arg(tpcb,NULL);
	tcp_sent(tpcb,NULL);
	tcp_recv(tpcb,NULL);
	tcp_err(tpcb,NULL);
	tcp_poll(tpcb,NULL,0);
	if(es)mem_free(es);
	tcp_udp_server_flag&=~(1<<5);//标记连接断开了
	xil_printf("TCP server closed \r\n");
}

// tcp轮询，可选择是否开启，在accetp中//已成功配置，随时可使用，在本项目中不使用
err_t tcp_poll_callback(void * arg, struct tcp_pcb * tpcb)
{
	err_t ret_err;
	struct tcp_server_struct *tcp_state;
	tcp_state=(struct tcp_server_struct *)arg;

	tcp_poll_cnt++;     //统计发送数据的次数
	xil_printf("poll int:%d\r\n", tcp_poll_cnt);
	if(tcp_state!=NULL)
	{
		if(tcp_udp_server_flag&(1<<7))	//判断是否有数据要发送
		{
			//以下代码仅作实例用于日后理解与使用，若需发送需打开flag
			xil_printf("polling test \r\n");
			memcpy(TCPsendBuffer, test_char , sizeof(test_char));
			tcp_state->p = pbuf_alloc(PBUF_TRANSPORT,strlen((char*) TCPsendBuffer),PBUF_POOL);
			pbuf_take(tcp_state->p,(char*)TCPsendBuffer,strlen((char*)TCPsendBuffer));
			send_data_d(tpcb,tcp_state);
			//tcp_server_flag&=~(1<<7);  			//清除数据发送标志位
			if(tcp_state->p != NULL) pbuf_free(tcp_state->p); //释放内存
		}else if(tcp_state->state==TCPSERVER_CLOSING)//需要关闭连接?执行关闭操作
		{
			tcp_server_connection_close(tpcb,tcp_state);//关闭连接
		}
		ret_err = ERR_OK;
	}else
	{
		tcp_abort(tpcb);//终止连接,删除pcb控制块
		ret_err=ERR_ABRT;
	}

	return ret_err;
}

// 发送之后的调用的回调函数
static err_t tcp_sent_callback(void *arg, struct tcp_pcb *tpcb, u16_t len)
{
	struct tcp_server_struct *es;
	LWIP_UNUSED_ARG(len);
	es = (struct tcp_server_struct *) arg;
	if(es->p) send_data_d(tpcb,es);//发送数据，保险起见（可能会有没处理完的）

	tcp_sent_cnt++; //统计发送数据的次数
	//xil_printf("sent counte : %d \r\n", tcp_sent_cnt);
	return ERR_OK;
}


//tcp_err函数的回调函数
void tcp_server_error_callback(void *arg,err_t err)
{
	LWIP_UNUSED_ARG(err);
	printf("tcp error \r\n");
	if(arg!=NULL)mem_free(arg);//释放内存
}

// 连接回调函数
err_t tcp_server_accept_callback(void *arg,struct tcp_pcb *tpcb,err_t err){
	xil_printf("tcp_server: Connection Accepted\r\n");
	err_t ret_err;
	struct tcp_server_struct *tcp_state;
	LWIP_UNUSED_ARG(arg);
	LWIP_UNUSED_ARG(err);
	tcp_setprio(tpcb,TCP_PRIO_MIN);//设置新创建的pcb优先级
	tcp_state=(struct tcp_server_struct*)mem_malloc(sizeof(struct tcp_server_struct)); //分配内存

	if(tcp_state!=NULL) //内存分配成功
	{
		tcp_state->state=TCPSERVER_ACCEPTED;  	//接收连接
		tcp_state->pcb=tpcb;
		tcp_state->p=NULL;

		connected_TCP_pcb = tpcb;   //存储连接的TCP状态
		tcp_nagle_disable(connected_TCP_pcb); // 停用nagle， 即不等栈满才发车//connected_pcb
		tcp_arg(connected_TCP_pcb,tcp_state);  //设置参数
		tcp_recv(connected_TCP_pcb, tcp_recv_callback);  //设置接收的回调函数
		tcp_err(connected_TCP_pcb,tcp_server_error_callback); 	//初始化err的回调函数
#if USE_TCP_POLL
		tcp_poll(connected_TCP_pcb, tcp_poll_callback, 2);//设置轮询的回调函数，参数 2 -->> 1 次/秒
#endif
		tcp_sent(connected_TCP_pcb, tcp_sent_callback); //设置发送后的回调函数

		//** 标记有客户端连上了 **
		tcp_udp_server_flag|=1<<5;
		ret_err=ERR_OK;
	}else{
		ret_err=ERR_MEM;
	}
	return ret_err;
}


// 开始tcp的server配置，由main调用
int TCP_start_application()
{
	struct tcp_pcb *TCP_server_pcb;
	err_t err;

	/*  创建新的TCP PCB  */
	TCP_server_pcb = tcp_new_ip_type(IPADDR_TYPE_ANY);
	if (!TCP_server_pcb) {
		xil_printf("txperf: Error creating PCB. Out of Memory\r\n");
		return -1;
	}
	/*  绑定本地端口  */
	err = tcp_bind(TCP_server_pcb, IP_ADDR_ANY, TCP_CONN_PORT);
	if (err != ERR_OK) {
	    xil_printf("tcp_server: Unable to bind to port %d: err = %d\r\n", TCP_CONN_PORT, err);
	    tcp_close(TCP_server_pcb);
	    return -2;
	}
    /*  监听连接  */
	TCP_server_pcb = tcp_listen(TCP_server_pcb);
	if (!TCP_server_pcb) {
		xil_printf("tcp_server: Out of memory while tcp_listen\r\n");
		tcp_close(TCP_server_pcb);
		return -3;
	}

	tcp_arg(TCP_server_pcb, NULL);

	/*  设置accept回调函数  */
	tcp_accept(TCP_server_pcb, tcp_server_accept_callback);

	return 0;
}



//*******************RAW TCP 操作***************************
//五个发送函数，各自有各自不同的输入方式和调用方式，其实可以使用重载，但这里为直观和保险，进行重命名
//此五个发送函数依次逐渐复杂，TCP_send_data函数为最终版本，前四个为探索时写，在最终版本中应删除
// send_a 可以在其他函数中直接使用，无需任何参数
//内部使用了全局变量connected_pcb作为write中的输入参数，故无法指定其他的tcp_pcb
void send_data_a()
{
	err_t err;

	itoa(Test_counter, TCPsendBuffer, 10);
	//strcat(Test_counter, " \0\r\n");

	struct tcp_pcb *tpcb = connected_TCP_pcb;

	if (!connected_TCP_pcb)
			return;

	err = tcp_write(tpcb, TCPsendBuffer, SEND_SIZE, 3);
	if (err != ERR_OK) {
		xil_printf("txperf: Error on tcp_write: %d\r\n", err);
		connected_TCP_pcb = NULL;
		return;
	}
	err = tcp_output(tpcb);
	if (err != ERR_OK) {
		xil_printf("txperf: Error on tcp_output: %d\r\n",err);
		return;
	}
	Test_counter++;
}


//send_b 使用pbuf* 为输入参数，发送该类型输入中已经存储的数据
//内部使用了全局变量connected_pcb作为write中的输入参数，故无法指定其他的tcp_pcb
void send_data_b(struct pbuf* p)
{
	err_t err;
	struct tcp_pcb *tpcb = connected_TCP_pcb;

	if (!connected_TCP_pcb)
			return;

	err = tcp_write(tpcb, p->payload, p->len, 3);
	if (err != ERR_OK) {
		xil_printf("txperf: Error on tcp_write: %d\r\n", err);
		connected_TCP_pcb = NULL;
		return;
	}
	err = tcp_output(tpcb);
	if (err != ERR_OK) {
		xil_printf("txperf: Error on tcp_output: %d\r\n",err);
		return;
	}
}



//send_c 使用tcp_pcb * 和 pbuf* 为输入参数，发送 pbuf*型输入中已经存储的数据
//可以根据不同的端口指定不同的任务的send（猜测）
void send_data_c(struct tcp_pcb *tpcb, struct pbuf* p){
	struct pbuf *ptr;
	u16 plen;
	err_t wr_err=ERR_OK;
	 while((wr_err==ERR_OK)&&p&&(p->len<=tcp_sndbuf(tpcb)))
	 {
		ptr=p;
		wr_err=tcp_write(tpcb,ptr->payload,ptr->len,1);
		if(wr_err==ERR_OK)
		{
			plen=ptr->len;
			p=ptr->next;			//指向下一个pbuf
			if(p) pbuf_ref(p);	//pbuf的ref加一
			pbuf_free(ptr);
			tcp_recved(tpcb,plen); 		//更新tcp窗口大小
		}else if(wr_err==ERR_MEM) p=ptr;//否则就不往后走
	 }
}


void send_data_c1(const char a[]){
	struct tcp_pcb *tpcb = connected_TCP_pcb;
	struct pbuf* temp_p;

	memcpy(TCPsendBuffer, a, sizeof(TCPrecvBuffer));
	temp_p = pbuf_alloc(PBUF_TRANSPORT,strlen((char*) TCPsendBuffer),PBUF_POOL);
	pbuf_take(temp_p,(char*)TCPsendBuffer,strlen((char*)TCPsendBuffer));
	send_data_c(tpcb, temp_p);
	if(temp_p != NULL) pbuf_free(temp_p);
}
//send_c 和 send_d 的使用示例，放在recv的callback中，于接收完成后
//***********************开始发送，从buffer中读取***********************

//			struct pbuf* temp_p;
//			temp_p = pbuf_alloc(PBUF_TRANSPORT,strlen((char*) sendBuffer),PBUF_POOL);
//			pbuf_take(temp_p,(char*)sendBuffer,strlen((char*)sendBuffer));
//			send_data_c(tpcb, temp_p);
//			if(temp_p != NULL) pbuf_free(temp_p);

//备选方法
//			es->p = pbuf_alloc(PBUF_TRANSPORT,strlen((char*) sendBuffer),PBUF_POOL);
//			pbuf_take(es->p,(char*)sendBuffer,strlen((char*)sendBuffer));
//			send_data_d(tpcb,es);
//			//tcp_server_flag&=~(1<<7);  			//清除数据发送标志位
//			if(es->p != NULL) pbuf_free(es->p); //释放内存

//***********************结束发送，从buffer中读取完毕***********************

//send_d 使用tcp_pcb * 和 tcp_server_struct * 为输入参数，发送tcp_server_struct * 的 pbuf*型输入中已经存储的数据
//与send_c 大同小异，只不过将pbuf* 集成进了tcp_server_struct *中，并加入了更多判断来加强安全性，当然也会更难使用
//可以根据不同的端口指定不同的任务的send（猜测）
void send_data_d(struct tcp_pcb *tpcb, struct tcp_server_struct *es){
	struct pbuf *ptr;
		u16 plen;
		err_t wr_err=ERR_OK;
		 while((wr_err==ERR_OK)&&es->p&&(es->p->len<=tcp_sndbuf(tpcb)))
		 {
			ptr=es->p;
			wr_err=tcp_write(tpcb,ptr->payload,ptr->len,1);
			if(wr_err==ERR_OK)
			{
				plen=ptr->len;
				es->p=ptr->next;			//指向下一个pbuf
				if(es->p) pbuf_ref(es->p);	//pbuf的ref加一
				pbuf_free(ptr);
				tcp_recved(tpcb,plen); 		//更新tcp窗口大小
			}else if(wr_err==ERR_MEM) es->p=ptr;
		 }
}


