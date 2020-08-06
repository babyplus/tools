# OAM

## 场景相关

### 下发

#### ma视图

##### map

  mpls           MPLS Multiprotocol Label Switching configuration information
  vlan           Virtual LAN

###### mpls

l2vc  Layer 2 virtual circuit over MPLS

####### l2vc

  A.B.C.D  The IP address of target PE
  String   The name of layer 2 virtual circuit


######## A.B.C.D

######## $l2vc_name

  raw     VLAN tag is stripped
  tagged  VLAN tag is attached

######### raw

 <cr> 

######### tagged

 <cr> 

###### vlan

[1-4094]  VLAN ID

####### $vlan_id

<cr>

### 删除

#### ma视图

##### undo map

  mpls           MPLS Multiprotocol Label Switching configuration information
  vlan           Virtual LAN

###### mpls

l2vc  Layer 2 virtual circuit over MPLS

####### l2vc

 <cr> 

###### vlan

<cr>

## mp相关

### 下发

#### ma视图

##### mep

  ccm-send  Send CCM messages
  mep-id    MEP ID

###### ccm-send

  enable  Send CCM message enable
  mep-id  MEP ID

####### enable

  <cr>  

####### mep-id

  INTEGER<1-8191>  MEP ID

######## $mep-id

  enable  Send CCM message enable

######### enable

  <cr>  

###### mep-id

  INTEGER<1-8191>  MEP ID

####### $mep-id

  alarm      Alarm
  interface  The interface, GE, FE, VE or trunk to be configured with a MEP	

######## alarm

  ais  Alarm Indication Signal
  rdi  Remote Defect Indication

######### ais

  disable  Disable

########## disable

  <cr>  

######### rdi

  disable  Disable

########## disable

  <cr>  

######## interface

######### $interface

  inward   MEP type
  outward  MEP type

########## inward

  <cr>  

########## outward

  <cr>  

##### mip

  create-type  Specify the rule for creating MIPs (default is defer)


###### create-type

  default   MIPs can be created on the port of the MA only when the port does
            not have the MEP of a higher MD-level or the MIP of a lower
            MD-level
  defer     The rule of MIP creation is deferred to the corresponding variable
            in the enclosing maintenance domain
  explicit  MIPs can be created on the port of the MA only when the port meets
            the following conditions: the port does not have the MEP of a
            higher MD-level or the MIP of a lower MD-level; the port has the
            MEP of a lower MD-level
  none      No MIPs can be created on the port of the MA

####### default

  <cr>

####### defer

  <cr>

####### explicit

  <cr>

####### none

  <cr>

##### remote-mep

  ccm-receive  Receive CCM messages
  mep-id       RMEP ID


###### ccm-receive

  enable  CCM-receive enable
  mep-id  RMEP ID

####### enable

  <cr>  

####### mep-id

  INTEGER<1-8191>  MEP ID

######## $mep-id

  enable  Send CCM message enable

######### enable

  <cr>  

###### mep-id

####### $mep-id

  mac   MAC address
  <cr>

######## mac

######### $mac

  <cr>

### 回显

#### show cfm

##### mep

  md    Maintenance domain
  <cr>  


###### md

  STRING<1-43>  MD name

####### $md

  ma    Maintenance association
  <cr>  

######## ma

  STRING<1-43>  Maintenance association name

######### $ma

  mep-id  MEP ID
  <cr>    

########## mep-id

  INTEGER<1-8191>  MEP ID

########### $mep-id

  <cr>  

##### mip

  interface  The interface to be configured with a MIP
  level      MIP level
  <cr>  

###### interface

####### $interface

  <cr>  

###### level

####### $level

  <cr>  

##### remote-mep

  cfm-state  CFM-state
  md         Maintenance domain
  <cr> 

###### cfm-state

  disable  RMEP state disable
  down     RMEP state down
  up       RMEP state up

####### $cfm-state

  <cr> 

###### md

  STRING<1-43>  Maintenance domain name

####### $md

  cfm-state  CFM-state
  ma         Maintenance association
  <cr>  

######## cfm-state

  disable  RMEP state disable
  down     RMEP state down
  up       RMEP state up

######### $cfm-state

  <cr> 

######## ma

  STRING<1-43>  Maintenance association name

######### $ma

  cfm-state  CFM-state
  mep-id     RMEP ID
  <cr>    

########## cfm-state

  disable  RMEP state disable
  down     RMEP state down
  up       RMEP state up

########### $cfm-state

  <cr> 

########## mep-id

  INTEGER<1-8191>  MEP ID

########### $mep-id

  <cr>  

##### mp-info

  <cr> 

### 删除

#### ma视图

##### undo mep

  ccm-send  Send CCM messages
  mep-id    MEP ID


###### mep-id

  INTEGER<1-8191>  MEP ID

####### $mep-id

  alarm      Alarm
  interface  The interface, GE, FE, VE or trunk to be configured with a MEP	
  <cr> 

######## alarm

  ais  Alarm Indication Signal
  rdi  Remote Defect Indication

######### ais

  disable  Disable

########## disable

  <cr>  

######### rdi

  disable  Disable

########## disable

  <cr>  

######## interface

######### $interface

  inward   MEP type
  outward  MEP type

########## inward

  <cr>  

########## outward

  <cr>  

###### ccm-send

  enable  Send CCM message enable
  mep-id  MEP ID

####### enable

  <cr>  

####### mep-id

  INTEGER<1-8191>  MEP ID

