# 概述  

Boost.Bind 可替换来自C++标准的著名的 std::bind1st() 和 std::bind2nd() 函数，而 Boost.Function 则提供了一个用于封装函数指针的类。 最后，Boost.Lambda 则引入了一种创建匿名函数的方法。  

## Boost.Bind  

Boost.Bind 是这样的一个库，它简化了由C++标准中的 std::bind1st() 和 std::bind2nd() 模板函数所提供的一个机制：将这些函数与几乎不限数量的参数一起使用，就可以得到指定签名的函数。  

### boost_bind_01.cpp

象 add() 这样的函数不再需要为了要用于 std::for_each() 而转换为函数对象。 使用 boost::bind()，这个函数可以忽略其第一个参数而使用。  

因为 add() 函数要求两个参数，两个参数都必须传递给 boost::bind()。 第一个参数是常数值10，而第二个参数则是一个怪异的 _1。  

_1 被称为占位符(placeholder)，定义于 Boost.Bind。 除了 _1，Boost.Bind 还定义了 _2 和 _3。 通过使用这些占位符，boost::bind() 可以变为一元、二元或三元的函数。 对于 _1, boost::bind() 变成了一个一元函数 - 即只要求一个参数的函数。 这是必需的，因为 std::for_each() 正是要求一个一元函数作为其第三个参数。  

### boost_bind_02.cpp

因为使用了两个占位符 _1 和 _2，所以 boost::bind() 定义了一个二元函数。 std::sort() 算法以容器 v 的两个元素来调用该函数，并根据返回值来对容器进行排序。 基于 compare() 函数的定义，容器将被按降序排列。  

但是，由于 compare() 本身就是一个二元函数，所以使用 boost::bind() 确是多余的。 

## Boost.Ref

Boost.Ref 通常与 Boost.Bind 一起使用，当要用于 boost::bind() 的函数带有至少一个引用参数时，Boost.Ref 就很重要了。 由于 boost::bind() 会复制它的参数，所以引用必须特别处理。  

## Boost.Function

封装函数指针，Boost.Function 提供了一个名为 boost::function 的类。  

如果 f 未赋予一个函数而被调用，则会抛出一个 boost::bad_function_call 异常。  

### boost_function_01.cpp

例子定义了一个指针 f，它可以指向某个接受一个类型为 const char* 的参数且返回一个类型为 int 的值的函数。 定义完成后，匹配此签名的函数均可赋值给这个指针。  

## Boost.Lambda

匿名函数 - 又称为 lambda 函数 - 已经在多种编程语言中存在，但 C++ 除外。 不过在 Boost.Lambda 库的帮助下，现在在 C++ 应用中也可以使用它们了。  


