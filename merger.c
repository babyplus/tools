#include "merger.h"

int main(int argc, char* argv[]){
    OUTPUT_INIT(argv[2]);
    FILE *fp;
    char str[MAXIMUM_CAPACITY_OF_ROW+1] = {0};
    char last_key[KEY_LENGTH+1] = {0};
    if( (fp=fopen(argv[1],"rt")) == NULL ){
        puts("Fail to open file!");
        exit(1);
    }
  
    OUTPUT(FIRST_ROW);
 
    type_t expected_type = TYPE_INIT;
    while(fgets(str, MAXIMUM_CAPACITY_OF_ROW+1, fp) != NULL){
        char current_key[KEY_LENGTH+1] = {0};
        GET_KEY(current_key, str);

        type_t current_type = TYPE_UNKNOWN;
        GET_TYPE(current_type, str);

        NEW_LINE_OR_NOT(current_key, last_key, expected_type);

        OUTPUT_PLACEHOLDER_IF_THE_TYPE_NO_MATCHED(expected_type, current_type);

        if (expected_type == current_type){
            int i = (DATA_BEGIN_POSITION - 1);
            for (; i < MAXIMUM_CAPACITY_OF_ROW+1 ; i++) if ('\n' == str[i]) break;
            i = i - DATA_BEGIN_POSITION; 
            OUTPUT("%.*s", i, str+DATA_BEGIN_POSITION);
            GET_KEY(last_key, str);
            expected_type = (TYPE_LAST == current_type) ? TYPE_INIT : ++current_type;
        }
        NEXT_LINE:
            ;
    }
    fclose(fp);
    OUTPUT("\n");
    OUTPUT__CLR;
    return 0;
}

