format PE GUI
include 'win32ax.inc'
; import data in the same section

;------------------------------------  
	  xor ebx,ebx
	  mov edi,wTitle
	  mov esi,400000h

	  ; +------------------------------+
	  ; | registering the window class |
	  ; +------------------------------+
	  invoke RegisterClass,esp,ebx,MainLoop,ebx,\
	  ebx,esi,ebx,10011h,COLOR_WINDOW+1,ebx,edi
	  ; +--------------------------+
	  ; | creating the main window |
	  ; +--------------------------+
	  push ebx esi ebx ebx 480 640
	  shl esi,9;400000h * 200h = 80000000h = CW_USEDEFAULT
	  invoke CreateWindowEx,ebx,edi,edi,WS_CAPTION + WS_SYSMENU + WS_MINIMIZEBOX + WS_VISIBLE,\
	  esi,esi
	  invoke SetTimer,eax,ebx,10,ebx
	  mov ebp,esp
	  ; +---------------------------+
	  ; | entering the message loop |
	  ; +---------------------------+
message_loop: invoke GetMessage,ebp,ebx,ebx,ebx
	  invoke DispatchMessage,ebp
	  jmp message_loop
	  ; +----------------------+
	  ; | the window procedure |
	  ; +----------------------+
proc MainLoop hWin,uMsg,wParam,lParam
			mov eax,[uMsg]
			dec eax
			je wmCREATE
			dec eax
			je wmDESTROY
			sub eax,WM_TIMER-WM_DESTROY
			je wmTIMER
		   leave
	       jmp dword [DefWindowProc]
wmDESTROY:	invoke KillTimer,[hWin],eax
			invoke ExitProcess,ebx
wmCREATE:	invoke GetDC,[hWin]
			mov [MainHDC],eax
			invoke ChoosePixelFormat,eax,PixFrm	 
			invoke SetPixelFormat,[MainHDC],eax,PixFrm
			test eax,eax;xchg eax,ecx
			je NoPixelFmt;jecxz NoPixelFmt
			invoke wglCreateContext,[MainHDC]
			invoke wglMakeCurrent,[MainHDC],eax;OpenDC
			invoke glClearColor,3E4CCCCDh,3ECCCCCDh,3F000000h
			push 1701h
			lea edi,[glMatrixMode]
			lea esi,[glLoadIdentity]
			call dword [edi]
			call dword [esi];_imp__glLoadIdentity
			mov ecx,9999999Ah
			mov eax,3FB99999h
			mov edx,33333333h 
			invoke glFrustum,ecx,0BFB99999h,ecx,eax,edx,0BFB33333h,edx,03FB33333h,ecx,eax,ebx,40590000h
			push 1700h
			call dword [edi];_imp__glMatrixMode,
			call dword [esi];_imp__glLoadIdentity
			lea edi,[glEnable]
			push 0BA1h
			call dword [edi];_imp__glEnable,
			push 0B50h
			call dword [edi];_imp__glEnable,
			mov esi,4000h
			push esi
			call dword [edi];_imp__glEnable,
			mov edi,1200h 
			invoke glLightfv,esi,edi,dword_40199D
	inc edi 
	invoke glLightfv,esi,edi,dword_40198D
	inc edi
	inc edi 
	invoke glLightfv,esi,edi,dword_40196D
	inc edi 
	invoke glLightfv,esi,edi,dword_40197D
	inc edi
	invoke glLightf,esi,edi,42480000h
	invoke glLightf,esi,edi,428C0000h
	invoke glEnable,0B71h
NoPixelFmt: leave
	retn 10h
wmTIMER: ; No pending messages: draw the scene
	invoke glClear,4100h
	invoke glPushMatrix
	invoke glTranslatef,ebx,ebx,0C1A00000h
	mov edi,3F800000h;1.0
	lea esi,[glRotatef]
	push ebx
	push edi
	push ebx
	push [tmptime]
	call dword [esi];_imp__glRotatef,
	push ebx
	push ebx
	push edi
	push [tmptime]
	call dword [esi];_imp__glRotatef,
	mov esi,0BF800000h;-1.0
	call sub_2
	invoke GetTickCount
	shr eax,4
	push eax
	fild dword [esp];tmptime
	fld st
	fst [tmptime]
	push 40
	fidiv dword [esp];flt_4019E1
	fsin
	fmul [flt_4019DD]
	fstp [flt_4019D5]
	push 35
	fidiv dword [esp];flt_4019E5
	fsin
	fmul [flt_4019DD]
	fstp [flt_4019D9]
	call sub_1
	invoke glRotatef,42B40000h,ebx,edi,ebx
	call sub_1
	fld dword [tmptime]
	push 30
	fidiv dword [esp];flt_4019E9
	fsin
	fmul [flt_4019DD]
	fstp [flt_4019D9]
	invoke glRotatef,42B40000h,ebx,edi,ebx
	call sub_1
	invoke glRotatef,42B40000h,ebx,edi,ebx
	call sub_1
	fld dword [tmptime]
	push 25
	fidiv dword [esp];flt_4019ED
	fsin
	fmul [flt_4019DD]
	fstp [flt_4019D5]
	add esp,20
	invoke glRotatef,42B40000h,ebx,ebx,edi
	call sub_1
	invoke glRotatef,43340000h,ebx,ebx,edi
	call sub_1
	invoke glPopMatrix
	invoke SwapBuffers,[MainHDC]
	leave
	retn 10h
