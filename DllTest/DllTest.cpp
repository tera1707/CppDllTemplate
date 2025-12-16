#include "stdafx.h"
#include <windows.h>
#include <stdio.h>

#define VC_DLL_EXPORTS
#include "DllTest.h"

int __cdecl MyAdd(int number1, int number2)
{
	return number1 + number2;
}
