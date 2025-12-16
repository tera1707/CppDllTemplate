#include <windows.h>
#include <string>
#include "framework.h"
#include "WindowsProject1.h"
#include "resource.h"
#include "DllTest.h"

HINSTANCE hInst;
HWND hDlgWnd;

// 世界のナベアツ 3の倍数と3がつく数字の時だけアホになります
// https://www.youtube.com/watch?v=wjXoqcrLBbA

// このコード モジュールに含まれる関数の宣言を転送します:
LRESULT CALLBACK    WndProc(HWND, UINT, WPARAM, LPARAM);
BOOL CALLBACK MyDlgProc(HWND, UINT, WPARAM, LPARAM);

int APIENTRY wWinMain(_In_ HINSTANCE hInstance,
                     _In_opt_ HINSTANCE hPrevInstance,
                     _In_ LPWSTR    lpCmdLine,
                     _In_ int       nCmdShow)
{
    hInst = hInstance;

    DialogBox(hInst, L"MyTestDlgBase_Main", NULL, (DLGPROC)MyDlgProc);

    return (int)0;
}

// ダイアログプロシージャ
BOOL CALLBACK MyDlgProc(HWND hDlg, UINT msg, WPARAM wp, LPARAM lp)
{
    switch (msg) {
    case WM_INITDIALOG:
        break;

    case WM_COMMAND:
        switch (LOWORD(wp)) {
            case IDC_BUTTON1:
                MyAdd(1, 2);
                break;
        }
        return FALSE;
    case WM_CLOSE:
        EndDialog(hDlg, 0);
        return TRUE;
    }
    return FALSE;
}
