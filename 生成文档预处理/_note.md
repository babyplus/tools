# 创建VLAN

**拓扑中使用到的vlan为2,3,4，其中黄色部分业务流量的vlan为vlan2和vlan3, 蓝色部分的业务流量vlan为vlan4, 蓝色区域需要同时允许vlan2,vlan3通过**

## NE1,NE2,NE3

vlan 2
vlan 3
vlan 4
commit

## NE6

vlan 2
commit

## NE4

vlan 3
commit

## NE5

vlan 2
vlan 3
commit


# 使用到的相关接口全部配置成二层口

**略**


# 配置二层口

## NE1

interface Ethernet1/0/0
port link-type trunk
port trunk allow-pass vlan 2 to 4
interface Ethernet1/0/1
port link-type trunk
port trunk allow-pass vlan 2 to 4
interface Ethernet1/0/2
port link-type trunk
port trunk allow-pass vlan 2 to 4
commit

## NE3

interface Ethernet1/0/0
port link-type trunk
port trunk allow-pass vlan 2 to 4
interface Ethernet1/0/1
port link-type trunk
port trunk allow-pass vlan 2 to 4
commit

## NE2

interface Ethernet1/0/0
port link-type trunk
port trunk allow-pass vlan 2 to 4
interface Ethernet1/0/1
port link-type trunk
port trunk allow-pass vlan 3
interface Ethernet1/0/2
port link-type trunk
port trunk allow-pass vlan 2
commit

## NE5

interface Ethernet1/0/0
port link-type trunk
port trunk allow-pass vlan 2 to 3
interface Ethernet1/0/1
port trunk allow-pass vlan 2
port default vlan 2
interface Ethernet1/0/2
port trunk allow-pass vlan 3
port default vlan 3
commit

## NE4

interface Ethernet1/0/0
port link-type trunk
port trunk allow-pass vlan 3
interface Ethernet1/0/1
port trunk allow-pass vlan 3
port default vlan 3
commit

## NE6

interface Ethernet1/0/0
port link-type trunk
port trunk allow-pass vlan 2
interface Ethernet1/0/1
port trunk allow-pass vlan 2
port default vlan 2
commit


# cfm 连通性检测配置

**蓝色部分维护域等级为4，黄色部分维护域等级为6，NE3 NE1 NE2 上配置等级为4的mep，NE5 NE4 NE6 上配置等级为6的mep**

## NE1

cfm enable
cfm md md1 level 6
ma ma1
map vlan 2
ma ma2
map vlan 3
cfm md md2 level 4
ma ma3
map vlan 4
mep mep-id 1 interface Ethernet1/0/2 inward
mep ccm-send enable
remote-mep mep-id 2
remote-mep mep-id 3
remote-mep ccm-receive enable
commit

## NE2

cfm enable
cfm md md1 level 6
ma ma1
map vlan 2
ma ma2
map vlan 3
cfm md md2 level 4
ma ma3
map vlan 4
mep mep-id 2 interface Ethernet1/0/0 outward
mep ccm-send enable
remote-mep mep-id 1
remote-mep mep-id 3
remote-mep ccm-receive enable
commit

## NE3

cfm enable
cfm md md1 level 6
ma ma1
map vlan 2
ma ma2
map vlan 3
cfm md md2 level 4
ma ma3
map vlan 4
mep mep-id 3 interface Ethernet1/0/1 inward
mep ccm-send enable
remote-mep mep-id 1
remote-mep mep-id 2
remote-mep ccm-receive enable
commit

## NE5

cfm enable
cfm md md1 level 6
ma ma1
map vlan 2
mep mep-id 2 interface Ethernet1/0/1 inward
mep ccm-send enable
remote-mep mep-id 3
remote-mep ccm-receive enable
ma ma2
map vlan 3
mep mep-id 1 interface Ethernet1/0/2 inward
mep ccm-send enable
remote-mep mep-id 2
remote-mep ccm-receive enable
commit

## NE4

cfm enable
cfm md md1 level 6
ma ma2
map vlan 3
mep mep-id 2 interface Ethernet1/0/1 inward
mep ccm-send enable
remote-mep mep-id 1
remote-mep ccm-receive enable
commit

## NE6

