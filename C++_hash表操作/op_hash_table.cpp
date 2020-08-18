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
void _delete(std::unordered_map<std::string, int>& table, std::string key, int result) {table.erase(key);}
void _print(std::unordered_map<std::string, int>& table, std::string key, int result) {printf(">>>>>>>>>>>>>>>>{%s: %d}\n", key.c_str(), result);}
template <typename F, typename T>
void process_entry_in_hash_table(F cb, T& table,  std::string key) {
	_HASH_SEARCH_START(table, field, key, result){
		cb(table, key, result);
	}_HASH_SEARCH_END
}
template <typename F, typename T, typename... Args>
void process_entry_in_hash_table(F cb, T& table, std::string key, Args... args) {
	_HASH_SEARCH_START(table, field, key, result){
		process_entry_in_hash_table(cb, result, args...);
	}_HASH_SEARCH_END
}
int main() {
	std::unordered_map<std::string, std::unordered_map<std::string, std::unordered_map<std::string, int>>> hashTable;
	hashTable = 
	{
		{"$meg_48b",
			{
				{"$mep_id",
					{
						{
							"$type", 1
						}
					}
				}
			}
		}
	};
	process_entry_in_hash_table(_print, hashTable, "$meg_48bxxx", "$mep_id", "$type");
	process_entry_in_hash_table(_print, hashTable, "$meg_48b", "$mep_idxx", "$type");
	process_entry_in_hash_table(_print, hashTable, "$meg_48b", "$mep_id", "$typexxx");
	process_entry_in_hash_table(_print, hashTable, "$meg_48b", "$mep_id", "$type");
	process_entry_in_hash_table(_delete, hashTable, "$meg_48b", "$mep_id", "$type");
	process_entry_in_hash_table(_print, hashTable, "$meg_48b", "$mep_id", "$type");
	return 0;
}

