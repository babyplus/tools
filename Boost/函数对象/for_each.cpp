#include <iostream> 
#include <vector> 
#include <algorithm> 
#include <cstdio>

void print(int i) 
{
       printf("%x", i);	
} 

int main() 
{ 
	std::vector<int> v; 
	v.push_back(1); 
	v.push_back(3); 
	v.push_back(2); 
	std::for_each(v.begin(), v.end(), print);
	printf("\n");
	return 0; 
} 