cfm enable
cfm md md1 level 6
ma ma1
map vlan 2
mep mep-id 3 interface Ethernet1/0/1 inward
mep ccm-send enable
remote-mep mep-id 2
remote-mep ccm-receive enable
commit


# 检查连通性

**NE5周期性接到来自NE4，NE6的CCM报文，并检查是否为期待报文，若报文无误，则状态为up**

## NE5

```
[~HUAWEI]dis cfm remote-mep
The total number of RMEPs is : 2
The status of RMEPs : 2 up, 0 down, 0 disable
--------------------------------------------------
MD Name            : md1
Level              : 6
MA Name            : ma1
RMEP ID            : 3
VLAN ID            : 2
VSI Name           : --
L2VC ID            : --
L2VPN Name         : --
CE ID              : --
CE Offset          : --
L2TPV3 Tunnel Name            : --
L2TPV3 Local Connection Name  : --
CCC Name           : --
EVPN-Instance Name : --
Bridge-domain ID   : --
MAC                : 707b-e83d-497f
CCM Receive        : enabled
Trigger-If-Down    : disabled
CFM Status         : up
Alarm Status       : none
Interface TLV      : --
Port Status TLV    : --
Chassis ID         : --
Management Address : --
MD Name            : md1
Level              : 6
MA Name            : ma2
RMEP ID            : 2
VLAN ID            : 3
VSI Name           : --
L2VC ID            : --
L2VPN Name         : --
CE ID              : --
CE Offset          : --
L2TPV3 Tunnel Name            : --
L2TPV3 Local Connection Name  : --
CCC Name           : --
EVPN-Instance Name : --
Bridge-domain ID   : --
MAC                : 707b-e814-0faf
CCM Receive        : enabled
Trigger-If-Down    : disabled
CFM Status         : up
Alarm Status       : none
Interface TLV      : --
Port Status TLV    : --
Chassis ID         : --
Management Address : --
```

# 创建mip  

**维护中间点位于维护域内部，通过MEP之间部署多个MIP可以提高对网络的可管理性。**
**在对MA内的非MEP节点进行环回或者链路跟踪操作时，通过执行该命令配置MIP节点响应LBM(Loopback Message)或者LTM(Linktrace Message)。配置了生成规则后，设备会根据规则自动创建MIP。**

## NE1 

cfm md md1
mip create-type default
commit

```
[~HUAWEI-md-md1]dis cfm mip
Interface Name                Level MAC                 Config Type
-------------------------------------------------------------------
Ethernet1/0/0                 6     38ba-2ee7-7901      Auto      
Ethernet1/0/1                 6     38ba-2ee7-7901      Auto      
Ethernet1/0/2                 6     38ba-2ee7-7901      Auto      
```

## NE2


cfm md md1
mip create-type default
commit

```
[~HUAWEI-md-md1]dis cfm mip
Interface Name                Level MAC                 Config Type
-------------------------------------------------------------------
Ethernet1/0/0                 6     707b-e878-7149      Auto      
Ethernet1/0/1                 6     707b-e878-7149      Auto      
Ethernet1/0/2                 6     707b-e878-7149      Auto      
```

## NE3

cfm md md1
mip create-type default
commit

```
[~HUAWEI-md-md1]dis cfm mip
Interface Name                Level MAC                 Config Type
-------------------------------------------------------------------
Ethernet1/0/0                 6     38ba-7690-1a02      Auto      
Ethernet1/0/1                 6     38ba-7690-1a02      Auto      
```


## NE6

cfm md md1
mip create-type default
commit

```
[~HUAWEI-md-md1]dis cfm mip
Interface Name                Level MAC                 Config Type
-------------------------------------------------------------------
Ethernet1/0/0                 6     707b-e83d-497f      Auto      
```

## NE4

cfm md md1
mip create-type default
commit

```
[~HUAWEI-md-md1]dis cfm mip
Interface Name                Level MAC                 Config Type
-------------------------------------------------------------------
Ethernet1/0/0                 6     707b-e814-0faf      Auto      
```

# 发起环回请求

## NE5

**在NE5通过 remote-mep 的 mep-id ping NE4和NE6**