endp
;---------------------------------------------------------------
proc sub_2
	invoke glBegin,7
	invoke glNormal3f,ebx,edi,ebx
	invoke glVertex3f,edi,edi,esi
	invoke glVertex3f,esi,edi,esi
	invoke glVertex3f,esi,edi,edi
	invoke glVertex3f,edi,edi,edi
	invoke glNormal3f,ebx,esi,ebx
	invoke glVertex3f,edi,esi,edi
	invoke glVertex3f,esi,esi,edi
	invoke glVertex3f,esi,esi,esi
	invoke glVertex3f,edi,esi,esi
	invoke glNormal3f,ebx,ebx,esi
	invoke glVertex3f,edi,esi,esi
	invoke glVertex3f,esi,esi,esi
	invoke glVertex3f,esi,edi,esi
	invoke glVertex3f,edi,edi,esi
	invoke glNormal3f,ebx,ebx,edi
	invoke glVertex3f,edi,edi,edi
	invoke glVertex3f,esi,edi,edi
	invoke glVertex3f,esi,esi,edi
	invoke glVertex3f,edi,esi,edi
	invoke glNormal3f,edi,ebx,ebx
	invoke glVertex3f,edi,edi,esi
	invoke glVertex3f,edi,edi,edi
	invoke glVertex3f,edi,esi,edi
	invoke glVertex3f,edi,esi,esi
	invoke glEnd
	mov ecx,3F666666h
	invoke glScalef,ecx,ecx,ecx
	retn
endp
;-----------------------------------------------
proc sub_1	
	mov [count],20
	invoke glPushMatrix
@@:	invoke glTranslatef,4009999Ah,ebx,ebx
	invoke glRotatef,[flt_4019D5],ebx,edi,ebx
	invoke glRotatef,[flt_4019D9],edi,ebx,ebx
	call sub_2
	dec [count]
	jnz @b
	invoke glPopMatrix
	retn
endp
;-------------------------------------------
wTitle db   '3D Model and Animation',0 ;name and class of our window
MainHDC	rd 1
PixFrm PIXELFORMATDESCRIPTOR sizeof.PIXELFORMATDESCRIPTOR,1,\
 37,PFD_TYPE_RGBA,32,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,0,PFD_MAIN_PLANE,0,0
dword_40196D	dd 0, 40000000h, 3F000000h
dword_40197D	dd 0
dword_40198D	dd 3F19999Ah, 3F4CCCCDh, 3F666666h
dword_40199D	dd 3E4CCCCDh
tmptime	rd 1
count	rb 1
flt_4019D5	rd 1
flt_4019D9	rd 1
flt_4019DD	dd 20.0
data import

 library	KERNEL32,	'KERNEL32.DLL',\
			gdi32,		'gdi32.dll',\
			opengl32,	'opengl32.dll',\
			user32,		'USER32.DLL'
 import KERNEL32,\
		GetTickCount,		'GetTickCount',\
	    ExitProcess,		'ExitProcess'
 import user32,\
		RegisterClass,	    'RegisterClassA',\
		CreateWindowEx,     'CreateWindowExA',\
		SetTimer,			'SetTimer',\
		KillTimer,			'KillTimer',\
		GetDC,				'GetDC',\
		DefWindowProc,	    'DefWindowProcA',\
		GetMessage,	    	'GetMessageA',\
		DispatchMessage,    'DispatchMessageA'
 import gdi32,\
		ChoosePixelFormat,	'ChoosePixelFormat',\
		SetPixelFormat,		'SetPixelFormat',\
		SwapBuffers,		'SwapBuffers'
 import opengl32,\		
		wglCreateContext,	'wglCreateContext',\
		wglMakeCurrent,		'wglMakeCurrent',\
		glBegin,			'glBegin',\
		glClearColor,		'glClearColor',\
		glClear,			'glClear',\
		glEnd,				'glEnd',\
		glFrustum,			'glFrustum',\
		glLoadIdentity,		'glLoadIdentity',\
		glMatrixMode,		'glMatrixMode',\
		glRotatef,			'glRotatef',\
		glTranslatef,		'glTranslatef',\
		glVertex3f,			'glVertex3f',\
		glEnable,			'glEnable',\
		glScalef,			'glScalef',\
		glPushMatrix,		'glPushMatrix',\
		glPopMatrix,		'glPopMatrix',\
		glNormal3f,			'glNormal3f',\
		glLightfv,			'glLightfv',\
		glLightf,			'glLightf'
end data
