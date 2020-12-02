#include <boost/bind.hpp> 
#include <vector> 
#include <algorithm> 

bool compare(int i, int j) 
{ 
  return i > j; 
} 

int main() 
{ 
  std::vector<int> v; 
  v.push_back(1); 
  v.push_back(3); 
  v.push_back(2); 

  std::sort(v.begin(), v.end(), boost::bind(compare, _1, _2));
  for(auto x: v) printf("%x\n", x);
  printf("------\n");
  std::sort(v.begin(), v.end(), boost::bind(compare, _2, _1));
  for(auto x: v) printf("%x\n", x);
  return 0; 
} 
