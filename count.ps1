function Count{

[CmdletBinding()]
Param(
    [int]$start = (read-host "begin"),
    [int]$end = (read-host "end")
)

$i = $start
$x = $end
    (new-object -com SAPI.SpVoice).speak("Let's begin counting from $i till $x")
 
Do {
     (new-object -com SAPI.SpVoice).speak("$i") 
      $i=$i+1
    } while ($i -le $x) (new-object -com SAPI.SpVoice).speak("That, was the last nummer") 

}