######## $mep-id

  enable  Send CCM message enable

######### enable

  <cr>  

##### undo mip

  default   MIPs can be created on the port of the MA only when the port does
            not have the MEP of a higher MD-level or the MIP of a lower
            MD-level
  defer     The rule of MIP creation is deferred to the corresponding variable
            in the enclosing maintenance domain
  explicit  MIPs can be created on the port of the MA only when the port meets
            the following conditions: the port does not have the MEP of a
            higher MD-level or the MIP of a lower MD-level; the port has the
            MEP of a lower MD-level
  none      No MIPs can be created on the port of the MA
  <cr>      


###### create-type

  default   MIPs can be created on the port of the MA only when the port does
            not have the MEP of a higher MD-level or the MIP of a lower
            MD-level
  defer     The rule of MIP creation is deferred to the corresponding variable
            in the enclosing maintenance domain
  explicit  MIPs can be created on the port of the MA only when the port meets
            the following conditions: the port does not have the MEP of a
            higher MD-level or the MIP of a lower MD-level; the port has the
            MEP of a lower MD-level
  none      No MIPs can be created on the port of the MA

####### default

  <cr>

####### defer

  <cr>

####### explicit

  <cr>

####### none

  <cr>

##### undo remote-mep

  ccm-receive  Receive CCM messages
  mep-id       RMEP ID


###### ccm-receive

  enable  CCM-receive enable
  mep-id  RMEP ID

####### enable

  <cr>  

####### mep-id

  INTEGER<1-8191>  MEP ID

######## $mep-id

  enable  Send CCM message enable

######### enable

  <cr>  

###### mep-id

####### $mep-id

  <cr>

## ccm相关

### 下发

#### ma视图

##### ccm

tlv  TLV

###### tlv

  interface-status  Interface Status TLV
  port-status       Port Status TLV
  sender-id         Sender ID TLV

####### $tlv

  <cr>  

##### ccm-interval

  3.3     Interval value 3.3ms
  10      Interval value 10ms 
  20      Interval value 20ms
  30      Interval value 30ms
  50      Interval value 50ms
  100     Interval value 100ms
  1000    Interval value 1s
  10000   Interval value 10s
  60000   Interval value 1min
  600000  Interval value 10min

###### $ccm-interval

<cr>

### 删除

#### ma视图

##### undo ccm 

  tlv  TLV

###### tlv

  interface-status  Interface Status TLV
  port-status       Port Status TLV
  sender-id         Sender ID TLV

####### $tlv

  <cr>  

##### undo ccm-interval

  <cr>  

## meg相关

### 下发

ma + md 长度不超过43个字节

#### 系统视图

##### cfm md

  STRING<1-43>  Maintenance domain name

###### $md_name

  format  MD name format (default is no-md-name)
  level   MD level (default is 0)
  <cr>    

####### format

no-md-name   No MD name present
string       ASCII string

######## undo ccm

  level  MD level (default is 0)
  <cr> 

######### level

  INTEGER<0-7>  MD level

########## $level

 <cr>

######## string

  STRING<1-43>  MD format name

######### $md_name

  level  MD level (default is 0)
  <cr>  

########## level

  INTEGER<0-7>  MD level

########### $level

 <cr>

####### level

Unsigned integer

######## $level

<cr>

#### md视图

##### ma

  STRING<1-43>  Maintenance association name

###### $ma_name

  format  MA name format (default is icc-based)
  <cr>    

####### format

  icc-based  ITU carrier code
  string     ASCII string

######## icc-based

  STRING<1-13>  MA format name

######### $ma_name

<cr>

######## string

  STRING<1-43>  MA format name

######### $ma_name

<cr>

#### ma视图

##### packet-priority

  INTEGER<0-7>  Priority value (7 is the highest)

###### $packet-priority

<cr>

### 回显

#### show cfm

  ma          Maintenance association
  md          Maintenance domain
  mep         Maintenance association End Point
  mip         Maintenance domain Intermediate Point
  mp-info     MP information
  remote-mep  Remote MEP
  statistics  Statistics information

##### md

  STRING<1-43>  MD name
  <cr>          

###### $md_name

  <cr>          

##### ma

  md    Maintenance domain
  <cr> 

###### md

  STRING<1-43>  MD name

####### $md_name

  ma    Maintenance association
  <cr>  

######## ma

  STRING<1-43>  MA name	

######### $ma_name

  <cr>  

### 删除

#### 系统视图

##### undo cfm md

  STRING<1-43>  Maintenance domain name
  <cr>   

###### $md_name

  <cr>  

#### md视图

##### undo ma

  STRING<1-43>  Maintenance association name
  <cr>      

###### $ma_name

  <cr>  

#### ma视图

##### undo packet-priority

  <cr>  

## 测试案例

### 下发

#### ma视图

##### test-id

  INTEGER<1-4294967295>  Test ID

###### $test-id

  mep  Maintenance association End Point

####### mep

  INTEGER<1-8191>  MEP ID

######## $mep_id

  8021p        Specify the value of 802.1p
  description  Configures the description of test instance.
  mac          MAC address
  peer-ip      Specify the peer IP address
  remote-mep   Remote MEP
  <cr>        

######### 8021p

  INTEGER<0-7>  Value of 802.1p

########## $8021p

  description  Configures the description of test instance.
  <cr>   

########### description

  STRING<1-63>  Description of Test Instance


############ $description

  <cr>  

