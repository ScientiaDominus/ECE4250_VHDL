CXXFLAGS := -std=c++14 -Wall -Werror -pthread
DANGEROUSFLAGS := -O3

SOURCES := $(wildcard *.cpp)
OBJS := $(SOURCES:%.cpp=%.o)


TARGET := matrix-checker.out

.PHONY : all
all : $(TARGET)

$(TARGET) : $(OBJS)
	 $(CXX) $(CXXFLAGS) $(DANGEROUSFLAGS) $^ -o $@

.PHONY : clean
clean :
	rm -rf $(TARGET) $(OBJS)
