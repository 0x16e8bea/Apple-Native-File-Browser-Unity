#include <stdlib.h>
#include <stdbool.h>

const char *DialogHandler_openFile(const char *title, const char *directory, const char *extension, const bool *multiselect);
// const char *title, const char *directory, const char *extension, const bool *multiselect

const char *DialogHandler_openFolder(const char *title, const char *directory, const bool *multiselect);

const char *DialogHandler_saveFile(const char *title, const char *directory, const char *defaultName, const char *extension);
