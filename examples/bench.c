/*
 * ```console
 * $ gcc -o bench-c examples/bench.c -ltokyocabinet -O2
 *
 * $ time ./bench-c 10000000 test.tch
 * bench-c 10000000 test.tch  4.44s user 13.20s system 99% cpu 17.647 total
 * ```
 */

#include <tchdb.h>
#include <unistd.h>

int main(int argc, char **argv) {
  if (argc < 3) {
    fprintf(stderr, "usage: %s count path\n", argv[0]);
    exit(1);
  }

  int64_t limit = tcatoi(argv[1]);
  char *path = argv[2];
  TCHDB *hdb = tchdbnew();
  int ecode;
  bool ok;

  // delete db file if exists
  if( access(path, F_OK ) != -1 ) {
    unlink(path);
  }

  // tune with bnum
  if (!tchdbtune(hdb, limit, 4, 10, 0)) {
    ecode = tchdbecode(hdb);
    fprintf(stderr, "tchdbtune: %s\n", tchdberrmsg(ecode));
    exit(1);
  }
  
  // open db with write mode
  if (!tchdbopen(hdb, path, HDBOWRITER | HDBOCREAT)){
    ecode = tchdbecode(hdb);
    fprintf(stderr, "tchdbopen: %s\n", tchdberrmsg(ecode));
    exit(1);
  }

  char v[20];
  for (int64_t i = 0; i < limit; i++) {
    if (! sprintf(v, "%ld", i)) {
      fprintf(stderr, "error: itoa i=%ld\n", i);
      exit(1);
    };
    if (! tchdbput2(hdb, v, v)) {
      fprintf(stderr, "error: tchdbput2 i=%ld\n", i);
      exit(2);
    }
  }
  
  if (! tchdbclose(hdb)) {
    fprintf(stderr, "tchdbclose: %s\n", tchdberrmsg(ecode));
    exit(3);
  }

  return 0;
};