######### remote-mep

  INTEGER<1-8191>  RMEP ID

########## $remote-mep

  8021p        Specify the value of 802.1p
  description  Configures the description of test instance.
  <cr>         


########### 8021p

  INTEGER<0-7>  Value of 802.1p

############ $8021p

  description  Configures the description of test instance.
  <cr>   

############# description

  STRING<1-63>  Description of Test Instance


############## $description

  <cr>  

######### description

  STRING<1-63>  Description of Test Instance


########## $description

  <cr>  

######### peer-ip

  X.X.X.X  The peer IP address

########## $peer-ip

  description  Configures the description of test instance.
  vc-id        Specify VC ID
  <cr>         

########### vc-id

  INTEGER<1-4294967295>  VC ID

############ $vc-id

  description  Configures the description of test instance.
  <cr>  

############# description

  STRING<1-63>  Description of Test Instance


############## $description

  <cr>  

########### description

  STRING<1-63>  Description of Test Instance


############ $description

  <cr>  

######### mac

 H-H-H  MAC address

########## $mac

  8021p        Specify the value of 802.1p
  description  Configures the description of test instance.
  peer-ip      Specify the peer IP address
  <cr>    

########### 8021p

  INTEGER<0-7>  Value of 802.1p

############ $8021p

  description  Configures the description of test instance.
  <cr>   

############# description

  STRING<1-63>  Description of Test Instance


############## $description

  <cr>  

########### description

  STRING<1-63>  Description of Test Instance


############ $description

  <cr>  

########### peer-ip

  X.X.X.X  The peer IP address

############ $peer-ip

  description  Configures the description of test instance.
  vc-id        Specify VC ID
  <cr>         

############# vc-id

  INTEGER<1-4294967295>  VC ID

############## $vc-id

  description  Configures the description of test instance.
  <cr>  

############### $description

  STRING<1-63>  Description of Test Instance


################ description

  <cr>  

############# description

  STRING<1-63>  Description of Test Instance


############## $description 

  <cr>  

### 删除

#### ma视图

##### undo test-id

###### $test-id

  <cr>  

## 丢包测试

### 下发

#### ma视图

##### loss-measure

  dual-ended              Dual-ended
  single-ended            Single-ended
  single-ended-synthetic  Single-ended synthetic

###### single-ended

  continual               Continual measure
  local-ratio-threshold   Specify the threshold value of local loss ratio
  receive                 Enable the function of receiving packets
  remote-ratio-threshold  Specify the threshold value of remote loss ratio
  send                    Enable the function of sending packets

####### continual

  send  Enable the function of sending packets

######## send

  test-id  Test ID

######### test-id

  INTEGER<1-4294967295>  Test ID

########## $test-id

  interval  Interval of sending single-ended frame loss measurement packet	

########### interval

  1000   Interval value 1s
  10000  Interval value 10s
  30000  Interval value 30s
  60000  Interval value 60s

############ $interval

  period  Specify the measurement duration
  <cr>    

############# period

  INTEGER<1-65535>  The value of measurement duration, the unit is second, and
                    the default is 900

############## $period

  <cr>   

####### send

  send  Enable the function of sending packets

######## test-id

 INTEGER<1-4294967295>  Test ID

######### $test-id

  interval  Interval of sending single-ended frame loss measurement packet

########## interval

  1000   Interval value 1s
  10000  Interval value 10s

########### $interval

  count  Count of single-ended frame loss measurement

############ count

  INTEGER<1-60>  Specify the count (1-60)

############# $count

  <cr>   

####### local-ratio-threshold

  mep      Maintenance association End Point
  test-id  Test ID

######## mep

  INTEGER<1-8191>  MEP ID

######### $mep

  upper-limit  Specify the upper limit value

########## upper-limit

  STRING<1-8>  The trigger-alarm threshold value(xxx.xxxx)%

########### $upper-limit

  lower-limit  Specify the lower limit value

############ lower-limit

  STRING<1-8>  The clear-alarm threshold value(xxx.xxxx)%


############# $lower-limit

  8021p  Specify the value of 802.1p
  <cr>   

############## 8021p

  INTEGER<0-7>  Value of 802.1p

############### $8021p

  <cr>   

######## test-id

  INTEGER<1-4294967295>  Test ID

######### $test-id

  upper-limit  Specify the upper limit value

########## upper-limit

  STRING<1-8>  The trigger-alarm threshold value(xxx.xxxx)%

########### $upper-limit

  lower-limit  Specify the lower limit value

############ lower-limit

  STRING<1-8>  The clear-alarm threshold value(xxx.xxxx)%


############# $lower-limit

  <cr>   

####### remote-ratio-threshold

######## mep

  INTEGER<1-8191>  MEP ID

######### $mep

  upper-limit  Specify the upper limit value

########## upper-limit

  STRING<1-8>  The trigger-alarm threshold value(xxx.xxxx)%

########### $upper-limit

  lower-limit  Specify the lower limit value

############ lower-limit

  STRING<1-8>  The clear-alarm threshold value(xxx.xxxx)%


############# $lower-limit

  8021p  Specify the value of 802.1p
  <cr>   

############## 8021p

  INTEGER<0-7>  Value of 802.1p

############### $8021p

  <cr>   

######## test-id

  INTEGER<1-4294967295>  Test ID

######### $test-id

  upper-limit  Specify the upper limit value

########## upper-limit

  STRING<1-8>  The trigger-alarm threshold value(xxx.xxxx)%

