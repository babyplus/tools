#include <cstdio>
#include <string.h>

#define _INDEX_MAX 100

static bool _reserve(bool* _index_in_oamp_list, int* index); 
static bool _free(bool* _index_in_oamp_list, int* index);

int main() {
    bool _index_in_oamp_list[_INDEX_MAX];
    memset(_index_in_oamp_list, 0, sizeof(_index_in_oamp_list));
    int index = 0;
    _reserve(_index_in_oamp_list, &index);
    printf("reserve(expecte:0) index: %d; value: ...%d,%d...\n", index, _index_in_oamp_list[index], _index_in_oamp_list[index+1]);
    memset(_index_in_oamp_list, 1, 39);
    _reserve(_index_in_oamp_list, &index);
    printf("reserve(expecte:39) index: %d; value: ...%d,%d...\n", index, _index_in_oamp_list[index], _index_in_oamp_list[index+1]);
    _free(_index_in_oamp_list, &index);
    _reserve(_index_in_oamp_list, &index);
    printf("reserve(expecte:39) index: %d; value: ...%d,%d...\n", index, _index_in_oamp_list[index], _index_in_oamp_list[index+1]);
    _reserve(_index_in_oamp_list, &index);
    _reserve(_index_in_oamp_list, &index);
    _reserve(_index_in_oamp_list, &index);
    printf("reserve(expecte:42) index: %d; value: ...%d,%d...\n", index, _index_in_oamp_list[index], _index_in_oamp_list[index+1]);
    return 0;
}

static bool _reserve(bool* _index_in_oamp_list, int* index) {
    int i = 0;
    for (i=0;i<_INDEX_MAX;i++) if (! _index_in_oamp_list[i]) {
        *index=i;
        _index_in_oamp_list[*index] = 1;
        return true;
    }
    return false;
}

static bool _free(bool* _index_in_oamp_list, int* index) {
   _index_in_oamp_list[*index] = 0;
   return true;
}
