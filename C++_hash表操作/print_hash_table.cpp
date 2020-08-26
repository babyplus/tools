#include <cstdio>
#include <string>
#include <unordered_map>

#define _HASH_SEARCH_START(table, field, value, result) \
	do {\
		auto field = table.find(value); \
		std::string temp = value;\
		if ( field == table.end() ) printf("search: " #field "(\"%s\") in " #table " >>> no match!\n",  temp.c_str()); \
		else { \
		auto& result = field->second; do  
#define _HASH_SEARCH_END while(0);}}while(0);
	
using namespace std;

static void hash_print(std::unordered_map<std::string, int> hash_table, int& tab) {
    int _tab = 4 * tab++;
    for ( auto it = hash_table.begin(); it != hash_table.end(); ++it ) {
        auto _values = it->second;
        printf("%*s{\"%s\": %d}\n", 4 + _tab, "", it->first.c_str(), it->second);
    }
    tab -= 1;
}

template <typename T>
static void hash_print(T hash_table, int& tab) {
    for ( auto it = hash_table.begin(); it != hash_table.end(); ++it ) {
        int _tab = 4 * tab++;
        printf("%*s\"%s\":\n", _tab, "", it->first.c_str());
        auto next = it->second;
        hash_print(next, tab);
        tab -= 1;
    }
}

template <typename T>
static void hash_print(T hash_table) {
    int tab = 0;
    hash_print(hash_table, tab);
}


int main() {
	std::unordered_map<std::string, std::unordered_map<std::string, std::unordered_map<std::string, int>>> hashTable;
	hashTable = 
	{
		{"$meg_48b",
			{
				{"$mep_id",
					{
						{"$type", 1}
					}
				}
			}
		},
		{"$$meg_48b",
			{
				{"$$mep_id",
					{
						{"$$type", 2}
					}
				},
				{"$$$mep_id",
					{
						{"$$$type", 3},
						{"$$$$type", 4}
					}
				}
			}
		}
	};
	hash_print(hashTable);
	return 0;
}

