// #include <iostream>
// #include <fcntl.h>

// using namespace std;

// void set_fl(int fd, int flags)
// {
// 	int val;
// 	if ((val = fcntl(fd, F_GETFL, 0)) < 0)
// 		cerr << "asd";

// 	val |= flags;

// 	if (fcntl(fd, F_SETFL, val) < 0)
// 		cerr << "dsdf";
// }
#include <stdio.h>
int main(int argc, char const *argv[])
{
  FILE *fp;
  char str[] = "this is a tutorial";


  fwrite(str, 2, sizeof(str)/2, fp);
  fclose(fp);
  return 0;
}