```
[~HUAWEI-md-md1-ma-ma1]ping mac-8021ag mep mep-id 2 remote-mep mep-id 3
Pinging 707b-e83d-497f with 95 bytes of data:
Reply from 707b-e83d-497f: bytes = 95, time = 18ms
Reply from 707b-e83d-497f: bytes = 95, time = 13ms
Reply from 707b-e83d-497f: bytes = 95, time = 11ms
Reply from 707b-e83d-497f: bytes = 95, time = 20ms
Reply from 707b-e83d-497f: bytes = 95, time = 13ms
Packets: Sent = 5, Received = 5, Lost = 0 (0% loss)
Minimum = 11ms, Maximum = 20ms, Average = 15ms
```

```
[~HUAWEI-md-md1-ma-ma2]ping mac-8021ag mep mep-id 1 remote-mep mep-id 2
Pinging 707b-e814-0faf with 95 bytes of data:
Reply from 707b-e814-0faf: bytes = 95, time = 25ms
Reply from 707b-e814-0faf: bytes = 95, time = 11ms
Reply from 707b-e814-0faf: bytes = 95, time = 14ms
Reply from 707b-e814-0faf: bytes = 95, time = 9ms
Reply from 707b-e814-0faf: bytes = 95, time = 12ms
Packets: Sent = 5, Received = 5, Lost = 0 (0% loss)
Minimum = 9ms, Maximum = 25ms, Average = 14ms
```

**在NE5通过 mac ping 沿途设备NE3,NE1,NE2,NE6**

```
[~HUAWEI-md-md1-ma-ma1]ping mac-8021ag mep mep-id 2 mac 38ba-7690-1a02
Pinging 38ba-7690-1a02 with 95 bytes of data:
Reply from 38ba-7690-1a02: bytes = 95, time = 96ms
Reply from 38ba-7690-1a02: bytes = 95, time = 4ms
Reply from 38ba-7690-1a02: bytes = 95, time = 3ms
Reply from 38ba-7690-1a02: bytes = 95, time = 7ms
Reply from 38ba-7690-1a02: bytes = 95, time = 4ms
Packets: Sent = 5, Received = 5, Lost = 0 (0% loss)
Minimum = 3ms, Maximum = 96ms, Average = 22ms
[~HUAWEI-md-md1-ma-ma1]ping mac-8021ag mep mep-id 2 mac 38ba-2ee7-7901
Pinging 38ba-2ee7-7901 with 95 bytes of data:
Reply from 38ba-2ee7-7901: bytes = 95, time = 222ms
Reply from 38ba-2ee7-7901: bytes = 95, time = 6ms
Reply from 38ba-2ee7-7901: bytes = 95, time = 8ms
Reply from 38ba-2ee7-7901: bytes = 95, time = 9ms
Reply from 38ba-2ee7-7901: bytes = 95, time = 6ms
Packets: Sent = 5, Received = 5, Lost = 0 (0% loss)
Minimum = 6ms, Maximum = 222ms, Average = 50ms
[~HUAWEI-md-md1-ma-ma1]ping mac-8021ag mep mep-id 2 mac 707b-e878-7149
Pinging 707b-e878-7149 with 95 bytes of data:
Reply from 707b-e878-7149: bytes = 95, time = 93ms
Reply from 707b-e878-7149: bytes = 95, time = 12ms
Reply from 707b-e878-7149: bytes = 95, time = 8ms
Reply from 707b-e878-7149: bytes = 95, time = 8ms
Reply from 707b-e878-7149: bytes = 95, time = 11ms
Packets: Sent = 5, Received = 5, Lost = 0 (0% loss)
Minimum = 8ms, Maximum = 93ms, Average = 26ms
[~HUAWEI-md-md1-ma-ma1]ping mac-8021ag mep mep-id 2 mac 707b-e83d-497f
Pinging 707b-e83d-497f with 95 bytes of data:
Reply from 707b-e83d-497f: bytes = 95, time = 14ms
Reply from 707b-e83d-497f: bytes = 95, time = 12ms
Reply from 707b-e83d-497f: bytes = 95, time = 13ms
Reply from 707b-e83d-497f: bytes = 95, time = 11ms
Reply from 707b-e83d-497f: bytes = 95, time = 13ms
Packets: Sent = 5, Received = 5, Lost = 0 (0% loss)
Minimum = 11ms, Maximum = 14ms, Average = 12ms
```