########### $upper-limit

  lower-limit  Specify the lower limit value

############ lower-limit

  STRING<1-8>  The clear-alarm threshold value(xxx.xxxx)%


############# $lower-limit

  <cr>   

####### receive

  test-id  Test ID

######## test-id

  INTEGER<1-4294967295>  Test ID

######### $test-id

  <cr> 

###### dual-ended

  continual               Continual measure
  local-ratio-threshold   Specify the threshold value of local loss ratio
  remote-ratio-threshold  Specify the threshold value of remote loss ratio

####### continual

  send  Enable the function of sending packets

######## send

  test-id  Test ID

######### test-id

  INTEGER<1-4294967295>  Test ID

########## $test-id

  interval  Interval of sending single-ended frame loss measurement packet	

####### local-ratio-threshold

  mep  Maintenance association End Point

######## mep

  INTEGER<1-8191>  MEP ID

######### $mep

########## upper-limit

  STRING<1-8>  The trigger-alarm threshold value(xxx.xxxx)%

########### $upper-limit

  lower-limit  Specify the lower limit value

############ lower-limit

  STRING<1-8>  The clear-alarm threshold value(xxx.xxxx)%


############# $lower-limit

  <cr>   

####### remote-ratio-threshold

######## mep

  INTEGER<1-8191>  MEP ID

######### $mep

########## upper-limit

  STRING<1-8>  The trigger-alarm threshold value(xxx.xxxx)%

########### $upper-limit

  lower-limit  Specify the lower limit value

############ lower-limit

  STRING<1-8>  The clear-alarm threshold value(xxx.xxxx)%


############# $lower-limit

  <cr>   

###### single-ended-synthetic

  continual               Continual measure
  local-ratio-threshold   Specify the threshold value of local loss ratio
  receive                 Enable the function of receiving packets
  remote-ratio-threshold  Specify the threshold value of local loss ratio
  send                    Enable the function of sending packets

####### TBD

### 查看

#### show y1731

  eth-bn          Ethernet bandwidth notification function
  eth-test        Ethernet Test Signal
  period-data     Show the period statistics
  statistic-type  Specify the statistic type
  threshold-info  Specify the threshold information

##### eth-bn

###### TBD

##### eth-test

###### TBD 

##### period-data

###### TBD

##### statistic-type

  dual-loss              Dual loss
  eth-test               Ethernet Test Signal
  oneway-delay           One-way delay
  single-loss            Single loss
  single-synthetic-loss  Single synthetic loss
  twoway-delay           Two-way delay

###### single-loss

  count    Count
  test-id  Test ID
  <cr>    

####### count

  INTEGER<1-60>  Count value

######## $count

  <cr>  

####### test-id

  INTEGER<1-4294967295>  Test ID

######## $test-id

  count  Count
  <cr>   

######### count

  INTEGER<1-60>  Count value

########## $count

  <cr>  

###### dual-loss

  count    Count
  test-id  Test ID
  <cr>    

####### count

  INTEGER<1-60>  Count value

######## $count

  <cr>  

####### test-id

  INTEGER<1-4294967295>  Test ID

######## $test-id

  count  Count
  <cr>   

######### count

  INTEGER<1-60>  Count value

########## $count

  <cr>  

##### threshold-info

  dualloss-localratio     Specify the threshold information of dual-ended frame
                          local loss measurement
  dualloss-remoteratio    Specify the threshold information of dual-ended frame
                          remote loss measurement
  md                      Maintenance domain
  onedelay-variation      Specify the threshold information of one-way frame
                          delay variation
  oneway-delay            Specify the threshold information of one-way frame
                          delay
  singleloss-localratio   Specify the threshold information of single-ended
                          frame local loss measurement
  singleloss-remoteratio  Specify the threshold information of single-ended
                          frame remote loss measurement
  twodelay-variation      Specify the threshold information of two-way frame
                          delay variation
  twoway-delay            Specify the threshold information of two-way frame
                          delay
in append mode
  <cr> 

###### md

  STRING<1-43>  Maintenance domain name

####### $md

  ma  Maintenance association

######## ma

  STRING<1-43>  Maintenance association name

######### $ma

  mep-id  MEP ID

########## mep

  INTEGER<1-8191>  MEP ID

########### $mep

  <cr>  

###### dualloss-localratio

####### md

  STRING<1-43>  Maintenance domain name

######## $md

  ma  Maintenance association

######### ma

  STRING<1-43>  Maintenance association name

########## $ma

  mep-id  MEP ID

########### mep

  INTEGER<1-8191>  MEP ID

############ $mep

  <cr>  

###### dualloss-remoteratio

####### md

  STRING<1-43>  Maintenance domain name

######## $md

  ma  Maintenance association

######### ma

  STRING<1-43>  Maintenance association name

########## $ma

  mep-id  MEP ID

########### mep

  INTEGER<1-8191>  MEP ID

############ $mep

  <cr>  

###### singleloss-localratio

####### md

  STRING<1-43>  Maintenance domain name

######## $md

  ma  Maintenance association

######### ma

  STRING<1-43>  Maintenance association name

########## $ma

  mep-id  MEP ID

########### mep

  INTEGER<1-8191>  MEP ID

############ $mep

  <cr>  

###### singleloss-remoteratio

####### md

  STRING<1-43>  Maintenance domain name

######## $md

  ma  Maintenance association

######### ma

  STRING<1-43>  Maintenance association name

