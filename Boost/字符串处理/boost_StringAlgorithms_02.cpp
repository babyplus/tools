#include <boost/algorithm/string.hpp> 
#include <locale> 
#include <iostream> 

int main() 
{ 
  std::string s = "aaeioueiouaeiou"; 
  boost::iterator_range<std::string::iterator> r = boost::algorithm::find_first(s, "Boris"); 
  std::cout << r << std::endl; 
  r = boost::algorithm::find_first(s, "io"); 
  std::cout << r << std::endl; 
  r = boost::algorithm::find_first(s, "dio"); 
  std::cout << r << std::endl; 
} 