# 发起链路跟踪请求

**均不成功**

# 清除NE3和NE1的配置

**略**

# 增加pw链路

**将NE3:1/0/1到NE1:1/0/1之间的链路改造为pw**

## NE3

mpls lsr-id 1.1.1.9
mpls
mpls ldp
q
mpls l2vpn

interface Ethernet1/0/0
undo shutdown
ip address 10.1.1.1 255.255.255.252
mpls
mpls ldp

interface LoopBack1
ip address 1.1.1.9 255.255.255.255

ospf 1
area 0.0.0.0
network 1.1.1.9 0.0.0.0
network 10.1.1.0 0.0.0.3

interface Ethernet1/0/1
mpls l2vc 2.2.2.9 101 raw

interface Ethernet1/0/1.2
vlan-type dot1q 2
mpls l2vc 2.2.2.9 102 tagged

interface Ethernet1/0/1.3
vlan-type dot1q 3
mpls l2vc 2.2.2.9 103 tagged

commit

## NE1

mpls lsr-id 2.2.2.9
mpls
mpls ldp


q
mpls l2vpn

interface Ethernet1/0/0
undo shutdown
ip address 10.1.1.2 255.255.255.252
mpls
mpls ldp

interface LoopBack1
ip address 2.2.2.9 255.255.255.255

ospf 1
area 0.0.0.0
network 2.2.2.9 0.0.0.0
network 10.1.1.0 0.0.0.3

interface Ethernet1/0/1
mpls l2vc 1.1.1.9 101

interface Ethernet1/0/1.2
vlan-type dot1q 2
mpls l2vc 1.1.1.9 102 tagged

interface Ethernet1/0/1.3
vlan-type dot1q 3
mpls l2vc 1.1.1.9 103 tagged

commit

```
[~HUAWEI-Ethernet1/0/1.3]dis mpls l2vc brief
 Total LDP VC : 3     3 up       0 down
 *Client Interface     : Ethernet1/0/1
  Administrator PW     : no
  AC status            : up
  VC state             : up
  Label state          : 0
  Token state          : 0
  VC ID                : 101
  VC Type              : Ethernet
  session state        : up
  Destination          : 1.1.1.9
  link state           : up
 *Client Interface     : Ethernet1/0/1.2
  Administrator PW     : no
  AC status            : up
  VC state             : up
  Label state          : 0
  Token state          : 0
  VC ID                : 102
  VC Type              : VLAN
  session state        : up
  Destination          : 1.1.1.9
  link state           : up
 *Client Interface     : Ethernet1/0/1.3
  Administrator PW     : no
  AC status            : up
  VC state             : up
  Label state          : 0
  Token state          : 0
  VC ID                : 103
  VC Type              : VLAN
  session state        : up
  Destination          : 1.1.1.9
  link state           : up
```


# 伪线ac侧配置cfm mp配置

## NE3

**配置NE3 ac侧主接口的mep，将各个维护域与业务绑定。**
**为了后续不同业务的环回实验，设置自动生成vlan2相关业务的mip，不生成vlan3相关业务的mip**

cfm enable
cfm md md1 level 6
mip create-type default
ma ma1
map mpls l2vc 2.2.2.9 102 tagged
ma ma2
mip create-type none
map mpls l2vc 2.2.2.9 103 tagged
cfm md md2 level 4
ma ma3
map mpls l2vc 2.2.2.9 101 raw
mep mep-id 3 interface Ethernet1/0/1 inward
mep ccm-send enable
remote-mep mep-id 2
remote-mep ccm-receive enable
commit