########## $ma

  mep-id  MEP ID

########### mep

  INTEGER<1-8191>  MEP ID

############ $mep

  <cr>  

### 删除

#### ma视图

##### undo loss-measure

  dual-ended              Dual-ended
  single-ended            Single-ended
  single-ended-synthetic  Single-ended synthetic

###### single-ended

  continual               Continual measure
  local-ratio-threshold   Specify the threshold value of local loss ratio
  receive                 Enable the function of receiving packets
  remote-ratio-threshold  Specify the threshold value of remote loss ratio


####### continual

  send  Enable the function of sending packets

######## send

  test-id  Test ID
  <cr> 

######### test-id

  INTEGER<1-4294967295>  Test ID

########## $test-id

  <cr>

####### receieve

  test-id  Test ID
  <cr>     

######## test-id

  INTEGER<1-4294967295>  Test ID

######### $test-id

  <cr>

####### local-ratio-threshold

  mep      Maintenance association End Point
  test-id  Test ID

######## mep

  INTEGER<1-8191>  MEP ID


######### $mep

  8021p        Specify the value of 802.1p
  upper-limit  Specify the upper limit value
  <cr>     

########## upper-limit

  STRING<1-8>  The trigger-alarm threshold value(xxx.xxxx)%

########### $upper-limit

  lower-limit  Specify the lower limit value

############ lower-limit

  STRING<1-8>  The clear-alarm threshold value(xxx.xxxx)%


############# $lower-limit

  <cr>

########## 8021p

  INTEGER<0-7>  Value of 802.1p


########### $8021p

  <cr>  

######## test-id

  INTEGER<1-4294967295>  Test ID


######### $test-id

  upper-limit  Specify the upper limit value
  <cr>

########## upper-limit

  STRING<1-8>  The trigger-alarm threshold value(xxx.xxxx)%

########### $upper-limit

  lower-limit  Specify the lower limit value

############ lower-limit

  STRING<1-8>  The clear-alarm threshold value(xxx.xxxx)%


############# $lower-limit

  <cr>

####### remote-ratio-threshold

  mep      Maintenance association End Point
  test-id  Test ID

######## mep

  INTEGER<1-8191>  MEP ID


######### $mep

  8021p        Specify the value of 802.1p
  upper-limit  Specify the upper limit value
  <cr>     

########## upper-limit

  STRING<1-8>  The trigger-alarm threshold value(xxx.xxxx)%

########### $upper-limit

  lower-limit  Specify the lower limit value

############ lower-limit

  STRING<1-8>  The clear-alarm threshold value(xxx.xxxx)%


############# $lower-limit

  <cr>

########## 8021p

  INTEGER<0-7>  Value of 802.1p


########### $8021p

  <cr>  

######## test-id

  INTEGER<1-4294967295>  Test ID


######### $test-id

  upper-limit  Specify the upper limit value
  <cr>

########## upper-limit

  STRING<1-8>  The trigger-alarm threshold value(xxx.xxxx)%

########### $upper-limit

  lower-limit  Specify the lower limit value

############ lower-limit

  STRING<1-8>  The clear-alarm threshold value(xxx.xxxx)%


############# $lower-limit

  <cr>

###### dual-ended

  continual               Continual measure
  local-ratio-threshold   Specify the threshold value of local loss ratio
  remote-ratio-threshold  Specify the threshold value of remote loss ratio

####### continual

  send  Enable the function of sending packets

######## send

  test-id  Test ID
  <cr> 

######### test-id

  INTEGER<1-4294967295>  Test ID

########## $test-id

  <cr>

####### local-ratio-threshold

######## TBD

####### remote-ratio-threshold

######## TBD

###### single-ended-synthetic

  continual               Continual measure
  local-ratio-threshold   Specify the threshold value of local loss ratio
  receive                 Enable the function of receiving packets
  remote-ratio-threshold  Specify the threshold value of remote loss ratio


####### TBD

## 时延测试

### 下发

#### ma视图

##### delay-measure

  one-way  One-way
  two-way  Two-way

###### one-way

  continual            Continual measure
  delay-threshold      Specify the threshold value of frame delay
  receive              Enable the function of receiving packets
  send                 Enable the function of sending packets
  threshold            Frame delay threshold
  variation-threshold  Specify the threshold value of frame delay variation

####### continual

  receive  Enable the function of receiving packets
  send     Enable the function of sending packets

######## receive

  test-id  Test ID

######### test-id

  INTEGER<1-4294967295>  Test ID

########## $test-id

 <cr> 

######## send

  test-id  Test ID

######### test-id

  INTEGER<1-4294967295>  Test ID

########## $test-id

 <cr> 

####### delay-threshold

  mep  Maintenance association End Point	

######## mep

  INTEGER<1-8191>  MEP ID

######### $mep

  upper-limit  Specify the upper limit value


########## upper-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

########### $upper-limit

  lower-limit  Specify the lower limit value

############ lower-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

############# $lower-limit

  8021p  Specify the value of 802.1p
  <cr>  

############## 8021p

  INTEGER<0-7>  Value of 802.1p

############### $8021p

  <cr> 

####### receive

  test-id  Test ID

######## test-id

  INTEGER<1-4294967295>  Test ID

######### $test-id

  <cr>  

####### send

  test-id  Test ID

######## test-id

  INTEGER<1-4294967295>  Test ID

######### $test-id

  interval  Interval of sending one-way frame delay measurement packet

