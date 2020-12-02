#include <boost/algorithm/string.hpp> 
#include <locale> 
#include <iostream> 
#include <clocale> 

int main() 
{ 
  std::string s = "aeiou"; 
  std::cout << boost::algorithm::to_upper_copy(s) << std::endl; 
} 
