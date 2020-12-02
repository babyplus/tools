#include <boost/algorithm/string.hpp> 
#include <locale> 
#include <iostream> 
#include <vector> 

int main() 
{ 
  std::vector<std::string> v; 
  v.push_back("Boris"); 
  v.push_back("S"); 
  std::cout << boost::algorithm::join(v, " ") << std::endl; 
} 

