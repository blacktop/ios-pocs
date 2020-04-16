#define __STDC_FORMAT_MACROS
#include <inttypes.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char const *argv[]) {
    uint64_t *shared_cache_rx_base = NULL;
    syscall(294, &shared_cache_rx_base);
    printf("shared_cache_rx_base: %"PRIu64"\n", shared_cache_rx_base);
    return 0;
}
