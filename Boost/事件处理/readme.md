# 概述

一般情况下，任意对象都可以调用基于特定事件的专门函数。严格来说，Boost.Function 库也可以用于事件处理。 不过，Boost.Function 和 Boost.Signals 之间的一个主要区别在于，Boost.Signals 能够将一个以上的事件处理器关联至单个事件。 因此，Boost.Signals 可以更好地支持事件驱动的开发，当需要进行事件处理时，应作为第一选择。  

## Boost.Signals

当对应的信号被发出时，相关联的插槽即被执行。 原则上，你可以把单词 '信号' 和 '插槽' 分别替换为 '事件' 和 '事件处理器'。 不过，由于信号可以在任意给定的时间发出，所以这一概念放弃了 '事件' 的名字。  

因此，Boost.Signals 没有提供任何类似于 '事件' 的类。  

### boost_signal_01.cpp

*/usr/include/boost/signal.hpp:17:4: warning: #warning "Boost.Signals is no longer being maintained and is now deprecated. Please switch to Boost.Signals2. To disable this warning message, define BOOST_SIGNALS_NO_DEPRECATION_WARNING." [-Wcpp]*  

参考其他例子使用Boost.Signals2  

### boost_signal_02.cpp

boost::signal 可以通过反复调用 connect() 方法来把多个函数赋值给单个特定信号。 当该信号被触发时，这些函数被按照之前用 connect() 进行关联时的顺序来执行。  

另外，执行的顺序也可通过 connect() 方法的另一个重载版本来明确指定，该重载版本要求以一个 int 类型的值作为额外的参数。 