```
[~HUAWEI-Ethernet1/0/1] dis cfm mep
The total number of MEPs is : 1
--------------------------------------------------
MD Name            : md2
MD Name Format     : string
Level              : 4
MA Name            : ma3
MEP ID             : 3
VLAN ID            : --
VSI Name           : --
L2VC Peer IP       : 2.2.2.9
L2VC ID            : 101 raw
L2VPN Name         : --
CE ID              : --
CE Offset          : --
L2TPV3 Tunnel Name            : --
L2TPV3 Local Connection Name  : --
CCC Name           : --
EVPN-Instance Name : --
Bridge-domain ID   : --
Interface Name     : Ethernet1/0/1
CCM Send           : enabled
Direction          : inward
MAC Address        : 38ba-7690-1a02
MEP Pe-vid         : --
MEP Ce-vid         : --
MEP Vid            : --
Alarm Status       : LOC
Alarm AIS          : enabled
Alarm RDI          : enabled
Bandwidth Receive  : false
Bandwidth          : --

[~HUAWEI-md-md1-ma-ma2]dis cfm mip
Interface Name                Level MAC                 Config Type
-------------------------------------------------------------------
Ethernet1/0/1.2               6     38ba-7690-1a02      Auto      
```

## 抓包

**在 NE1 1/0/1 到 NE2 1/0/0 链路中间查看源地址为38ba-7690-1a02不带vlan的ccm报文**

0000   01 80 c2 00 00 34 38 ba 76 90 1a 02 89 02 80 01
0010   84 46 00 00 00 00 00 03 04 03 6d 64 32 02 03 6d
0020   61 33 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0030   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0040   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0050   00 00 00 00 00 00 00 00 00

# NE5通过指定不同的mep ping NE3

## NE5

```
[~HUAWEI-md-md1]ping mac-8021ag mep mep-id 2 md md1 ma ma1 mac 38ba-7690-1a02
Pinging 38ba-7690-1a02 with 95 bytes of data:
Reply from 38ba-7690-1a02: bytes = 95, time = 6ms
Reply from 38ba-7690-1a02: bytes = 95, time = 5ms
Reply from 38ba-7690-1a02: bytes = 95, time = 5ms
Reply from 38ba-7690-1a02: bytes = 95, time = 6ms
Reply from 38ba-7690-1a02: bytes = 95, time = 3ms
Packets: Sent = 5, Received = 5, Lost = 0 (0% loss)
Minimum = 3ms, Maximum = 6ms, Average = 5ms
[~HUAWEI-md-md1]ping mac-8021ag mep mep-id 1 md md1 ma ma2 mac 38ba-7690-1a02
Pinging 38ba-7690-1a02 with 95 bytes of data:
The request timed out.
The request timed out.
The request timed out.
The request timed out.
The request timed out.
Packets: Sent = 5, Received = 0, Lost = 5 (100% loss)
Minimum = 0ms, Maximum = 0ms, Average = 0ms
```

# 配置NE1 ac侧主接口的mep, 将各个维护域与业务绑定

## NE1

cfm enable
cfm md md1 level 6
mip create-type default
ma ma1
map mpls l2vc 1.1.1.9 102 tagged
ma ma2
map mpls l2vc 1.1.1.9 103 tagged
cfm md md2 level 4
ma ma3
map mpls l2vc 1.1.1.9 101 raw
mep mep-id 2 interface Ethernet1/0/1 inward
mep ccm-send enable
remote-mep mep-id 3
remote-mep ccm-receive enable
commit

```
[~HUAWEI-md-md2-ma-ma3]dis cfm remote-mep
The total number of RMEPs is : 1
The status of RMEPs : 1 up, 0 down, 0 disable
--------------------------------------------------
 MD Name            : md2
 Level              : 4
 MA Name            : ma3
 RMEP ID            : 3
 VLAN ID            : --
 VSI Name           : --
 L2VC Peer IP       : 1.1.1.9
 L2VC ID            : 101 raw
 L2VPN Name         : --
 CE ID              : --
 CE Offset          : --
 L2TPV3 Tunnel Name            : --
 L2TPV3 Local Connection Name  : --
 CCC Name           : --
 EVPN-Instance Name : --
 Bridge-domain ID   : --
 MAC                : 38ba-7690-1a02
 CCM Receive        : enabled
 Trigger-If-Down    : disabled
 CFM Status         : up
 Alarm Status       : none
 Interface TLV      : --
 Port Status TLV    : --
 Chassis ID         : --
 Management Address : --
```


# 子接口上配置mep，用于检测业务流量的连通性和性能

## NE3

**NE3 上进行配置，将 md level 设置为6，将会拦截来自 NE6 的CCM报文，与 NE6 建立连通性检测，此时不再存在mip**

