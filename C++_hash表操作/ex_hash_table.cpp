#include <cstdio>
#include <string>
#include <unordered_map>

using namespace std;

template <typename T>
static void hash_print(T hash_table) {
	for ( auto it = hash_table.begin(); it != hash_table.end(); ++it ) {
		printf("\"%s\":\n", it->first.c_str());
		auto meps = it->second;
		for ( auto it = meps.begin(); it != meps.end(); ++it ) {
			printf("    \"%s\":\n", it->first.c_str());
			auto types = it->second;
			for ( auto it = types.begin(); it != types.end(); ++it ) {
				printf("        \"%s\": %d\n", it->first.c_str(), it->second);
			}
		}
	}
}

static void hash_expand(int& table, int ex_table){table = ex_table;}

template <typename T>
static void hash_expand(T& table, T ex_table){
	for ( auto it = ex_table.begin(); it != ex_table.end(); ++it) {
		auto ex_key = it->first;
		auto ex_value = it->second;
		auto field = table.find(ex_key);
		if ( field == table.end() ) table[ex_key] = ex_value;
		else {
			auto& result = field->second;
			hash_expand(result, ex_value);
		} 
	} 
}

int main() {
	std::unordered_map<std::string, std::unordered_map<std::string, std::unordered_map<std::string, int>>> table;
	std::unordered_map<std::string, std::unordered_map<std::string, std::unordered_map<std::string, int>>> ex_table;
	table = 
	{
		{"meg1",
			{
				{"mep_id1",
					{
						{"type1", 1}
					}
				}
			}
		},
		{"meg2",
			{
				{"mep_id2",
					{
						{"type2", 2}
					}
				},
				{"mep_id3",
					{
						{"type3", 3},
						{"type4", 4}
					}
				}
			}
		}
	};
	ex_table = 
	{
		{"meg2",
			{
				{"mep_id3",
					{
						{"type4", 886},
						{"type5", 996}
					}
				},
				{"mep_id_ex",
					{
						{"type4", 886},
						{"type5", 996}
					}
				}
			}
		}
	};

	printf("++++++++++++++++++:\n");
	printf("raw:\n");
	printf("++++++++++++++++++:\n");

	hash_print(table);

	printf("++++++++++++++++++:\n");
	printf("ex:\n");
	printf("++++++++++++++++++:\n");

	hash_print(ex_table);
	hash_expand(table, ex_table);

	printf("++++++++++++++++++:\n");
	printf("result:\n");
	printf("++++++++++++++++++:\n");

	hash_print(table);

	return 0;
}

