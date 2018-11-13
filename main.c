#include <stdio.h>
#include <unistd.h>

int main(int argc, char const *argv[]) {
    int i = 20;
    printf("Sooooo tired, I guess I'll take a lil power snooze...\n");
    while (i) {
        printf("Zzzz... Zzzzz...\n");
        if (i < 3) {
            printf("<<< TweetSakka >>>");
            break;
        }
        i--;
        sleep(1);
    }
    printf("\nWhat the fuck was that?!?!!\n");
    return 0;
}