########## interval

  1000   Interval value 1s
  10000  Interval value 10s	

########### $interval

  count  Count of one-way frame delay measurement


############ count

  INTEGER<1-60>  Specify the count (1-60)

############# $count

  <cr>

####### threshold

  INTEGER<1-4294967295>  Frame delay threshold value (Unit: microsecond)

######## $threshold

  <cr>  

####### variation-threshold

  mep  Maintenance association End Point


######## mep

  INTEGER<1-8191>  MEP ID

######### $mep

  upper-limit  Specify the upper limit value

########## upper-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

########### $upper-limit

  lower-limit  Specify the lower limit value


############ lower-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

############# $lower-limit

  8021p  Specify the value of 802.1p
  <cr>

############## 8021p

  INTEGER<0-7>  Value of 802.1p

############### $8021p

  <cr>

###### two-way

  continual            Continual measure
  delay-threshold      Specify the threshold value of frame delay
  receive              Enable the function of receiving packets
  send                 Enable the function of sending packets
  threshold            Frame delay threshold
  variation-threshold  Specify the threshold value of frame delay variation

####### continual

  send     Enable the function of sending packets

######## send

  test-id  Test ID

######### test-id

  INTEGER<1-4294967295>  Test ID

########## $test-id

 <cr> 

####### delay-threshold

  mep      Maintenance association End Point
  test-id  Test ID

######## mep

  INTEGER<1-8191>  MEP ID

######### $mep

########## upper-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

########### $upper-limit

  lower-limit  Specify the lower limit value


############ lower-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

############# $lower-limit

  8021p  Specify the value of 802.1p
  <cr>

############## 8021p

  INTEGER<0-7>  Value of 802.1p

############### $8021p

  <cr>

######## test-id

  INTEGER<1-4294967295>  Test ID

######### $test-id

########## upper-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

########### $upper-limit

  lower-limit  Specify the lower limit value


############ lower-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

############# $lower-limit

  <cr>

####### receive

  test-id  Test ID

######## test-id

  INTEGER<1-4294967295>  Test ID

######### $test-id

  <cr>  

####### send

  test-id  Test ID

######## test-id

  INTEGER<1-4294967295>  Test ID

######### $test-id

  interval  Interval of sending one-way frame delay measurement packet

########## interval

  1000   Interval value 1s
  10000  Interval value 10s	

########### $interval

  count  Count of one-way frame delay measurement


############ count

  INTEGER<1-60>  Specify the count (1-60)

############# $count

  <cr>

####### threshold

  INTEGER<1-4294967295>  Frame delay threshold value (Unit: microsecond)

######## $threshold

  <cr>  

####### variation-threshold

  mep      Maintenance association End Point
  test-id  Test ID

######## mep

  INTEGER<1-8191>  MEP ID

######### $mep

  upper-limit  Specify the upper limit value

########## upper-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

########### $upper-limit

  lower-limit  Specify the lower limit value


############ lower-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

############# $lower-limit

  8021p  Specify the value of 802.1p
  <cr>

############## 8021p

  INTEGER<0-7>  Value of 802.1p

############### $8021p

  <cr>

######## test-id

  INTEGER<1-4294967295>  Test ID

######### $test-id

  upper-limit  Specify the upper limit value

########## upper-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

########### $upper-limit

  lower-limit  Specify the lower limit value


############ lower-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

############# $lower-limit

  <cr>

### 删除

#### ma视图

##### undo delay-measure

  one-way  One-way
  two-way  Two-way

###### one-way

  continual            Continual measure
  delay-threshold      Specify the threshold value of frame delay
  receive              Enable the function of receiving packets
  threshold            Frame delay threshold
  variation-threshold  Specify the threshold value of frame delay variation

####### continual

  receive  Enable the function of receiving packets
  send     Enable the function of sending packets

######## receive

  test-id  Test ID
  <cr>   

######### test-id

  INTEGER<1-4294967295>  Test ID

########## $test-id

  <cr> 

######## send

  test-id  Test ID
  <cr>     

######### test-id

  INTEGER<1-4294967295>  Test ID

########## $test-id

  <cr> 

####### delay-threshold

  mep  Maintenance association End Point

######## mep

 INTEGER<1-8191>  MEP ID

######### $mep

  8021p        Specify the value of 802.1p
  upper-limit  Specify the upper limit value
  <cr>         

########## 8021p

 INTEGER<0-7>  Value of 802.1p

########### $8021p

  <cr>  

########## upper-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

########### $upper-limit

  lower-limit  Specify the lower limit value


############ lower-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

############# $lower-limit

  8021p  Specify the value of 802.1p
  <cr>

############## 8021p

  INTEGER<0-7>  Value of 802.1p

############### $8021p

  <cr>

####### receive

  test-id  Test ID
  <cr>   

######## test-id

######### $test-id

  <cr> 

####### threshold

  <cr> 

####### variation-threshold

  mep  Maintenance association End Point

######## mep

  INTEGER<1-8191>  MEP ID

######### $mep

  upper-limit  Specify the upper limit value

########## upper-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

########### $upper-limit

  lower-limit  Specify the lower limit value


############ lower-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

############# $lower-limit

  8021p  Specify the value of 802.1p
  <cr>

############## 8021p

  INTEGER<0-7>  Value of 802.1p

############### $8021p

  <cr>

###### two-way

####### continual

  receive  Enable the function of receiving packets
  send     Enable the function of sending packets

