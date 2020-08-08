import random
import OTC
from enum import Enum

# 全局变量
global _g_dbg_layer, _g_dbg_level, _g_dbg_info, _g_dbg_list, _g_dbg_dict
_g_dbg_layer = 0
_g_dbg_level = 0
_g_dbg_info = ""
_g_dbg_list = []
_g_dbg_dict = {}


def otc_debug_layer(add=1):
    global _g_dbg_layer
    if add:
        _g_dbg_layer += add
    else:
        _g_dbg_layer -= 1


def otc_debug(info, *info_list, **info_dict):
    if info and 0 == info_list.__len__():
        print("{}otc_debug:: {}".format("    "*_g_dbg_layer, info))
        return
    for e in info_list:
        print("{}otc_debug:: {} {}".format("    "*_g_dbg_layer, info, e))
    for k, v in info_dict:
        print("{}otc_debug:: ({}: {})".format("    "*_g_dbg_layer, k, v))
    pass


def random_OTC(name):
    # 随机生成做市商
    otc_debug("")
    return OTC.OTC(name=name,
                   stock=0,  # 所有做市商初始化有0的库存
                   sell_price=round(random.uniform(1, 1.1), 4),
                   sell_stock=random.randint(0, 10),
                   buy_price=round(random.uniform(1, 1.1), 4),
                   buy_stock=random.randint(10, 20),
                   # risk = round(random.uniform(0.01,0.10),4),
                   risk=round(random.uniform(0.00005, 0.00027), 5),  # 调整范围 2019.7.19
                   property=50
                   )


def init_sell_otc():
    otc_debug("可以调整该10个出让商的 $sell_price(卖价) 和 $stock(存量)")
    otc_list = []
    otc_list.append(OTC.OTC(name='1',
                            stock=2,
                            # sell_price=round(random.uniform(1, 1.2), 3),
                            sell_price=1.0200,
                            # sell_stock=random.randint(1, 10),
                            sell_stock=0,
                            buy_price=0.0,
                            buy_stock=0,
                            risk=round(random.uniform(0.01, 0.10), 4)
                            ))

    otc_list.append(OTC.OTC(name='2',
                            stock=3,
                            # sell_price=round(random.uniform(1, 1.2), 3),
                            sell_price=1.0260,
                            # sell_stock=random.randint(1, 10),
                            sell_stock=0,
                            buy_price=0.0,
                            buy_stock=0,
                            risk=round(random.uniform(0.01, 0.10), 4)
                            ))

    otc_list.append(OTC.OTC(name='3',
                            stock=4,
                            # sell_price=round(random.uniform(1, 1.2), 3),
                            sell_price=1.0280,
                            # sell_stock=random.randint(1, 10),
                            sell_stock=0,
                            buy_price=0.0,
                            buy_stock=0,
                            risk=round(random.uniform(0.01, 0.10), 4)
                            ))

    otc_list.append(OTC.OTC(name='4',
                            stock=7,
                            # sell_price=round(random.uniform(1, 1.2), 3),
                            sell_price=1.0300,
                            # sell_stock=random.randint(1, 10),
                            sell_stock=0,
                            buy_price=0.0,
                            buy_stock=0,
                            risk=round(random.uniform(0.01, 0.10), 4)
                            ))

    otc_list.append(OTC.OTC(name='5',
                            stock=5,
                            # sell_price=round(random.uniform(1, 1.2), 3),
                            sell_price=1.0320,
                            # sell_stock=random.randint(1, 10),
                            sell_stock=0,
                            buy_price=0.0,
                            buy_stock=0,
                            risk=round(random.uniform(0.01, 0.10), 4)
                            ))

    otc_list.append(OTC.OTC(name='6',
                            stock=6,
                            # sell_price=round(random.uniform(1, 1.2), 3),
                            sell_price=1.0340,
                            # sell_stock=random.randint(1, 10),
                            sell_stock=0,
                            buy_price=0.0,
                            buy_stock=0,
                            risk=round(random.uniform(0.01, 0.10), 4)
                            ))

    otc_list.append(OTC.OTC(name='7',
                            stock=3,
                            # sell_price=round(random.uniform(1, 1.2), 3),
                            sell_price=1.0350,
                            # sell_stock=random.randint(1, 10),
                            sell_stock=0,
                            buy_price=0.0,
                            buy_stock=0,
                            risk=round(random.uniform(0.01, 0.10), 4)
                            ))

    otc_list.append(OTC.OTC(name='8',
                            stock=5,
                            # sell_price=round(random.uniform(1, 1.2), 3),
                            sell_price=1.0380,
                            # sell_stock=random.randint(1, 10),
                            sell_stock=0,
                            buy_price=0.0,
                            buy_stock=0,
                            risk=round(random.uniform(0.01, 0.10), 4)
                            ))

    otc_list.append(OTC.OTC(name='9',
                            stock=7,
                            # sell_price=round(random.uniform(1, 1.2), 3),
                            sell_price=1.0400,
                            # sell_stock=random.randint(1, 10),
                            sell_stock=0,
                            buy_price=0.0,
                            buy_stock=0,
                            risk=round(random.uniform(0.01, 0.10), 4)
                            ))

    otc_list.append(OTC.OTC(name='10',
                            stock=8,
                            # sell_price=round(random.uniform(1, 1.2), 3),
                            sell_price=1.0460,
                            # sell_stock=random.randint(1, 10),
                            sell_stock=0,
                            buy_price=0.0,
                            buy_stock=0,
                            risk=round(random.uniform(0.01, 0.10), 4)
                            ))
    otc_debug("该10个出让商的 sell_stock 在 0~$stock 之间随机生成的整数")
    for i in otc_list:
        i.sell_stock = random.randint(1, i.stock)
    return otc_list


if __name__ == '__main__':
    # 每一轮市场的情况都保存在这个快照数据中
    marketSnapshot = []

    # 环境参数设置
    #   官方报价
    official_price = 1.0344

    #   正态分布取标准正态分布μ = 0,σ = 1
    sigma = 1
    Mu = 0
    σ = 1
    μ = 0

    #   市商列表
    otcList = []

    # 代码逻辑

    otc_debug("随机生成67个市商")
    otc_debug_layer(1)

    for i in range(67):
        otcList.append(random_OTC(str(i + 1)))
    for i in otcList:
        _g_dbg_list.append(i.name)
    otc_debug("67个市商的名字:", _g_dbg_list)

    otc_debug_layer(0)

    otc_debug("初始化第一轮市场情况")
    otc_debug_layer(1)

    otc_debug("有10个出让商")
    otc_debug_layer(1)
    sell_list = init_sell_otc()
    otc_debug_layer(0)

    otc_debug("将生成的头10个出让商按照名字匹配赋值到随机生成的67个市商列表中（其实就是前十个）")
    otc_debug_layer(1)
    _index_sell_list = 0
    _g_dbg_list = []
    for i in sell_list:
        _index_otc_list = 0
        for j in otcList:
            if i.name == j.name:
                _g_dbg_list.append(i.name)
                otcList[_index_otc_list] = sell_list[_index_sell_list]
            _index_otc_list += 1
        _index_sell_list += 1
    otc_debug("出让商名字:", _g_dbg_list)
    otc_debug_layer(0)

    otc_debug("除了以上10个做市商会出让以外，其它做市商的出让价格和出让数量调整为0，同时随机生成受让价格和受让库存")
    otc_debug_layer(1)


    otc_debug_layer(0)




    otc_debug_layer(0)
    pass
