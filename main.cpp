#include "entities.h"
#include "entity.h"

int main () {
    const char * test = "raw test";

    Entities tasks0("0");
    Entities tasks01("01");
    Entity task10("10", Entity::file, "demo.txt");
    Entity task11("11", Entity::raw, test);
    
    tasks0.add(&tasks01);
    tasks01.add(&task10);
    tasks01.add(&task11);

    tasks0.execute();

    return 0;
}
