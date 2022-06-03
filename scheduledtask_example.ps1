$taskname="poshscheduledtaskexample"

# remove old task by that name
Unregister-ScheduledTask -TaskName $taskname -Confirm:$False -ErrorAction SilentlyContinue

# actions determine _what_ to run
# a single taskscheduler task can have multiple actions, these will execute in order
# to use powershell 7 or higher, use pwsh instead of powershell.exe
$action1=New-ScheduledTaskAction -Execute "powershell.exe" -Argument ".\scheduledscript1.ps1" -WorkingDirectory $PWD
$action2=New-ScheduledTaskAction -Execute "powershell.exe" -Argument ".\scheduledscript2.ps1" -WorkingDirectory $PWD

# the trigger determines _when_ to run the task
# for this example, the task will execute 10 seconds from now
$trigger=New-ScheduledTaskTrigger -Once -At $(Get-Date).AddSeconds(10)

# if you don't use the following battery settings, the tasks won't start on a laptop running from battery
$settings=New-ScheduledTaskSettingsSet -Compatibility Win8 -AllowStartIfOnBatteries:$True -DontStopIfGoingOnBatteries:$True -ExecutionTimeLimit $([TimeSpan]::FromDays(365))

# note that the -Action argument accepts an array of actions
Register-ScheduledTask -TaskName $taskname -Action ($action1,$action2) -Trigger $trigger -Settings $settings
