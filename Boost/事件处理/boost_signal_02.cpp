#include <boost/signals2.hpp> 
#include <iostream> 

void func1() 
{ 
  std::cout << "Hello" << std::flush; 
} 

void func2() 
{ 
  std::cout << ", world!" << std::endl; 
} 

int main() 
{ 
  boost::signals2::signal<void ()> s; 
  s.connect(func2);
  s.connect(1, func2);
  s.connect(0, func1);
  s.connect(func2);
  std::cout << s.num_slots() << std::endl;
  if (!s.empty()) s();
  s.disconnect_all_slots();
  s.connect(func2);
  s.connect(0, func1);
  s.disconnect(func1);
  std::cout << s.num_slots() << std::endl;
  if (!s.empty()) s();
  return 0; 
} 
