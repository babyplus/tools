docker run -it --rm -v `pwd`:`pwd` -w `pwd` gcc:9.5.0 g++ base64.cpp  -fPIC -shared -o libmybase64.so
