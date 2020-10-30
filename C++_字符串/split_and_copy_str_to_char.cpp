#include <cstdio>
#include <string>
#include <string.h>
#define CFM_NAME_MAX_LENGTH 43

struct MEPEntry{
	char  md_alias[CFM_NAME_MAX_LENGTH];
	char  ma_alias[CFM_NAME_MAX_LENGTH];
};

int main(void) {
	const std::string alias = "MEP:md1|ma1|1";
	MEPEntry new_entry;
	MEPEntry* entry_ptr = &new_entry;
	std::size_t found0 = alias.find(":");
	std::size_t found1 = alias.find("|");
	std::size_t found2 = alias.find("|", found1+1);
        std::string _md_alias = alias.substr(found0+1,found1-found0-1);
        std::string _ma_alias = alias.substr(found1+1,found2-found1-1);
	memset(entry_ptr->md_alias, 0, CFM_NAME_MAX_LENGTH);
	memset(entry_ptr->ma_alias, 0, CFM_NAME_MAX_LENGTH);
	strncpy(entry_ptr->md_alias, _md_alias.c_str(), _md_alias.length());
	strncpy(entry_ptr->ma_alias, _ma_alias.c_str(), _ma_alias.length());
	printf("  %s  %s\n", entry_ptr->md_alias, entry_ptr->md_alias);
}
