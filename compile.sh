docker run -it --rm -v `pwd`:`pwd` -w `pwd` gcc:9.5.0 g++ draft.cpp  -fPIC -shared -o libmydraft.so