######## send

  test-id  Test ID
  <cr>     

######### test-id

########## $test-id

  <cr> 

####### receive

  test-id  Test ID
  <cr>   

######## test-id

######### $test-id

  <cr> 

####### threshold

  <cr> 

####### variation-threshold

  mep      Maintenance association End Point
  test-id  Test ID

######## mep

  INTEGER<1-8191>  MEP ID

######### $mep

  8021p        Specify the value of 802.1p
  upper-limit  Specify the upper limit value
  <cr>

########## 8021p

 INTEGER<0-7>  Value of 802.1p

########### $8021p

  <cr>  

########## upper-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

########### $upper-limit

  lower-limit  Specify the lower limit value


############ lower-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

############# $lower-limit

  8021p  Specify the value of 802.1p
  <cr>

############## 8021p

  INTEGER<0-7>  Value of 802.1p

############### $8021p

  <cr>

######## test-id

  INTEGER<1-4294967295>  Test ID

######### $test-id

########## upper-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

########### $upper-limit

  lower-limit  Specify the lower limit value


############ lower-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

############# $lower-limit

  <cr>

####### delay-threshold

  mep      Maintenance association End Point
  test-id  Test ID

######## mep

  INTEGER<1-8191>  MEP ID

######### $mep

  8021p        Specify the value of 802.1p
  upper-limit  Specify the upper limit value
  <cr>

########## 8021p

 INTEGER<0-7>  Value of 802.1p

########### $8021p

  <cr>  

########## upper-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

########### $upper-limit

  lower-limit  Specify the lower limit value


############ lower-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

############# $lower-limit

  8021p  Specify the value of 802.1p
  <cr>

############## 8021p

  INTEGER<0-7>  Value of 802.1p

############### $8021p

  <cr>

######## test-id

  INTEGER<1-4294967295>  Test ID

######### $test-id

########## upper-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

########### $upper-limit

  lower-limit  Specify the lower limit value


############ lower-limit

  INTEGER<0-4294967295>  The trigger-alarm threshold value (microsecond)

############# $lower-limit

  <cr>

### 查看

#### show y1731

  eth-bn          Ethernet bandwidth notification function
  eth-test        Ethernet Test Signal
  period-data     Show the period statistics
  statistic-type  Specify the statistic type
  threshold-info  Specify the threshold information

##### eth-bn

###### TBD

##### eth-test

###### TBD

##### period-data

###### TBD

##### statistic-type

  dual-loss              Dual loss
  eth-test               Ethernet Test Signal
  oneway-delay           One-way delay
  single-loss            Single loss
  single-synthetic-loss  Single synthetic loss
  twoway-delay           Two-way delay

###### oneway-delay

  count    Count
  test-id  Test ID
  <cr>    

####### count

  INTEGER<1-60>  Count value

######## $count

  <cr>  

####### test-id

######## $test-id

  count  Count
  <cr>   

######### count

  INTEGER<1-60>  Count value

########## $count

  <cr>  

###### twoway-delay

  count    Count
  test-id  Test ID
  <cr>    

####### count

  INTEGER<1-60>  Count value

######## $count

  <cr>  

####### test-id

######## $test-id

  count  Count
  <cr>   

######### count

  INTEGER<1-60>  Count value

########## $count

  <cr>  

##### threshold-info

  dualloss-localratio     Specify the threshold information of dual-ended frame
                          local loss measurement
  dualloss-remoteratio    Specify the threshold information of dual-ended frame
                          remote loss measurement
  md                      Maintenance domain
  onedelay-variation      Specify the threshold information of one-way frame
                          delay variation
  oneway-delay            Specify the threshold information of one-way frame
                          delay
  singleloss-localratio   Specify the threshold information of single-ended
                          frame local loss measurement
  singleloss-remoteratio  Specify the threshold information of single-ended
                          frame remote loss measurement
  twodelay-variation      Specify the threshold information of two-way frame
                          delay variation
  twoway-delay            Specify the threshold information of two-way frame
                          delay
in append mode
  <cr> 

###### md

  STRING<1-43>  Maintenance domain name

####### $md

  ma  Maintenance association

######## ma

  STRING<1-43>  Maintenance association name

######### $ma

  mep-id  MEP ID

########## mep

  INTEGER<1-8191>  MEP ID

########### $mep

  <cr>  

###### onedelay-variation

####### md

  STRING<1-43>  Maintenance domain name

######## $md

  ma  Maintenance association

######### ma

  STRING<1-43>  Maintenance association name

########## $ma

  mep-id  MEP ID

########### mep

  INTEGER<1-8191>  MEP ID

############ $mep

  <cr>  

###### oneway-delay

####### md

  STRING<1-43>  Maintenance domain name

######## $md

  ma  Maintenance association

######### ma

  STRING<1-43>  Maintenance association name

########## $ma

  mep-id  MEP ID

########### mep

  INTEGER<1-8191>  MEP ID

############ $mep

  <cr>  

###### twodelay-variation

####### md

  STRING<1-43>  Maintenance domain name

######## $md

  ma  Maintenance association

######### ma

  STRING<1-43>  Maintenance association name

########## $ma

  mep-id  MEP ID

########### mep

  INTEGER<1-8191>  MEP ID

############ $mep

  <cr>  

###### twoway-delay

####### md

  STRING<1-43>  Maintenance domain name

######## $md

  ma  Maintenance association

######### ma

  STRING<1-43>  Maintenance association name

