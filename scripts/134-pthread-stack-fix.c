#define _GNU_SOURCE
#include <pthread.h>
#include <dlfcn.h>
#include <string.h>
#include <errno.h>

#define BUMPED_STACKSIZE (16 * 1024 * 1024)

typedef int (*orig_create_t)(pthread_t *, const pthread_attr_t *,
                              void *(*)(void *), void *);

int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
                    void *(*start_routine)(void *), void *arg) {
    static orig_create_t orig = NULL;
    if (!orig)
        orig = (orig_create_t)dlsym(RTLD_NEXT, "pthread_create");

    int ret = orig(thread, attr, start_routine, arg);
    if (ret != EINVAL)
        return ret;

    pthread_attr_t local_attr;
    if (attr)
        memcpy(&local_attr, attr, sizeof(local_attr));
    else
        pthread_attr_init(&local_attr);
    pthread_attr_setstacksize(&local_attr, BUMPED_STACKSIZE);

    ret = orig(thread, &local_attr, start_routine, arg);
    pthread_attr_destroy(&local_attr);
    return ret;
}