cfm md md1 level 6
ma ma1
map mpls l2vc 2.2.2.9 102 tagged
mep mep-id 2 interface Ethernet1/0/1.2 inward
mep ccm-send mep-id 2 enable
remote-mep mep-id 3
remote-mep ccm-receive mep-id 3 enable
commit

```
[~HUAWEI-md-md1-ma-ma1]dis cfm remote-mep md md1
The total number of RMEPs is : 1
The status of RMEPs : 1 up, 0 down, 0 disable
--------------------------------------------------
 MD Name            : md1
 Level              : 6
 MA Name            : ma1
 RMEP ID            : 3
 VLAN ID            : --
 VSI Name           : --
 L2VC Peer IP       : 2.2.2.9
 L2VC ID            : 102 tagged
 L2VPN Name         : --
 CE ID              : --
 CE Offset          : --
 L2TPV3 Tunnel Name            : --
 L2TPV3 Local Connection Name  : --
 CCC Name           : --
 EVPN-Instance Name : --
 Bridge-domain ID   : --
 MAC                : 707b-e83d-497f
 CCM Receive        : enabled
 Trigger-If-Down    : disabled
 CFM Status         : up
 Alarm Status       : none
 Interface TLV      : --
 Port Status TLV    : --
 Chassis ID         : --
 Management Address : --

[~HUAWEI-md-md1-ma-ma1]dis cfm mip
Info: The MIP does not exist.
```

## NE5

**NE5 失去与NE6 的连通性检测 **

```
[~HUAWEI-md-md1]dis cfm remote-mep md md1 ma ma1
The total number of RMEPs is : 1
The status of RMEPs : 0 up, 1 down, 0 disable
--------------------------------------------------
 MD Name            : md1
 Level              : 6
 MA Name            : ma1
 RMEP ID            : 3
 VLAN ID            : 2
 VSI Name           : --
 L2VC ID            : --
 L2VPN Name         : --
 CE ID              : --
 CE Offset          : --
 L2TPV3 Tunnel Name            : --
 L2TPV3 Local Connection Name  : --
 CCC Name           : --
 EVPN-Instance Name : --
 Bridge-domain ID   : --
 MAC                : 707b-e83d-497f
 CCM Receive        : enabled
 Trigger-If-Down    : disabled
 CFM Status         : down
 Alarm Status       : LOC
 Interface TLV      : --
 Port Status TLV    : --
 Chassis ID         : --
 Management Address : --
```


# 降低NE3和NE1业务相关的等级，确保高等级报文可穿透

## NE3

cfm md md1 level 5
ma ma1
map mpls l2vc 2.2.2.9 102 tagged
mep mep-id 2 interface Ethernet1/0/1.2 inward
mep ccm-send mep-id 2 enable
remote-mep mep-id 3
remote-mep ccm-receive mep-id 3 enable

ma ma2
map mpls l2vc 2.2.2.9 103 tagged
mep mep-id 2 interface Ethernet1/0/1.3 inward
mep ccm-send mep-id 2 enable
remote-mep mep-id 3
remote-mep ccm-receive mep-id 3 enable

commit

## NE1

cfm md md1 level 5
ma ma1
map mpls l2vc 1.1.1.9 102 tagged
mep mep-id 3 interface Ethernet1/0/1.2 inward
mep ccm-send mep-id 3 enable
remote-mep mep-id 2
remote-mep ccm-receive mep-id 2 enable

ma ma2
map mpls l2vc 1.1.1.9 103 tagged
mep mep-id 3 interface Ethernet1/0/1.3 inward
mep ccm-send mep-id 3 enable
remote-mep mep-id 2
remote-mep ccm-receive mep-id 2 enable

commit