########## $ma

  mep-id  MEP ID

########### mep

  INTEGER<1-8191>  MEP ID

############ $mep

  <cr>  

## 告警抑制

### 下发

#### ma视图

##### ais

  enable          AIS enable
  interval        AIS interval (default is 1s)
    level           AIS message level
  link-status     Enable sending AIS packets when the link goes down
  suppress-alarm  AIS suppress alarm enable
  vlan            Set a VLAN or VLAN range for AIS


###### enable

###### level

  INTEGER<0-7>  Value of AIS message level

####### $level

  <cr>  

###### interval

  1   Value of AIS message interval, 1 second
  60  Value of AIS message interval, 60 seconds

####### $interval

  <cr>  

###### link-status

  interface  Specify the interface

####### interface

######## $interface

  <cr>  

###### suppress-alarm

  <cr>  

###### vlan

  pe-vid  Set PE VLAN
  vid     Set a VLAN

####### pe-vid

  INTEGER<1-4094>  The value of PE VLAN

######## $pe-vid

  ce-vid  Set CE VLAN

######### ce-vid

  INTEGER<1-4094>  The low value of CE VLAN

########## $ce-vid

  INTEGER<1-4094>  The low value of CE VLAN
  mep              Maintenance association End Point
  to               Set the range of CE VLAN

########### mep

  INTEGER<1-8191>  MEP ID

############ $mep

  <cr>  

####### vid

  INTEGER<1-4094>  The value of VLAN

######## $vid

  INTEGER<1-4094>  The low value of CE VLAN
  mep              Maintenance association End Point
  to               Set the range of CE VLAN

######### mep

  INTEGER<1-8191>  MEP ID

########## $mep

  <cr>  

### 删除

#### ma视图

##### undo ais

  enable          AIS enable
  interval        AIS interval (default is 1s)
  level           AIS message level
  link-status     Enable sending AIS packets when the link goes down
  suppress-alarm  AIS suppress alarm enable
  vlan            Set a VLAN or VLAN range for AIS


###### enable

  <cr>  

###### level

  INTEGER<0-7>  Value of AIS message level

####### $level

  <cr>  

###### interval

  1   Value of AIS message interval, 1 second
  60  Value of AIS message interval, 60 seconds

####### $interval

  <cr>  

###### link-status

  interface  Specify the interface

####### interface

######## $interface

  <cr>  

###### suppress-alarm

  <cr>  

###### vlan

  mep     Maintenance association End Point
  pe-vid  Set PE VLAN
  vid     Set a VLAN

####### mep

  INTEGER<1-8191>  MEP ID

######## $mep

  <cr>  

####### pe-vid

  INTEGER<1-4094>  The value of PE VLAN

######## $pe-vid

  ce-vid  Set CE VLAN

######### ce-vid

  INTEGER<1-4094>  The low value of CE VLAN

########## $ce-vid

  INTEGER<1-4094>  The low value of CE VLAN
  mep              Maintenance association End Point
  to               Set the range of CE VLAN

########### mep

  INTEGER<1-8191>  MEP ID

############ $mep

  <cr>  

####### vid

  INTEGER<1-4094>  The value of VLAN

######## $vid

  INTEGER<1-4094>  The low value of CE VLAN
  mep              Maintenance association End Point
  to               Set the range of CE VLAN

######### mep

  INTEGER<1-8191>  MEP ID

########## $mep

  <cr>  

## 告警

### EOAM1AG 

#### 1

##### LOC

在CCM超时时间内，MEP没有从对等MEP处接收到任何的CCM报文。

##### MISMERGE

端口上收到的CCM报文中的MD名称或者MA名称不一致。

##### UNEXPECTEDMEGLEVEL

端口上收到的CCM报文为MEG级别泄露的报文。

#### 2

##### EXCEPTIONALMACSTATUS

本地配置的RMEP在检测时间内收到对应的正确的CCM报文，但是报文中携带了TLV信息显示对端的端口状态异常。

##### ETHOAM_CFG_CLOSEPORT

物理接口被ETH OAM关闭。

#### 3

##### RDI

远端OAM实体接收到RDI日志后，通知本端OAM实体。

##### UNEXPECTEDMAC

端口上收到的CCM报文中的MAC地址和本端配置的RMEP绑定的MAC地址不一致。

##### UNEXPECTEDMEP

端口上收到的CCM报文中的MEP ID不在本端配置的RMEP列表内。

##### UNEXPECTEDPERIOD

端口上收到的CCM报文中的报文发包时间间隔和本端OAM实体配置时间间隔不一致。

### Y1731

#### 4 

##### AIS

MEP收到内层MA的MEP发送的AIS报文。

##### ETH_CFM_AISEXCEEDMAXPKTNUM

1秒内整机设备收发AIS报文数目超过最大限制值。

##### hwY1731LckDefect

MEP进入LCK故障状态。
MEP收到内层MA的MEP发送的LCK报文。

##### STATISTIC

Y.1731性能统计结果超过预置的日志上限阈值。

##### VLAN_1DM_EXCEED_THRESHOLD

VLAN场景下的Y.1731单向时延统计并且配置了预期的日志门限，这时如果网络时延超过日志门限时就会产生该日志。

##### VLAN_2DM_EXCEED_THRESHOLD

使能VLAN场景下的Y.1731双向时延统计并且配置了预期的日志门限，这时如果网络时延超过日志门限时就会产生该日志。
