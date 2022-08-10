#include <stdint.h>
#include "Minimal.h"
#include <iostream>

//	unit tests would go here
int main()
{
	std::cerr << Minimal_GetVersionString() << std::endl;
	return 0;
}



DLL_EXPORT int	Minimal_GetVersionThousand()
{
	int Version = VERSION_PATCH;
	Version += VERSION_MINOR * 1000;
	Version += VERSION_MAJOR * 1000 * 1000;
#if VERSION_MAJOR>15
#error Version major over 15.x could have 32bit issues
#endif
	return Version;
}

#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)
#define VERSION_STRING(a,b,c)		TOSTRING(a) "." TOSTRING(b) "." TOSTRING(c)

DLL_EXPORT const char*	Minimal_GetVersionString()
{
	return VERSION_STRING( VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH );
}