```
[~HUAWEI-md-md1-ma-ma2]  dis cfm remote-mep md md1
The total number of RMEPs is : 2
The status of RMEPs : 2 up, 0 down, 0 disable
--------------------------------------------------
 MD Name            : md1
 Level              : 5
 MA Name            : ma1
 RMEP ID            : 2
 VLAN ID            : --
 VSI Name           : --
 L2VC Peer IP       : 1.1.1.9
 L2VC ID            : 102 tagged
 L2VPN Name         : --
 CE ID              : --
 CE Offset          : --
 L2TPV3 Tunnel Name            : --
 L2TPV3 Local Connection Name  : --
 CCC Name           : --
 EVPN-Instance Name : --
 Bridge-domain ID   : --
 MAC                : 38ba-7690-1a02
 CCM Receive        : enabled
 Trigger-If-Down    : disabled
 CFM Status         : up
 Alarm Status       : none
 Interface TLV      : --
 Port Status TLV    : --
 Chassis ID         : --
 Management Address : --
 MD Name            : md1
 Level              : 5
 MA Name            : ma2
 RMEP ID            : 2
 VLAN ID            : --
 VSI Name           : --
 L2VC Peer IP       : 1.1.1.9
 L2VC ID            : 103 tagged
 L2VPN Name         : --
 CE ID              : --
 CE Offset          : --
 L2TPV3 Tunnel Name            : --
 L2TPV3 Local Connection Name  : --
 CCC Name           : --
 EVPN-Instance Name : --
 Bridge-domain ID   : --
 MAC                : 38ba-7690-1a02
 CCM Receive        : enabled
 Trigger-If-Down    : disabled
 CFM Status         : up
 Alarm Status       : none
 Interface TLV      : --
 Port Status TLV    : --
 Chassis ID         : --
 Management Address : --
```

## NE5

**NE5 与 NE6恢复连通性检测**

```
[~HUAWEI-md-md1]dis cfm remote-mep md md1 ma ma1
The total number of RMEPs is : 1
The status of RMEPs : 1 up, 0 down, 0 disable
--------------------------------------------------
 MD Name            : md1
 Level              : 6
 MA Name            : ma1
 RMEP ID            : 3
 VLAN ID            : 2
 VSI Name           : --
 L2VC ID            : --
 L2VPN Name         : --
 CE ID              : --
 CE Offset          : --
 L2TPV3 Tunnel Name            : --
 L2TPV3 Local Connection Name  : --
 CCC Name           : --
 EVPN-Instance Name : --
 Bridge-domain ID   : --
 MAC                : 707b-e83d-497f
 CCM Receive        : enabled
 Trigger-If-Down    : disabled
 CFM Status         : up
 Alarm Status       : none
 Interface TLV      : --
 Port Status TLV    : --
 Chassis ID         : --
 Management Address : --
```

# ac侧子接口配置 ais 告警抑制

**一旦链路有故障会往反方向发送指定等级和vlan范围的AIS报文**

## NE3

cfm md md1 
 ma ma1
  ais enable
  ais level 6
  ais vlan vid 2 to 3 mep 2
  ais vlan pe-vid 2 ce-vid 1 mep 2
  undo mep ccm-send mep-id 2 enable
 ma ma2
  ais enable
  ais level 7
  ais vlan vid 3 mep 2
  undo mep ccm-send mep-id 2 enable
commit

## NE5

cfm md md1 
 ma ma1
  ais enable
  ais suppress-alarm
commit

## 抓取报文

**NE5 1/0/1到 AR3 中间链路无AIS报文， NE5 1/0/2 到 AR5 链路中间有level为7的 AIS 报文，验证AIS报文同样遵循 meg 等级穿透**

0000   01 80 c2 00 00 37 38 ba 76 90 1a 02 89 02 e0 21
0010   04 00 00

# 问题

## 拓扑

**实验拓扑是否符合真实场景，有哪些地方需要修改**

## 维护域

**实际应用场景中各个等级有多少个维护域，具体是如何部署配置的**

**业务流量是否会根据优先级进行分类，每个优先级是否也需要各自设置一个维护域**

## 维护中间点

**由实验看来，伪线ac侧的MIP可用于回复环回测试，实际业务场景中是否也会用得到该功能**

**若需要维护中间点,链路跟踪是如何实现的**

## 告警抑制

**ais的报文都是发往客户侧，在伪线ac侧是否需要接收ais报文并且处理**

**ais的报文经过的设备是否也会抑制告警，还是只抑制指定等级维护域中的告警**

**如果只抑制指定等级维护域中的告警，告警抑制的发包参数是由客户配置还是运营商指定**

## 联动

**是否存在与其他模块联动的情景，如bfd session(手册中搜索oam-bind)**

